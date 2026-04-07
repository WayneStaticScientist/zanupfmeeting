import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/core/constants/meeting.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:zanupfmeeting/shared/models/settings_model.dart';
import 'package:zanupfmeeting/shared/models/user_model.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:zanupfmeeting/features/home/main_screen.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart';
import 'package:zanupfmeeting/shared/models/message_model.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart' as mt;

class LiveMeetingController extends GetxController {
  RxString token = RxString('');
  RxBool audioEnabled = true.obs;
  RxBool cameraEnabled = true.obs;
  RxBool screenShareEnabled = false.obs;
  RxString meetingError = RxString("");
  EventsListener<RoomEvent>? _roomListener;
  RxList<mt.Participant> waitingList = RxList<mt.Participant>();
  Rx<mt.MeetingModel?> meetingModel = Rx<mt.MeetingModel?>(null);
  IO.Socket? socket;
  void initMeeting(mt.MeetingModel model) async {
    final user = UserModel.fromStorage();
    meetingError.value = '';
    if (user == null) {
      return;
    }
    meetingModel.value = model;
    await updateMeeting(model.meetingCode);
    if (meetingError.isNotEmpty) {
      return;
    }
    waitingList.addAll(
      meetingModel.value!.participants.where((e) {
        return e.status == 'pending';
      }).toList(),
    );

    socket = IO.io(
      Net.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      if (meetingModel.value!.status == "Scheduled") {
        return;
      }
      socket!.emit('i-wanna-join', {
        "userId": user.id!,
        "meetingCode": model.meetingCode,
      });
    });

    socket!.on("join-meeting", (_) {
      if (room.value != null) {
        final state = room.value!.connectionState;
        if (state == ConnectionState.connected ||
            state == ConnectionState.reconnecting) {
          return;
        }
      }
      fetchMeetingToken(user, model);
    });

    socket!.on((model.meetingCode), (e) async {
      if (e['event'] == 'started') {
        await updateMeeting(model.meetingCode);
        socket!.emit('i-wanna-join', {
          "userId": user.id!,
          "meetingCode": model.meetingCode,
        });
      }
    });

    socket!.on("can-user-join", (data) {
      final participant = mt.Participant.fromJson(data);
      if (waitingList.indexWhere((e) => e.userId == participant.userId) >= 0) {
        return;
      }
      waitingList.add(participant);
      if (SettingsModel.fromStorage().disableParticipaantsNotifications) return;
      Toaster.withAction(
        "${participant.displayName} wanna join the meeting",
        onAction: () => admitParticipant(participant),
        actionTitle: "Add",
        topic: "User",
      );
    });

    socket!.on("meeting-command", (e) {
      final command = e['command'];
      if (command == MeetingConstants.CMD_REMOVE) {
        closeMeeting();
        Get.offAll(() => ScreenDashboard());
        return;
      }
      if (command == MeetingConstants.CMD_MUTE) {
        switchMic(false);
        return;
      }
      if (command == MeetingConstants.CMD_HIDE_CAMERA) {
        switchVid(false);
        return;
      }
    });

    socket!.on("new-chat-message", (e) {
      messagesSize.value += 1;
      final messageModel = MessageModel.fromJson(e);
      messages.add(messageModel);
      if (SettingsModel.fromStorage().disableMessageNotifications) return;
      Toaster.info("New message from ${messageModel.message}");
    });

