import 'package:flutter5/injection_container.dart' as di;

class TestConfig {
  static bool isInitialized = false;

  static Future<void> initialize() async {
    if (!isInitialized) {
      await di.init();
      isInitialized = true;
    }
  }
}