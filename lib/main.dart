import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zanupfmeeting/features/auth/controllers/auth_controller.dart';
import 'package:zanupfmeeting/features/auth/controllers/user_controller.dart';
import 'package:zanupfmeeting/features/auth/screens/screen_login.dart';
import 'package:zanupfmeeting/features/home/main_screen.dart';
import 'package:zanupfmeeting/features/meeting/controllers/meeting_controller.dart';
import 'package:zanupfmeeting/shared/models/user_model.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
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
      }),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: user != null ? const ScreenDashboard() : const LoginScreen(),
    );
  }
}