    socket!.on("highlight-node", (e) {
      meetingModel.value?.focuseNode = e['focusNode'];
      update();
    });
    socket!.onDisconnect((_) {});
    socket!.connect();
  }

  void closeMeeting() async {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }
    if (room.value != null) {
      await room.value!.localParticipant?.unpublishAllTracks();
      room.value!.disconnect();
      room.value!.dispose();
      room.value = null;
    }
    _roomListener?.dispose();
    _roomListener = null;
    messages.clear();
    meetingError.value = '';
    if (screenShareEnabled.value) {
      screenShare(false);
    }
  }

  void fetchMeetingToken(UserModel model, mt.MeetingModel meeting) async {
    meetingError.value = '';
    final response = await Net.post(
      "/meetings/join/room/participant",
      data: {"userId": model.id, "meetingCode": meeting.meetingCode},
    );
    if (response.hasError) {
      meetingError.value = response.response;
      return;
    }
    token.value = response.body['authToken'];
    startMeeting();
  }

  Rx<Room?> room = Rx<Room?>(null);
  void startMeeting() async {
    room.value = Room(
      roomOptions: RoomOptions(adaptiveStream: true, dynacast: true),
    );
    _roomListener = room.value!.createListener();
    _roomListener!
      ..on<ParticipantConnectedEvent>((_) => update())
      ..on<ParticipantDisconnectedEvent>((_) => update())
      ..on<TrackSubscribedEvent>((_) => update())
      ..on<TrackUnsubscribedEvent>((_) => update())
      ..on<TrackMutedEvent>((_) => update()) // Added: for cam toggle
      ..on<TrackUnmutedEvent>((_) => update());
    try {
      await room.value!.prepareConnection(Net.liveUrl, token.value);
      await room.value!.connect(Net.liveUrl, token.value);
      await room.value!.localParticipant?.setCameraEnabled(cameraEnabled.value);
      await room.value!.localParticipant?.setMicrophoneEnabled(
        audioEnabled.value,
      );
      update();
    } catch (e) {
      log("There was error $e");
      meetingError.value = "LiveKit Connection Error: $e";
    }
  }

  void admitParticipant(mt.Participant participant) async {
    final response = await Net.post(
      "/meetings/room/add-participant",
      data: {
        "meetingCode": meetingModel.value!.meetingCode,
        "participant": participant.toJson(),
      },
    );
    if (response.hasError) {
      return Toaster.error(
        response.response,
        title: "Error Adding participant",
      );
    }
    waitingList.remove(participant);
  }

  void removeParticipant(mt.Participant participant) {
    waitingList.remove(participant);
  }

  void switchMic(bool state) async {
    if (room.value == null) return;
    try {
      await room.value!.localParticipant?.setMicrophoneEnabled(state);
      audioEnabled.value = state;
      update();
    } catch (e) {
      //
    }
  }

  void switchVid(bool state) async {
    if (room.value == null) return;
    try {
      await room.value!.localParticipant?.setCameraEnabled(state);
      cameraEnabled.value = state;
      update();
    } catch (e) {
      //
    }
  }

  void screenShare(bool state) async {
    if (room.value == null) return;
    if (state) {
      if (WebRTC.platformIsAndroid) {
        try {
          bool granted = await Helper.requestCapturePermission();
          if (!granted) return;
          requestBackgroundPermission([bool isRetry = false]) async {
            try {
              bool hasPermissions = await FlutterBackground.hasPermissions;
              if (!isRetry) {
                const androidConfig = FlutterBackgroundAndroidConfig(
                  notificationTitle: 'Screen Sharing',
                  notificationText: 'ZanuPF Meet is sharing the screen.',
                  notificationImportance: AndroidNotificationImportance.normal,
                  notificationIcon: AndroidResource(
                    name: 'livekit_ic_launcher',
                    defType: 'mipmap',
                  ),
                );
                hasPermissions = await FlutterBackground.initialize(
                  androidConfig: androidConfig,
                );
              }
              if (hasPermissions &&
                  !FlutterBackground.isBackgroundExecutionEnabled) {
                await FlutterBackground.enableBackgroundExecution();
              }
              await Future.delayed(const Duration(milliseconds: 500));
            } catch (e) {
              if (!isRetry) {
                return await Future<void>.delayed(
                  const Duration(seconds: 1),
                  () => requestBackgroundPermission(true),
                );
              }
              log('could not publish video: $e');
            }
          }

          await requestBackgroundPermission();
        } catch (e) {
          log("Permission error: $e");
          Toaster.error("$e");
          return;
        }
      }
    }
    try {
      await room.value!.localParticipant?.setScreenShareEnabled(state);
      screenShareEnabled.value = state;
      if (!state) {
        if (lkPlatformIs(PlatformType.android)) {
          try {
            await FlutterBackground.disableBackgroundExecution();
          } catch (error) {
            log('error disabling screen share: $error');
          }
        }
      }
      update();
    } catch (e) {
      Toaster.error("$e", title: 'Screen sharing error');
      log("Error : $e");
      //
    }
  }

  void sendMeetingCommand({
    required String userId,
    required String command,
  }) async {
    await Net.post(
      '/meetings/command',
      data: {
        "meetingCode": meetingModel.value!.meetingCode,
        "command": command,
        "targetUserId": userId,
      },
    );
  }

  RxList<MessageModel> messages = RxList<MessageModel>();
  RxInt messagesSize = RxInt(0);
  void sendMessage(String message) {
    final user = UserModel.fromStorage();
    if (user == null) return;
    if (socket == null || socket!.disconnected) {
      return;
    }
    final messageModel = MessageModel(
      userId: user.id!,
      meetingCode: meetingModel.value!.meetingCode,
      message: message,
      displayName: "${user.firstName} ${user.lastName}",
    );
    socket!.emit("on-event-message", messageModel.toJosn());
    messages.add(messageModel);
  }

  void setSpotlight(String? spotLight) async {
    final response = await Net.put(
      "/meetings/focus-node",
      data: {
        "meetingCode": meetingModel.value!.meetingCode,
        "focusNode": spotLight,
      },
    );
    if (response.hasError) {
      return Toaster.error(response.response, title: "SpotLight error");
    }
  }

  Future<void> updateMeeting(String id) async {
    final response = await Net.get("/meetings/room/$id");
    if (response.hasError) {
      meetingError.value = response.response;
      return;
    }
    meetingModel.value = MeetingModel.fromJson(response.body['meeting']);
  }

  Future<void> exitMeeting() async {
    final response = await Net.delete(
      "/meetings/${meetingModel.value!.meetingCode}",
    );
    if (response.hasError) {
      return Toaster.error(response.response);
    }
    Get.offAll(() => ScreenDashboard());
    Toaster.success("Meeting ended");
  }
}
