import 'package:get/get.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/shared/models/meeting_model.dart';

class MeetingController extends GetxController {
  RxString error = "".obs;
  RxInt lastPage = 2.obs;
  RxBool isLoading = false.obs;
  RxList<MeetingModel> meetings = <MeetingModel>[].obs;
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
    lastPage.value = response.body['meta']['lastPage'] as int;
  }
}
