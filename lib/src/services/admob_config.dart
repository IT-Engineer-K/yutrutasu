import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdMobConfig {
  // テスト用ID定数（フォールバック用）
  static const String _testAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String _testAppIdIOS = 'ca-app-pub-3940256099942544~1458002511';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIOS = 'ca-app-pub-3940256099942544/4411468910';
  static const String _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIOS = 'ca-app-pub-3940256099942544/1712485313';
  static const String _testNativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testNativeIOS = 'ca-app-pub-3940256099942544/3986624511';

  // 安全にdotenvから値を取得するヘルパーメソッド
  static String? _getEnvSafely(String key) {
    try {
      // dotenvが初期化されているかチェック
      if (!dotenv.isInitialized) {
        if (kDebugMode) {
          debugPrint('警告: dotenvが初期化されていません');
        }
        return null;
      }
      return dotenv.env[key];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('警告: .envファイルが読み込まれていないか、キー "$key" が見つかりません: $e');
      }
      return null;
    }
  }

  // AdMob App ID
  static String get appId {
    if (Platform.isAndroid) {
      final productionId = _getEnvSafely('ANDROID_ADMOB_APP_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        if (kDebugMode) {
          debugPrint('✅ 本番Android App ID使用: $productionId');
        }
        return productionId;
      }
      // 本番IDが設定されていない場合は警告を表示
      if (kDebugMode) {
        debugPrint('警告: 本番用のANDROID_ADMOB_APP_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testAppIdAndroid;
    } else if (Platform.isIOS) {
      final productionId = _getEnvSafely('IOS_ADMOB_APP_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        if (kDebugMode) {
          debugPrint('✅ 本番iOS App ID使用: $productionId');
        }
        return productionId;
      }
      // 本番IDが設定されていない場合は警告を表示
      if (kDebugMode) {
        debugPrint('警告: 本番用のIOS_ADMOB_APP_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testAppIdIOS;
    }
    return '';
  }

  // Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      final productionId = _getEnvSafely('ANDROID_INTERSTITIAL_AD_UNIT_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        return productionId;
      }
      if (kDebugMode) {
        debugPrint('警告: 本番用のANDROID_INTERSTITIAL_AD_UNIT_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testInterstitialAndroid;
    } else if (Platform.isIOS) {
      final productionId = _getEnvSafely('IOS_INTERSTITIAL_AD_UNIT_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        return productionId;
      }
      if (kDebugMode) {
        debugPrint('警告: 本番用のIOS_INTERSTITIAL_AD_UNIT_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testInterstitialIOS;
    }
    return '';
  }

  // Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      final productionId = _getEnvSafely('ANDROID_REWARDED_AD_UNIT_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        return productionId;
      }
      if (kDebugMode) {
        debugPrint('警告: 本番用のANDROID_REWARDED_AD_UNIT_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testRewardedAndroid;
    } else if (Platform.isIOS) {
      final productionId = _getEnvSafely('IOS_REWARDED_AD_UNIT_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        return productionId;
      }
      if (kDebugMode) {
        debugPrint('警告: 本番用のIOS_REWARDED_AD_UNIT_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testRewardedIOS;
    }
    return '';
  }

  // Native Advanced Ad Unit ID
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      final productionId = _getEnvSafely('ANDROID_NATIVE_AD_UNIT_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        return productionId;
      }
      if (kDebugMode) {
        debugPrint('警告: 本番用のANDROID_NATIVE_AD_UNIT_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testNativeAndroid;
    } else if (Platform.isIOS) {
      final productionId = _getEnvSafely('IOS_NATIVE_AD_UNIT_ID');
      if (productionId != null && productionId.isNotEmpty && !productionId.contains('XXXXXXXXXXXXXXXX')) {
        return productionId;
      }
      if (kDebugMode) {
        debugPrint('警告: 本番用のIOS_NATIVE_AD_UNIT_IDが設定されていません。テスト広告を使用しています。');
      }
      return _testNativeIOS;
    }
    return '';
  }
}
