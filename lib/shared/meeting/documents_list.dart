import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zanupfmeeting/features/meeting/controllers/document_controllers.dart';
import 'package:zanupfmeeting/features/meeting/controllers/live_meeting_controller.dart';
import 'package:zanupfmeeting/shared/models/upload_document_model.dart';

class DocumentsList extends StatefulWidget {
  const DocumentsList({super.key});
  @override
  State<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  final _documentController = Get.find<DocumentControllers>();
  final _liveMeetingController = Get.find<LiveMeetingController>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((e) {
      _onLoading();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh({int page = 1}) async {
    await _documentController.fetctDocumentsOverNetwork(
      meetingCode: _liveMeetingController.meetingModel.value?.meetingCode ?? '',
      page: page,
    );
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await _documentController.fetctDocumentsOverNetwork(
      meetingCode: _liveMeetingController.meetingModel.value?.meetingCode ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(() {
              if (_documentController.documentsLoading.value &&
                  _documentController.documents.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.redAccent),
                );
              }
              final docs = _documentController.documents;
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropMaterialHeader(
                  backgroundColor: Colors.redAccent,
                  color: Colors.white,
                ),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: docs.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          return Obx(
                            () => _DocumentCard(
                              doc: doc,
                              progress:
                                  _documentController.downloadProgress.value,
                              fileInDowload:
                                  _documentController.downloadId.value,
                            ),
                          );
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search by filename or code...",
              prefixIcon: const Icon(LucideIcons.search, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {},
              ),
              filled: true,
              fillColor: Colors.grey.withAlpha(30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.fileX, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No documents found",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final double progress;
  final String fileInDowload;
  final UploadDocumentModel doc; // UploadDocumentModel

  const _DocumentCard({
    required this.doc,
    required this.progress,
    required this.fileInDowload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(30)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.find<DocumentControllers>().openDocument(doc);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildFileIcon(doc.fileType),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.fileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withAlpha(30),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              doc.fileType.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (fileInDowload == doc.id) ...[
                  "downloading $progress%".text(
                    style: TextStyle(color: Colors.white),
                  ),
                ] else
                  Icon(
                    LucideIcons.chevronRight,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(String type) {
    Color color;
    IconData icon;

    switch (type.toLowerCase()) {
      case 'image':
        color = Colors.green;
        icon = LucideIcons.image;
      case 'video':
        color = Colors.deepOrange;
        icon = LucideIcons.video;
      case 'audio':
        color = Colors.pinkAccent;
        icon = LucideIcons.music;
      case 'pdf':
        color = Colors.redAccent;
        icon = LucideIcons.fileText;
        break;
      case 'doc':
      case 'docx':
        color = Colors.blue;
        icon = LucideIcons.fileEdit;
        break;
      case 'xls':
      case 'xlsx':
        color = Colors.green;
        icon = LucideIcons.fileSpreadsheet;
        break;
      default:
        color = Colors.orange;
        icon = LucideIcons.file;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color),
    );
  }
}
