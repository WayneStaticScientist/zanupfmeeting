import 'dart:math';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zanupfmeeting/data/net_connection.dart';
import 'package:zanupfmeeting/shared/models/user_model.dart';
import 'package:zanupfmeeting/shared/models/token_model.dart';
import 'package:zanupfmeeting/shared/models/response_model.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class AuthenticationInterceptor extends Interceptor {
  static Dio dio = Dio();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers["Authorization"] =
        TokenModel.fromStorage().accessTokenHeader;
    options.headers["device"] = await getDeviceId();
    options.headers['User-Agent'] = 'ZanuPFMeet Mobile';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final response = await requestToken();
        if (!response.hasError) {
          err.requestOptions.headers["Authorization"] =
              TokenModel.fromStorage().accessTokenHeader;
          err.requestOptions.headers["device"] = await getDeviceId();
          final retryResponse = await dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        }
      } on DioException catch (e) {
        return handler.next(e);
      }
    }
    return handler.next(err);
  }

  static Future<ResponseModel> requestToken() async {
    final mobileDeviceIdentifier = await getDeviceId();
    try {
      final response = await dio.post(
        "${Net.baseUrl}/users/tokens",
        options: Options(
          headers: {
            "device": mobileDeviceIdentifier,
            "Authorization": TokenModel.fromStorage().refreshTokenHeader,
          },
        ),
      );
      final model = TokenModel(
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );
      model.saveToStorage();
      return ResponseModel(
        body: response.data,
        hasError: false,
        statusCode: 200,
        response: "Success",
      );
    } on DioException catch (e) {
      final response = await Net.getError(e);
      if (response.statusCode == 401) {
        UserModel.clearStorage();
        TokenModel.clearStorage();
      }
      return response;
    }
  }
}

Future<String> getDeviceId() async {
  String? id = await MobileDeviceIdentifier().getDeviceId();
  if (id != null && id.trim().isNotEmpty) return id;
  GetStorage box = GetStorage();
  id = box.read('deviceIdapp');
  if (id != null && id.trim().isNotEmpty) return id;
  id =
      "x${10000 + Random().nextInt(100000)}-${DateTime.now().toIso8601String()}";
  box.write("deviceIdapp", id);
  return id;
}
