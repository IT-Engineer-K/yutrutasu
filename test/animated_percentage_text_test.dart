import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurutasu/src/widgets/animated_percentage_text.dart';

void main() {
  group('AnimatedPercentageText Widget Tests', () {
    testWidgets('初期値が正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedPercentageText(
              percentage: 50.0,
            ),
          ),
        ),
      );

      expect(find.text('50.0%'), findsOneWidget);
    });

    testWidgets('パーセンテージが変更されたときにアニメーションが開始される', (WidgetTester tester) async {
      double testPercentage = 30.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    AnimatedPercentageText(
                      percentage: testPercentage,
                      duration: const Duration(milliseconds: 300),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          testPercentage = 70.0;
                        });
                      },
                      child: const Text('Change'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // 初期値を確認
      expect(find.text('30.0%'), findsOneWidget);

      // ボタンをタップして値を変更
      await tester.tap(find.text('Change'));
      await tester.pump();

      // アニメーション中の中間値が表示されることを確認
      await tester.pump(const Duration(milliseconds: 150));
      
      // 最終的に新しい値になることを確認
      await tester.pumpAndSettle();
      expect(find.text('70.0%'), findsOneWidget);
    });

    testWidgets('小数点の桁数が正しく設定される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedPercentageText(
              percentage: 33.333,
              decimalPlaces: 2,
            ),
          ),
        ),
      );

      expect(find.text('33.33%'), findsOneWidget);
    });

    testWidgets('スタイルが正しく適用される', (WidgetTester tester) async {
      const testStyle = TextStyle(
        fontSize: 24,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedPercentageText(
              percentage: 75.5,
              style: testStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('75.5%'));
      expect(textWidget.style?.fontSize, 24);
      expect(textWidget.style?.color, Colors.red);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });
  });
}
