import 'package:get_storage/get_storage.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class UserModel {
  @JsonKey(name: '_id')
  final String? id;
  final String email;
  final String firstName;
  final String lastName;
  final String? password;
  final String phoneNumber;
  final List<String> roles;
  final String? dateOfBirthday;
  final String? idNumber;
  final String? city;
  final String? role;
  final String? chatToken;
  UserModel({
    this.id,
    this.city,
    this.password,
    this.idNumber,
    this.chatToken,
    required this.roles,
    required this.email,
    this.role,
    this.dateOfBirthday,
    required this.lastName,
    required this.firstName,
    required this.phoneNumber,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  static const jsonSchema = _$UserModelJsonSchema;
  void saveToStorage() {
    GetStorage box = GetStorage();
    box.write('user', toJson());
  }

  static UserModel? fromStorage() {
    GetStorage box = GetStorage();
    if (!box.hasData('user')) return null;
    return UserModel.fromJson(box.read('user'));
  }

  static void clearStorage() {
    GetStorage box = GetStorage();
    box.remove('user');
  }
}
