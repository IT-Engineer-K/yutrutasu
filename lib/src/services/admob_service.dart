import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'admob_config.dart';

class AdMobService {
  static AdMobService? _instance;
  static AdMobService get instance => _instance ??= AdMobService._();
  
  AdMobService._();

  // AdMob を初期化
  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      if (kDebugMode) {
        debugPrint('✅ AdMob初期化完了');
      }
    } catch (e) {
      // 初期化失敗時の処理
      if (kDebugMode) {
        debugPrint('❌ AdMob初期化失敗: $e');
      }
    }
  }

  // インタースティシャル広告を読み込み
  static Future<InterstitialAd?> loadInterstitialAd() async {
    InterstitialAd? interstitialAd;
    
    await InterstitialAd.load(
      adUnitId: AdMobConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // 広告読み込み失敗時の処理
        },
      ),
    );
    
    return interstitialAd;
  }

  // リワード広告を読み込み
  static Future<RewardedAd?> loadRewardedAd() async {
    RewardedAd? rewardedAd;
    
    await RewardedAd.load(
      adUnitId: AdMobConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // 広告読み込み失敗時の処理
        },
      ),
    );
    
    return rewardedAd;
  }

  // ネイティブ広告を作成
  NativeAd createNativeAd({
    required NativeAdListener listener,
    String? factoryId,
  }) {
    return NativeAd(
      adUnitId: AdMobConfig.nativeAdUnitId,
      request: const AdRequest(),
      listener: listener,
      factoryId: factoryId,
    );
  }

  // テスト端末IDを設定（開発時のみ使用）
  static void setTestDeviceIds(List<String> testDeviceIds) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: testDeviceIds),
    );
  }
}
