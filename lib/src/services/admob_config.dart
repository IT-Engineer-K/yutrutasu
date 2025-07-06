import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdMobConfig {
  // AdMob App ID
  static String get appId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_ADMOB_APP_ID'] ?? 'ca-app-pub-3940256099942544~3347511713';
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_ADMOB_APP_ID'] ?? 'ca-app-pub-3940256099942544~1458002511';
    }
    return '';
  }

  // Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // テスト用ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // テスト用ID
    }
    return '';
  }

  // Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // テスト用ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // テスト用ID
    }
    return '';
  }

  // Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // テスト用ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // テスト用ID
    }
    return '';
  }

  // Native Advanced Ad Unit ID
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_NATIVE_AD_UNIT_ID'] ?? 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_NATIVE_AD_UNIT_ID'] ?? 'ca-app-pub-3940256099942544/3986624511';
    }
    return '';
  }
}
