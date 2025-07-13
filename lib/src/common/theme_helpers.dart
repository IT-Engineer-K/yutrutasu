import 'package:flutter/material.dart';

/// テーマに関連するヘルパー関数を提供するクラス
class ThemeHelpers {
  /// ライトモードでは白、ダークモードでは濃いグレーのカード色を返す
  static Color getCardColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? const Color(0xFF424242) // ダークモードでは濃いグレー
        : Colors.white; // ライトモードでは白
  }

  /// カードに適した影の色を返す
  static Color getShadowColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? Colors.black.withOpacity(0.3) // ダークモードでは黒い影
        : Colors.grey.withOpacity(0.1); // ライトモードではグレーの影
  }

  /// カードの境界線色を返す
  static Color getBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.colorScheme.outline.withOpacity(0.3);
  }
}
