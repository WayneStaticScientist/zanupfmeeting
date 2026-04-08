import 'dart:io' show Directory;

import 'package:get/get.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
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

  RxDouble downloadProgress = 0.0.obs;
  RxBool downloadingDocument = false.obs;
  RxString downloadId = ''.obs;
  Future<void> downloadDocument(UploadDocumentModel model) async {
    final isar = IsarStatic.isar;
    if (isar == null) return Toaster.error("database not initialized");
    downloadingDocument.value = true;
    downloadId.value = model.id;
    Directory? appDocDir = await getExternalStorageDirectory();
    String savePath = "${appDocDir!.path}/${model.id}";
    downloadId.value = '';
    final response = await Net.download(
      '/meetings/document/${model.id}',
      savePath,
      onReceiveProgress: (received, total) {
        downloadProgress.value = (received / total) * 100;
      },
    );
    if (response.hasError) {
      downloadingDocument.value = false;
      return Toaster.error(response.response);
    }
    model.localPath = savePath;
    await isar.write((isar) async {
      isar.uploadDocumentModels.put(model);
    });
    await fetctDocumentsOverNetwork(meetingCode: model.meetingCode);
    downloadingDocument.value = false;
    Toaster.success("downloaded success");
    openDocument(model, retried: true);
  }

  void openDocument(UploadDocumentModel model, {bool retried = false}) async {
    if (model.localPath.isEmpty && retried == false) {
      return downloadDocument(model);
    }
    await OpenFilex.open(model.localPath);
  }
}
