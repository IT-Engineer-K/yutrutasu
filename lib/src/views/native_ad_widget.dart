import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/admob_service.dart';

class NativeAdWidget extends StatefulWidget {
  final String? factoryId;
  final double? height;

  const NativeAdWidget({
    super.key,
    this.factoryId = 'listTile',
    this.height = 320,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
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
      _nativeAd?.dispose();
      _loadingTimer?.cancel();

      // 30秒でタイムアウト
      _loadingTimer = Timer(const Duration(seconds: 30), () {
        if (!_isAdLoaded && mounted) {
          setState(() {
            _isAdFailed = true;
            _errorMessage = 'タイムアウト: 広告の読み込みに時間がかかりすぎています';
          });
          _nativeAd?.dispose();
        }
      });

      _nativeAd = AdMobService.instance.createNativeAd(
        factoryId: widget.factoryId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('Native ad loaded successfully');
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
            debugPrint('Native ad failed to load: $error');
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
            debugPrint('Native ad opened');
          },
          onAdClosed: (ad) {
            debugPrint('Native ad closed');
          },
          onAdImpression: (ad) {
            debugPrint('Native ad impression');
          },
        onAdClicked: (ad) {
          debugPrint('Native ad clicked');
        },
      ),
    );

    _nativeAd?.load();
    } catch (e) {
      debugPrint('Error creating native ad: $e');
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
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_nativeAd != null && _isAdLoaded) {
      return Container(
        height: widget.height,
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
          child: AdWidget(ad: _nativeAd!),
        ),
      );
    } else if (_isAdFailed) {
      // エラー状態の表示
      return Container(
        height: widget.height,
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
                'ネイティブ広告の読み込みに失敗',
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
      // 読み込み中は空のコンテナを表示（アニメーションなし）
      return Container(
        height: widget.height,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      );
    }
  }
}
