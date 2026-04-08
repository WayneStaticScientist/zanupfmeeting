import 'package:isar_plus/isar_plus.dart';
part 'upload_document_model.g.dart';

@collection
class UploadDocumentModel {
  dynamic uploader;
  final String id;
  final String fileType;
  final String fileName;
  final String meetingCode;
  String localPath = '';
  UploadDocumentModel({
    required this.id,
    required this.fileType,
    required this.fileName,
    required this.meetingCode,
  });
  factory UploadDocumentModel.fromJSON(data) {
    return UploadDocumentModel(
      id: data['_id'],
      fileType: data['fileType'] ?? '',
      fileName: data['fileName'] ?? '',
      meetingCode: data['meetingCode'],
    );
  }
}
