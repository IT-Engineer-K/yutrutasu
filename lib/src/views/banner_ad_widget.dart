import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/admob_service.dart';

class BannerAdWidget extends StatefulWidget {
  final AdSize adSize;
  final double? height;

  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
    this.height,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdFailed = false;
  String? _errorMessage;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    try {
      // リセット状態
      setState(() {
        _isAdLoaded = false;
        _isAdFailed = false;
        _errorMessage = null;
      });

      // 既存の広告があれば破棄
      _bannerAd?.dispose();
      _loadingTimer?.cancel();

      // 30秒でタイムアウト
      _loadingTimer = Timer(const Duration(seconds: 30), () {
        if (!_isAdLoaded && mounted) {
          setState(() {
            _isAdFailed = true;
            _errorMessage = 'タイムアウト: 広告の読み込みに時間がかかりすぎています';
          });
          _bannerAd?.dispose();
        }
      });

      _bannerAd = AdMobService.instance.createBannerAd(
        adSize: widget.adSize,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (kDebugMode) debugPrint('Banner ad loaded successfully');
            _loadingTimer?.cancel();
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
                _isAdFailed = false;
                _errorMessage = null;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            if (kDebugMode) debugPrint('Banner ad failed to load: $error');
            _loadingTimer?.cancel();
            ad.dispose();
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
                _isAdFailed = true;
                _errorMessage = 'エラー: ${error.message}';
              });
            }
          },
          onAdOpened: (ad) {
            if (kDebugMode) debugPrint('Banner ad opened');
          },
          onAdClosed: (ad) {
            if (kDebugMode) debugPrint('Banner ad closed');
          },
          onAdImpression: (ad) {
            if (kDebugMode) debugPrint('Banner ad impression');
          },
          onAdClicked: (ad) {
            if (kDebugMode) debugPrint('Banner ad clicked');
          },
        ),
      );

      _bannerAd?.load();
    } catch (e) {
      if (kDebugMode) debugPrint('Error creating banner ad: $e');
      if (mounted) {
        setState(() {
          _isAdFailed = true;
          _errorMessage = 'エラー: 広告の作成に失敗しました';
        });
      }
    }
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_bannerAd != null && _isAdLoaded) {
      return Container(
        height: widget.height ?? widget.adSize.height.toDouble(),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else if (_isAdFailed) {
      // エラー状態の表示
      return Container(
        height: widget.height ?? widget.adSize.height.toDouble(),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                '広告の読み込みに失敗',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.error.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.error.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loadAd,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'リトライ',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 読み込み中の表示
      return Container(
        height: widget.height ?? widget.adSize.height.toDouble(),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: theme.colorScheme.primary.withOpacity(0.5),
                strokeWidth: 2,
              ),
              const SizedBox(height: 8),
              Text(
                'バナー広告読み込み中...',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '30秒でタイムアウトします',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
