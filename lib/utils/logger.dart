import 'package:flutter/foundation.dart';

/// Class Logger terstruktur yang hanya tampil pada mode Debug.
class Logger {
  static void debug(String message) {
    if (kDebugMode) {
      print('[DEBUG] $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      print('[INFO] $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('[WARNING] $message');
    }
  }

  static void error(String message, [dynamic error]) {
    if (kDebugMode) {
      print('[ERROR] $message ${error != null ? "-> $error" : ""}');
    }
  }
}
