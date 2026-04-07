import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zanupfmeeting/shared/models/user_model.dart';
import 'package:zanupfmeeting/features/home/main_screen.dart';
import 'package:zanupfmeeting/features/auth/screens/screen_login.dart';
import 'package:zanupfmeeting/shared/models/upload_document_model.dart';
import 'package:zanupfmeeting/features/auth/controllers/auth_controller.dart';
import 'package:zanupfmeeting/features/auth/controllers/user_controller.dart';
import 'package:zanupfmeeting/features/meeting/controllers/meeting_controller.dart';
import 'package:zanupfmeeting/features/meeting/controllers/live_meeting_controller.dart';

class IsarStatic {
  static Isar? isar;
}

Future<void> _checkPermissions() async {
  var status = await Permission.bluetooth.request();
  if (status.isPermanentlyDenied) {
    //print('Bluetooth Permission disabled');
  }
  status = await Permission.bluetoothConnect.request();
  if (status.isPermanentlyDenied) {
    // print('Bluetooth Connect Permission disabled');
  }
}

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await _checkPermissions();
  final dir = await getApplicationDocumentsDirectory();
  IsarStatic.isar = Isar.open(
    schemas: [UploadDocumentModelSchema],
    directory: dir.path,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.fromStorage();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZanupfMeeting',
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
        Get.put(AuthController());
        Get.put(MeetingController());
        Get.put(LiveMeetingController());
      }),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: user != null ? const ScreenDashboard() : const LoginScreen(),
    );
  }
}
