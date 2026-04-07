import 'dart:ui';

import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zanupfmeeting/shared/widgets/avatar.dart';
import 'package:zanupfmeeting/shared/widgets/blur_circle.dart';
import 'package:zanupfmeeting/shared/widgets/meeting_widget.dart';
import 'package:zanupfmeeting/shared/dialogs/new_meeting_modal.dart';
import 'package:zanupfmeeting/features/settings/screen_settings.dart';
import 'package:zanupfmeeting/features/meeting/hook/meeting_hook.dart';
import 'package:zanupfmeeting/shared/dialogs/join_meeting_modal.dart';
import 'package:zanupfmeeting/shared/dialogs/schedule_meeting_modal.dart';
import 'package:zanupfmeeting/features/auth/controllers/user_controller.dart';
import 'package:zanupfmeeting/features/meeting/screens/conference_loader.dart';
import 'package:zanupfmeeting/features/meeting/controllers/meeting_controller.dart';

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard>
    with SingleTickerProviderStateMixin, MeetingLinkHandler {
  final _refreshController = RefreshController();
  final _userController = Get.find<UserController>();
  final _meetingController = Get.find<MeetingController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((e) {
      _meetingController.fetchMeetings();
    });
  }

  Future<void> onLoad({int page = 1}) async {
    await _meetingController.fetchMeetings(page: page);
    if (page == 1) {
      _refreshController.refreshCompleted();
      _refreshController.resetNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  void onMeetingCodeReceived(String code) {
    Get.to(() => MeetingSearchLoader(meetingCode: code));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: BlurCircle(
              color: colorScheme.primary.withAlpha(50),
              size: 300,
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: BlurCircle(
              color: colorScheme.secondary.withAlpha(20),
              size: 250,
            ),
          ),

          SafeArea(
            child: SmartRefresher(
              onRefresh: () => onLoad(),
              onLoading: () async {
                if (_meetingController.lastPage.value <=
                    _meetingController.meetingsPage.value) {
                  return _refreshController.loadNoData();
                }
                await onLoad(page: _meetingController.meetingsPage.value + 1);
              },
              controller: _refreshController,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Top App Bar Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  _userController.user.value!.firstName,
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Avatar(),
                        ],
                      ),
                    ),
                  ),

                  // Action Grid
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        bottom: 24,
                      ),
                      child: Row(
                        children: [
                          _buildQuickAction(
                            context,
                            icon: Icons.add_rounded,
                            label: "New",
                            color: colorScheme.primary,
                            onTap: () => _showCreateMeetingModal(context),
                          ),
                          const SizedBox(width: 16),
                          _buildQuickAction(
                            context,
                            icon: Icons.videocam_rounded,
                            label: "Join",
                            color: colorScheme.secondary,
                            onTap: () => _showJoinMeetingModal(context),
                          ),
                          const SizedBox(width: 16),
                          _buildQuickAction(
                            context,
                            icon: Icons.calendar_today_rounded,
                            label: "Schedule",
                            color: Colors.orange,
                            onTap: () => _showScheduleModal(context),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Upcoming Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "Meetings",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // List of Meetings
                  Obx(() {
                    if (_meetingController.isLoading.value) {
                      return SliverFillRemaining(
                        child: CircularProgressIndicator().center(),
                      );
                    }
                    if (_meetingController.error.value.isNotEmpty) {
                      return SliverFillRemaining(
                        child: _meetingController.error.value.text().center(),
                      );
                    }
                    if (_meetingController.meetings.isEmpty) {
                      return SliverFillRemaining(
                        child: Text("No meetings found").center(),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final meeting = _meetingController.meetings[index];
                          return MeetingWidget(meeting: meeting);
                        }, childCount: _meetingController.meetings.length),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(colorScheme),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withAlpha(70)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, "Home", colorScheme.primary),
          _navItem(Icons.folder_open_rounded, "Files", Colors.grey),
          _navItem(
            Icons.settings_outlined,
            "Settings",
            Colors.grey,
          ).onTap(() => Get.to(() => ScreenSettings())),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showCreateMeetingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: NewMeetingModal(setModalState: setModalState),
        ),
      ),
    );
  }

  void _showScheduleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ScheduleMeetingModal(setModalState: setModalState),
        ),
      ),
    );
  }

  void _showJoinMeetingModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: JoinMeetingModal(setModalState: setModalState),
        ),
      ),
    );
  }
}
