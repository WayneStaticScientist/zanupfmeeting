import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

mixin MeetingLinkHandler<T extends StatefulWidget> on State<T> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    _appLinks = AppLinks();

    // 1. Handle "Cold Start" (App was closed, then opened by link)
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _processUri(initialUri);
    }

    // 2. Handle "Warm Start" (App was in background/foreground)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _processUri(uri);
    });
  }

  void _processUri(Uri uri) {
    // Logic to extract code: https://mydomain.com/meeting/XYZ-123
    if (uri.pathSegments.contains('meeting')) {
      final index = uri.pathSegments.indexOf('meeting');
      if (index != -1 && index + 1 < uri.pathSegments.length) {
        String code = uri.pathSegments[index + 1];
        onMeetingCodeReceived(code);
      }
    }
  }

  // This is the "hook" you will implement in your screen
  void onMeetingCodeReceived(String code);

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }
}
