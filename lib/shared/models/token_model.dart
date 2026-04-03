import 'package:get_storage/get_storage.dart';
import 'package:json_annotation/json_annotation.dart';
part 'token_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class TokenModel {
  final String accessToken;
  final String refreshToken;
  String get accessTokenHeader => "Bearer $accessToken";
  String get refreshTokenHeader => "Bearer $refreshToken";
  TokenModel({required this.accessToken, required this.refreshToken});
  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
  static const jsonSchema = _$TokenModelJsonSchema;
  void saveToStorage() {
    GetStorage box = GetStorage();
    box.write('accessToken', accessToken);
    box.write('refreshToken', refreshToken);
  }

  static TokenModel fromStorage() {
    GetStorage box = GetStorage();

    return TokenModel(
      accessToken: box.read('accessToken') ?? '',
      refreshToken: box.read('refreshToken') ?? '',
    );
  }

  static void clearStorage() {
    GetStorage box = GetStorage();
    box.remove('accessToken');
    box.remove('refreshToken');
  }
}
