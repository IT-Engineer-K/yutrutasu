/// アプリケーション専用のエラークラス
abstract class YuruTasuError implements Exception {
  const YuruTasuError(this.message);
  
  final String message;
  
  @override
  String toString() => 'YuruTasuError: $message';
}

/// データ関連のエラー
class DataError extends YuruTasuError {
  const DataError(super.message);
}

/// ネットワーク関連のエラー
class NetworkError extends YuruTasuError {
  const NetworkError(super.message);
}

/// 広告関連のエラー
class AdError extends YuruTasuError {
  const AdError(super.message);
}

/// バリデーション関連のエラー
class ValidationError extends YuruTasuError {
  const ValidationError(super.message);
}
