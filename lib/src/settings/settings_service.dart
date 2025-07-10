import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// Uses SharedPreferences to persist user settings locally.
class SettingsService {
  static const String _themeModeKey = 'theme_mode';

  /// Loads the User's preferred ThemeMode from local storage.
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey);
    
    if (themeModeIndex == null) {
      return ThemeMode.system;
    }
    
    switch (themeModeIndex) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Persists the user's preferred ThemeMode to local storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    int themeModeIndex;
    
    switch (theme) {
      case ThemeMode.system:
        themeModeIndex = 0;
        break;
      case ThemeMode.light:
        themeModeIndex = 1;
        break;
      case ThemeMode.dark:
        themeModeIndex = 2;
        break;
    }
    
    await prefs.setInt(_themeModeKey, themeModeIndex);
  }
}
