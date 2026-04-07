import 'package:get/get.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart';
import 'package:zanupfmeeting/features/meeting/screens/conference_room.dart';

class MeetingController extends GetxController {
  RxString error = "".obs;
  RxInt lastPage = 2.obs;
  RxBool isLoading = false.obs;
  RxList<MeetingModel> meetings = <MeetingModel>[].obs;
  RxInt meetingsPage = RxInt(1);
  Future<void> fetchMeetings({int page = 1, int limit = 10}) async {
    isLoading.value = true;
    error.value = "";
    final response = await Net.get("/meetings/all?page=$page&limit=$limit");
    isLoading.value = false;
    if (response.hasError) {
      error.value = response.response;
      return;
    }
    if (page == 1) meetings.clear();
    meetings.addAll(
      (response.body['meetings'] as List?)
              ?.map((e) => MeetingModel.fromJson(e))
              .toList() ??
          [],
    );
    meetingsPage.value = response.body['meta']['page'] as int;
    lastPage.value = response.body['meta']['lastPage'] as int;
  }

  RxBool creatingMeeting = false.obs;
  Future<void> createImmediateMeeting({
    required String roomName,
    required bool isPublic,
  }) async {
    creatingMeeting.value = true;
    final response = await Net.post(
      "/meetings/create/room",
      data: {"room": roomName, "isPublic": isPublic},
    );
    creatingMeeting.value = false;
    if (response.hasError) {
      return Toaster.error(response.response, title: "Create Meeting Error");
    }
    fetchMeetings();
    Get.off(
      () => ScreenConferenceRoom(
        meetingModel: MeetingModel.fromJson(response.body['meeting']),
      ),
    );
    Toaster.success("Meeting Created", title: "Create Meeting");
  }

  Future<void> scheduleMeeting({
    required String roomName,
    required bool isPublic,
    required String date,
    required String duration,
  }) async {
    creatingMeeting.value = true;
    final response = await Net.post(
      "/meetings/schedule/room",
      data: {
        "room": roomName,
        "isPublic": isPublic,
        "date": date,
        "duration": duration,
      },
    );
    creatingMeeting.value = false;
    if (response.hasError) {
      return Toaster.error(response.response, title: "Create Meeting Error");
    }
    fetchMeetings();
    Get.off(
      () => ScreenConferenceRoom(
        meetingModel: MeetingModel.fromJson(response.body['meeting']),
      ),
    );
    Toaster.success("Meeting Created", title: "Create Meeting");
  }
}
