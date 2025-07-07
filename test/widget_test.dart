// ゆるたす - ウィジェットテスト
//
// このファイルはUIコンポーネントの動作をテストします。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurutasu/src/app.dart';
import 'package:yurutasu/src/settings/settings_controller.dart';
import 'package:yurutasu/src/settings/settings_service.dart';

void main() {
  group('YurutasuApp Widget Tests', () {
    testWidgets('アプリが正常に起動する', (WidgetTester tester) async {
      // テスト用の設定コントローラーを作成
      final settingsController = SettingsController(SettingsService());
      await settingsController.loadSettings();

      // アプリウィジェットをビルド
      await tester.pumpWidget(MyApp(settingsController: settingsController));

      // アプリバーのタイトルが表示されることを確認
      expect(find.text('🌱 ゆるたす'), findsOneWidget);
      expect(find.text('プロジェクトリスト'), findsOneWidget);
    });

    testWidgets('初期状態でプロジェクトが空の場合のメッセージ表示', (WidgetTester tester) async {
      final settingsController = SettingsController(SettingsService());
      await settingsController.loadSettings();

      await tester.pumpWidget(MyApp(settingsController: settingsController));
      
      // 複数回pumpして非同期処理を完了させる
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // 空の状態のメッセージが表示されることを確認
      expect(find.text('まだプロジェクトがありません'), findsOneWidget);
      expect(find.text('下のボタンで新しいプロジェクトを\n追加してみましょう 🌱'), findsOneWidget);
    });

    testWidgets('フローティングアクションボタンが表示される', (WidgetTester tester) async {
      final settingsController = SettingsController(SettingsService());
      await settingsController.loadSettings();

      await tester.pumpWidget(MyApp(settingsController: settingsController));
      await tester.pump(); // pumpAndSettleを使わずにpumpを使用

      // フローティングアクションボタンが表示されることを確認
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
