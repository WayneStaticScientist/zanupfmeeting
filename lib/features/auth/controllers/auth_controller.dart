import 'package:get/get.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/data/auth_interceptor.dart';
import 'package:zanupfmeeting/core/utils/toaster_util.dart';
import 'package:zanupfmeeting/features/home/main_screen.dart';
import 'package:zanupfmeeting/shared/models/user_model.dart';
import 'package:zanupfmeeting/features/auth/screens/screen_login.dart';
import 'package:zanupfmeeting/features/auth/controllers/user_controller.dart';

class AuthController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    authorizeUser();
  }

  RxBool isLoading = false.obs;
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    final response = await Net.post(
      "/users/login",
      data: {"email": email, "password": password},
    );
    isLoading.value = false;
    if (response.hasError) {
      return Toaster.error(response.response, title: "Login Error");
    }
    Get.find<UserController>().updateUserData(response.body);
    Toaster.success("Login Successful", title: "Login");
    Get.to(() => ScreenDashboard());
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String idNumber,
    required String dob,
    required String city,
    required String password,
  }) async {
    isLoading.value = true;
    final response = await Net.post(
      "/users/register",
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "city": city,
        "email": email,
        "phoneNumber": phone,
        "idNumber": idNumber,
        "dateOfBirthday": dob,
        "password": password,
      },
    );
    isLoading.value = false;
    if (response.hasError) {
      return Toaster.error(response.response, title: "Register Error");
    }
    Get.find<UserController>().updateUserData(response.body);
    Toaster.success("Register Successful", title: "Register");
    Get.to(() => ScreenDashboard());
  }

  void authorizeUser() async {
    if (UserModel.fromStorage() == null) return;
    final response = await AuthenticationInterceptor.requestToken();
    if (response.hasError && response.statusCode == 401) {
      UserModel.clearStorage();
      Get.offAll(() => LoginScreen());
      return;
    }
    if (response.hasError) return;
    Get.find<UserController>().updateUserData(response.body);
  }
}
