/// ネイティブ広告ウィジェットの定数とenum定義
class AdWidgetConstants {
  static const double defaultHeight = 320.0;
  static const String defaultFactoryId = 'listTile';
  static const Duration loadTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 2);
  
  // マージン・パディング
  static const double horizontalMargin = 16.0;
  static const double verticalMargin = 8.0;
  static const double borderRadius = 12.0;
  static const double borderWidth = 1.0;
  
  // エラー表示
  static const double errorIconSize = 24.0;
  static const double errorTitleFontSize = 12.0;
  static const double errorMessageFontSize = 10.0;
  static const double retryButtonFontSize = 12.0;
  static const double spacingSmall = 4.0;
  static const double spacingMedium = 8.0;
  
  // 透明度
  static const double outlineOpacity = 0.3;
  static const double errorContainerOpacity = 0.3;
  static const double errorIconOpacity = 0.7;
  static const double errorTextOpacity = 0.8;
  static const double errorMessageOpacity = 0.6;
  static const double surfaceOpacity = 0.1;
  static const double loadingBorderOpacity = 0.2;
}

/// 広告の読み込み状態
enum AdLoadState {
  /// 初期状態
  initial,
  /// 読み込み中
  loading,
  /// 読み込み完了
  loaded,
  /// 読み込み失敗
  failed,
  /// タイムアウト
  timeout,
}

/// 広告エラーの種類
enum AdErrorType {
  /// ネットワークエラー
  network,
  /// 設定エラー
  configuration,
  /// タイムアウト
  timeout,
  /// 一般的なエラー
  general,
}

/// 広告エラー情報
class NativeAdError {
  final AdErrorType type;
  final String message;
  final String? details;

  const NativeAdError({
    required this.type,
    required this.message,
    this.details,
  });

  /// ユーザー向けのエラーメッセージを取得
  String get userMessage {
    switch (type) {
      case AdErrorType.network:
        return 'ネットワーク接続を確認してください';
      case AdErrorType.configuration:
        return '広告設定に問題があります';
      case AdErrorType.timeout:
        return '読み込みに時間がかかりすぎています';
      case AdErrorType.general:
        return '広告の読み込みに失敗しました';
    }
  }

  /// 開発者向けの詳細エラーメッセージを取得
  String get debugMessage {
    final base = '$type: $message';
    return details != null ? '$base ($details)' : base;
  }
}
