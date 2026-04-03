import 'dart:developer';

import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:zanupfmeeting/shared/models/user_model.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart' as mt;

class LiveMeetingController extends GetxController {
  RxString token = RxString('');
  RxBool audioEnabled = true.obs;
  RxBool cameraEnabled = true.obs;
  RxString meetingError = RxString("");
  EventsListener<RoomEvent>? _roomListener;
  RxList<mt.Participant> waitingList = RxList<mt.Participant>();
  Rx<mt.MeetingModel?> meetingModel = Rx<mt.MeetingModel?>(null);
  IO.Socket? socket;
  void initMeeting(mt.MeetingModel model) {
    final user = UserModel.fromStorage();
    if (user == null) {
      return;
    }
    meetingModel.value = model;
    socket = IO.io(
      Net.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );
    socket!.onConnect((_) {
      socket!.emit('i-wanna-join', {
        "userId": user.id!,
        "meetingCode": model.meetingCode,
      });
    });
    socket!.on("join-meeting", (_) {
      fetchMeetingToken(user, model);
    });
    socket!.on("can-user-join", (data) {
      final participant = mt.Participant.fromJson(data);
      if (waitingList.indexWhere((e) => e.userId == participant.userId) >= 0) {
        return;
      }
      Toaster.withAction(
        "${participant.displayName} wanna join the meeting",
        onAction: () => admitParticipant(participant),
        actionTitle: "Add",
        topic: "User",
      );
    });
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
      Toaster.error(response.response, title: "Error Adding participant");
    }
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
}
