import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// App Tracking Transparency (ATT) を管理するサービス
class AttService {
  static AttService? _instance;
  static AttService get instance => _instance ??= AttService._();
  
  AttService._();

  /// トラッキング許可をリクエスト
  static Future<void> requestTrackingPermission() async {
    if (Platform.isIOS) {
      try {
        // iOS 14以降でATTのリクエストを表示
        final status = await AppTrackingTransparency.requestTrackingAuthorization();
        
        if (kDebugMode) {
          debugPrint('ATT Status: $status');
        }
        
        // ステータスに応じてAdMob設定を更新
        await _updateAdMobConfiguration(status);
        
      } catch (e) {
        if (kDebugMode) {
          debugPrint('ATT request failed: $e');
        }
      }
    }
  }

  /// ATTのステータスを取得
  static Future<TrackingStatus> getTrackingStatus() async {
    if (Platform.isIOS) {
      try {
        return await AppTrackingTransparency.trackingAuthorizationStatus;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Failed to get ATT status: $e');
        }
        return TrackingStatus.notSupported;
      }
    }
    return TrackingStatus.notSupported;
  }

  /// ATTステータスに応じてAdMob設定を更新
  static Future<void> _updateAdMobConfiguration(TrackingStatus status) async {
    try {
      // iOS 14以降のプライバシー設定に応じてAdMobを設定
      RequestConfiguration requestConfiguration;
      
      switch (status) {
        case TrackingStatus.authorized:
          // トラッキングが許可されている場合は通常の設定
          requestConfiguration = RequestConfiguration(
            tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
            tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
            maxAdContentRating: MaxAdContentRating.g,
          );
          break;
        case TrackingStatus.denied:
        case TrackingStatus.restricted:
          // トラッキングが拒否されている場合は制限された設定
          requestConfiguration = RequestConfiguration(
            tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
            tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
            maxAdContentRating: MaxAdContentRating.g,
          );
          break;
        case TrackingStatus.notSupported:
        case TrackingStatus.notDetermined:
          // デフォルト設定
          requestConfiguration = RequestConfiguration(
            tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
            tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
            maxAdContentRating: MaxAdContentRating.g,
          );
          break;
      }
      
      await MobileAds.instance.updateRequestConfiguration(requestConfiguration);
      
      if (kDebugMode) {
        debugPrint('AdMob configuration updated for ATT status: $status');
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to update AdMob configuration: $e');
      }
    }
  }

  /// ユーザーがトラッキングを許可しているかどうかを確認
  static Future<bool> isTrackingAuthorized() async {
    final status = await getTrackingStatus();
    return status == TrackingStatus.authorized;
  }
}
