/// 共通ダイアログヘルパー
/// 
/// アプリ全体で使用される汎用的なダイアログ機能を提供します。

import 'package:flutter/material.dart';

class DialogHelpers {
  /// 削除確認ダイアログを表示
  /// 
  /// [context] - ダイアログを表示するコンテキスト
  /// [title] - 削除対象の名前
  /// [message] - カスタムメッセージ（オプション）
  /// [onConfirm] - 削除確認時のコールバック
  static Future<void> showDeleteConfirmDialog({
    required BuildContext context,
    required String title,
    String? message,
    required VoidCallback onConfirm,
  }) async {
    final theme = Theme.of(context);
    
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Text(
              '削除確認',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(message ?? '「$title」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'キャンセル',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  /// 汎用ポップアップメニューアイテム作成
  /// 
  /// [icon] - アイコン
  /// [text] - テキスト
  /// [value] - 値
  /// [iconColor] - アイコンの色（オプション）
  static PopupMenuItem<String> createPopupMenuItem({
    required IconData icon,
    required String text,
    required String value,
    Color? iconColor,
  }) {
    return PopupMenuItem(
      value: value,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 編集・削除用のポップアップメニューアイテム一覧
  static List<PopupMenuEntry<String>> getEditDeleteMenuItems() {
    return [
      createPopupMenuItem(
        icon: Icons.edit,
        text: '編集',
        value: 'edit',
      ),
      createPopupMenuItem(
        icon: Icons.delete,
        text: '削除',
        value: 'delete',
      ),
    ];
  }
}
