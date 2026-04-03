import 'package:get/get.dart';
import 'package:zanupfmeeting/shared/models/user_model.dart';
import 'package:zanupfmeeting/shared/models/token_model.dart';

class UserController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);
  @override
  void onInit() {
    super.onInit();
    user.value = UserModel.fromStorage();
  }

  void updateUserData(dynamic data) {
    user.value = UserModel.fromJson(data['user']);
    user.value!.saveToStorage();
    final token = TokenModel(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
    token.saveToStorage();
  }
}
