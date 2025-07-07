import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdMobConfig {
  // テスト用ID定数
  static const String _testAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String _testAppIdIOS = 'ca-app-pub-3940256099942544~1458002511';
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIOS = 'ca-app-pub-3940256099942544/4411468910';
  static const String _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIOS = 'ca-app-pub-3940256099942544/1712485313';
  static const String _testNativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testNativeIOS = 'ca-app-pub-3940256099942544/3986624511';

  // AdMob App ID
  static String get appId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_ADMOB_APP_ID'] ?? _testAppIdAndroid;
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_ADMOB_APP_ID'] ?? _testAppIdIOS;
    }
    return '';
  }

  // Banner Ad Unit ID
  static String get bannerAdUnitId {
    return Platform.isAndroid ? _testBannerAndroid : 
           Platform.isIOS ? _testBannerIOS : '';
  }

  // Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    return Platform.isAndroid ? _testInterstitialAndroid : 
           Platform.isIOS ? _testInterstitialIOS : '';
  }

  // Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    return Platform.isAndroid ? _testRewardedAndroid : 
           Platform.isIOS ? _testRewardedIOS : '';
  }

  // Native Advanced Ad Unit ID
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_NATIVE_AD_UNIT_ID'] ?? _testNativeAndroid;
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_NATIVE_AD_UNIT_ID'] ?? _testNativeIOS;
    }
    return '';
  }
}
