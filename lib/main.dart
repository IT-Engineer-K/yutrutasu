import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/services/admob_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 環境変数をロード
    await dotenv.load(fileName: ".env");
    
    // AdMobを初期化
    await AdMobService.initialize();
    
    // 開発中はテストデバイスを設定（実機でのテスト時に有効）
    if (kDebugMode) {
      AdMobService.setTestDeviceIds(['33BE2250B43518CCDA7DE426D04EE231']); // 一般的なテストデバイスID
    }
    
    // Set up the SettingsController, which will glue user settings to multiple
    // Flutter Widgets.
    final settingsController = SettingsController(SettingsService());

    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.
    await settingsController.loadSettings();

    // Run the app and pass in the SettingsController. The app listens to the
    // SettingsController for changes, then passes it further down to the
    // SettingsView.
    runApp(MyApp(settingsController: settingsController));
  } catch (e) {
    debugPrint('Error during app initialization: $e');
    // エラーが発生してもアプリは起動させる
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();
    runApp(MyApp(settingsController: settingsController));
  }
}
