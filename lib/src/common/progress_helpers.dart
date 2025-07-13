/// 進捗関連の共通ユーティリティ
/// 
/// タスクやプロジェクトの進捗に関する色計算やスタイリングの
/// 共通ロジックを提供します。

import 'package:flutter/material.dart';
import '../models/task.dart';

class ProgressHelpers {
  /// 進捗率に基づいて背景色を取得
  /// 
  /// [progress] - タスクの進捗状態
  /// [theme] - アプリのテーマ
  static Color getProgressBackgroundColor(TaskProgress progress, ThemeData theme) {
    switch (progress) {
      case TaskProgress.notStarted:
        return theme.colorScheme.surface;
      case TaskProgress.inProgress:
        return theme.colorScheme.primary.withOpacity(0.2);
      case TaskProgress.completed:
        return theme.colorScheme.primary; // 完了時は濃い緑色背景
    }
  }

  /// 進捗率に基づいてボーダー色を取得
  /// 
  /// [progress] - タスクの進捗状態
  /// [theme] - アプリのテーマ
  static Color getProgressBorderColor(TaskProgress progress, ThemeData theme) {
    switch (progress) {
      case TaskProgress.notStarted:
        return theme.colorScheme.onSurface.withOpacity(0.4);
      case TaskProgress.inProgress:
        return theme.colorScheme.primary;
      case TaskProgress.completed:
        return theme.colorScheme.primary;
    }
  }

  /// 進捗率に基づいてテキスト色を取得
  /// 
  /// [progress] - タスクの進捗状態
  /// [theme] - アプリのテーマ
  static Color getProgressTextColor(TaskProgress progress, ThemeData theme) {
    switch (progress) {
      case TaskProgress.notStarted:
        return theme.colorScheme.onSurface.withOpacity(0.4);
      case TaskProgress.inProgress:
        return theme.colorScheme.primary;
      case TaskProgress.completed:
        return Colors.white; // 完了時は白色で視認性を確保
    }
  }

  /// 進捗率（パーセンテージ）に基づいて色を取得
  /// 
  /// [percentage] - 進捗率（0-100）
  /// [theme] - アプリのテーマ
  static Color getPercentageBasedBorderColor(double percentage, ThemeData theme) {
    if (percentage == 0) return theme.colorScheme.onSurface.withOpacity(0.4);
    if (percentage < 100) return theme.colorScheme.primary;
    return theme.colorScheme.primary;
  }

  /// タスクの進捗絵文字を取得
  /// 
  /// [progress] - タスクの進捗状態
  static String getProgressEmoji(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.notStarted:
        return '';
      case TaskProgress.inProgress:
        return '◐';
      case TaskProgress.completed:
        return '✓';
    }
  }
}
