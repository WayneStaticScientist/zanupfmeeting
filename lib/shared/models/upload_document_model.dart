import 'package:isar_plus/isar_plus.dart';
part 'upload_document_model.g.dart';

@collection
class UploadDocumentModel {
  dynamic uploader;
  final String id;
  final String fileType;
  final String fileName;
  final String filePath;
  final String meetingCode;
  String localPath = '';
  UploadDocumentModel({
    required this.id,
    required this.fileType,
    required this.fileName,
    required this.filePath,
    required this.meetingCode,
  });
}
