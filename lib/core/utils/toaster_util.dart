import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Toaster {
  // Success Toast
  static void success(String message, {String title = "Success"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withAlpha(200),
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // Error Toast
  static void error(String message, {String title = "Error"}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withAlpha(200),
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
}
