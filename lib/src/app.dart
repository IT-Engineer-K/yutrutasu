import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/yaru_koto_controller.dart';
import 'views/yaru_koto_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        // YaruKotoControllerを作成
        final yaruKotoController = YaruKotoController();
        
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja', ''),
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) => 'ゆるたす',
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
              primary: const Color(0xFF66BB6A),
            ),
            textTheme: const TextTheme().apply(
              fontFamily: 'NotoSansJP',
              bodyColor: Color(0xFF424242),
              displayColor: Color(0xFF424242),
            ).copyWith(
              bodyMedium: const TextStyle(
                color: Color(0xFF424242),
                fontSize: 16,
                fontFamily: 'NotoSansJP',
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFE8F5E8),
              foregroundColor: Color(0xFF2E7D2E),
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Color(0xFF2E7D2E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansJP',
              ),
            ),
            // ダイアログのテーマを設定
            dialogTheme: const DialogTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              titleTextStyle: TextStyle(
                color: Color(0xFF2E7D2E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansJP',
              ),
              contentTextStyle: TextStyle(
                color: Color(0xFF424242),
                fontSize: 16,
                fontFamily: 'NotoSansJP',
              ),
            ),
            // ポップアップメニューのテーマを設定
            popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              textStyle: TextStyle(
                color: Color(0xFF424242),
                fontSize: 14,
                fontFamily: 'NotoSansJP',
              ),
            ),
            // 入力フィールドのテーマを設定
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(
                color: Color(0xFF66BB6A),
                fontFamily: 'NotoSansJP',
              ),
              hintStyle: TextStyle(
                color: Color(0xFF9E9E9E),
                fontFamily: 'NotoSansJP',
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF66BB6A),
            ),
            textTheme: const TextTheme().apply(
              fontFamily: 'NotoSansJP',
              bodyColor: Color(0xFFE0E0E0),
              displayColor: Color(0xFFE0E0E0),
            ).copyWith(
              bodyMedium: const TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 16,
                fontFamily: 'NotoSansJP',
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2E4A2E),
              foregroundColor: Color(0xFF81C784),
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Color(0xFF81C784),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansJP',
              ),
            ),
            // ダークテーマのダイアログテーマを設定
            dialogTheme: const DialogTheme(
              backgroundColor: Color(0xFF2E2E2E),
              surfaceTintColor: Colors.transparent,
              titleTextStyle: TextStyle(
                color: Color(0xFF81C784),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansJP',
              ),
              contentTextStyle: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 16,
                fontFamily: 'NotoSansJP',
              ),
            ),
            // ダークテーマのポップアップメニューテーマを設定
            popupMenuTheme: const PopupMenuThemeData(
              color: Color(0xFF2E2E2E),
              surfaceTintColor: Colors.transparent,
              textStyle: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 14,
                fontFamily: 'NotoSansJP',
              ),
            ),
            // ダークテーマの入力フィールドのテーマを設定
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(
                color: Color(0xFF66BB6A),
                fontFamily: 'NotoSansJP',
              ),
              hintStyle: TextStyle(
                color: Color(0xFF757575),
                fontFamily: 'NotoSansJP',
              ),
            ),
          ),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case YaruKotoListView.routeName:
                  default:
                    return YaruKotoListView(controller: yaruKotoController);
                }
              },
            );
          },
        );
      },
    );
  }
}
