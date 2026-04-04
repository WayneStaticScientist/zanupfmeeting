import 'package:get_storage/get_storage.dart';

class SettingsModel {
  bool disableMessageNotifications;
  bool disableParticipaantsNotifications;

  SettingsModel({
    this.disableMessageNotifications = false,
    this.disableParticipaantsNotifications = false,
  });
  factory SettingsModel.fromJSON(data) => SettingsModel(
    disableMessageNotifications: data['disableMessageNotifications'] ?? false,
    disableParticipaantsNotifications:
        data['disableParticipaantsNotifications'] ?? false,
  );
  toJson() {
    return {
      "disableMessageNotifications": disableMessageNotifications,
      'disableParticipaantsNotifications': disableParticipaantsNotifications,
    };
  }

  factory SettingsModel.fromStorage() {
    GetStorage storage = GetStorage();
    final settings = storage.read("settings_");
    if (settings == null) {
      return SettingsModel();
    }
    return SettingsModel.fromJSON(settings);
  }
  void saveSettings() {
    GetStorage storage = GetStorage();
    storage.write("settings_", toJson());
  }
}
