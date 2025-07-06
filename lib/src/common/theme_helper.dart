import 'package:flutter/material.dart';

/// テーマ関連のヘルパークラス
/// ダイアログやUI要素の共通スタイリングを提供
class ThemeHelper {
  /// ダイアログのヘッダー行を生成
  static Widget buildDialogHeader({
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// 標準的なテキストフィールド装飾を取得
  static InputDecoration getTextFieldDecoration({
    required String labelText,
    String? hintText,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      labelStyle: TextStyle(color: primaryColor),
      hintStyle: TextStyle(color: theme.hintColor),
    );
  }

  /// 標準的なダイアログアクションボタン行を生成
  static Widget buildDialogActions({
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
    required String confirmText,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'キャンセル',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
