import 'package:get/get.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/main.dart';
import 'package:zanupfmeeting/shared/models/upload_document_model.dart';

class DocumentControllers extends GetxController {
  RxList<UploadDocumentModel> documents = RxList();
  RxInt documentPage = RxInt(1);
  RxString documentError = ''.obs;
  RxBool documentsLoading = false.obs;
  Future<void> fetctDocumentsOverNetwork({
    required String meetingCode,
    int page = 1,
  }) async {
    final isar = IsarStatic.isar;
    if (isar == null) return;
    documentsLoading.value = true;
    documentError.value = '';
    final response = await Net.get(
      "/meetings/documents?page=$page&meetingCode=$meetingCode",
    );
    if (response.hasError) {
      documentError.value = response.response;
      return;
    }
    final List<UploadDocumentModel> data =
        (response.body['documents'] as List<dynamic>?)
            ?.map((e) => UploadDocumentModel.fromJSON(e))
            .toList() ??
        [];
    final remoteIds = data.map((doc) => doc.id).toList();
    await isar.write((isar) async {
      final existingDocs = isar.uploadDocumentModels
          .where()
          .anyOf(remoteIds, (q, String id) => q.idEqualTo(id))
          .findAll();

      final existingMap = {for (var doc in existingDocs) doc.id: doc};
      for (var incoming in data) {
        final match = existingMap[incoming.id];
        if (match != null) {
          incoming.localPath = match.localPath;
        }
      }
      isar.uploadDocumentModels.putAll(data);
    });
    documents.value = data;
  }
}
