import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/admob_service.dart';
import 'widgets/ad_widget_constants.dart';

/// ネイティブ広告を表示するウィジェット
/// 
/// 自動的に広告を読み込み、エラー状態やリトライ機能を提供します。
class NativeAdWidget extends StatefulWidget {
  /// 広告ファクトリーID（ネイティブ広告のレイアウト用）
  final String factoryId;
  
  /// ウィジェットの高さ
  final double height;
  
  /// 読み込みタイムアウト時間
  final Duration timeout;

  const NativeAdWidget({
    super.key,
    this.factoryId = AdWidgetConstants.defaultFactoryId,
    this.height = AdWidgetConstants.defaultHeight,
    this.timeout = AdWidgetConstants.loadTimeout,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  AdLoadState _loadState = AdLoadState.initial;
  NativeAdError? _lastError;
  Timer? _timeoutTimer;
  Timer? _retryTimer;
  int _retryCount = 0;
  static const int maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  /// リソースをクリーンアップ
  void _cleanupResources() {
    _timeoutTimer?.cancel();
    _retryTimer?.cancel();
    _nativeAd?.dispose();
  }

  /// 広告を読み込む
  Future<void> _loadAd() async {
    if (!mounted) return;

    try {
      _cleanupResources();
      
      setState(() {
        _loadState = AdLoadState.loading;
        _lastError = null;
      });

      // タイムアウト設定
      _timeoutTimer = Timer(widget.timeout, () {
        if (_loadState == AdLoadState.loading && mounted) {
          _handleTimeout();
        }
      });

      // 新しい広告を作成
      _nativeAd = AdMobService.instance.createNativeAd(
        factoryId: widget.factoryId,
        listener: _createAdListener(),
      );

      await _nativeAd?.load();
      
    } catch (e) {
      _handleError(NativeAdError(
        type: AdErrorType.general,
        message: '広告の作成に失敗しました',
        details: e.toString(),
      ));
    }
  }

  /// 広告リスナーを作成
  NativeAdListener _createAdListener() {
    return NativeAdListener(
      onAdLoaded: (ad) {
        _timeoutTimer?.cancel();
        
        if (mounted) {
          setState(() {
            _loadState = AdLoadState.loaded;
            _lastError = null;
            _retryCount = 0;
          });
        }
      },
      onAdFailedToLoad: (ad, error) {
        _timeoutTimer?.cancel();
        ad.dispose();
        
        if (mounted) {
          _handleLoadError(error);
        }
      },
      onAdOpened: (ad) {
        // 広告が開かれた時の処理
      },
      onAdClosed: (ad) {
        // 広告が閉じられた時の処理
      },
      onAdImpression: (ad) {
        // 広告が表示された時の処理
      },
      onAdClicked: (ad) {
        // 広告がクリックされた時の処理
      },
    );
  }

  /// タイムアウト処理
  void _handleTimeout() {
    final error = NativeAdError(
      type: AdErrorType.timeout,
      message: 'タイムアウト',
      details: '${widget.timeout.inSeconds}秒以内に読み込みが完了しませんでした',
    );
    
    _handleError(error);
  }

  /// 読み込みエラー処理
  void _handleLoadError(LoadAdError error) {
    AdErrorType errorType;
    switch (error.code) {
      case 0: // ERROR_CODE_INTERNAL_ERROR
        errorType = AdErrorType.general;
        break;
      case 1: // ERROR_CODE_INVALID_REQUEST
        errorType = AdErrorType.configuration;
        break;
      case 2: // ERROR_CODE_NETWORK_ERROR
        errorType = AdErrorType.network;
        break;
      case 3: // ERROR_CODE_NO_FILL
        errorType = AdErrorType.general;
        break;
      default:
        errorType = AdErrorType.general;
    }

    _handleError(NativeAdError(
      type: errorType,
      message: error.message,
      details: 'Code: ${error.code}',
    ));
  }

  /// エラー処理
  void _handleError(NativeAdError error) {
    if (mounted) {
      setState(() {
        _loadState = AdLoadState.failed;
        _lastError = error;
      });
    }

    // 自動リトライ（最大回数まで）
    if (_retryCount < maxRetries && error.type == AdErrorType.network) {
      _scheduleRetry();
    }
  }

  /// リトライをスケジュール
  void _scheduleRetry() {
    _retryTimer = Timer(AdWidgetConstants.retryDelay, () {
      if (mounted) {
        _retryCount++;
        _loadAd();
      }
    });
  }

  /// 手動リトライ
  void _manualRetry() {
    _retryCount = 0;
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(
        horizontal: AdWidgetConstants.horizontalMargin,
        vertical: AdWidgetConstants.verticalMargin,
      ),
      child: _buildContent(context),
    );
  }

  /// コンテンツを構築
  Widget _buildContent(BuildContext context) {
    switch (_loadState) {
      case AdLoadState.initial:
      case AdLoadState.loading:
        return _buildLoadingWidget(context);
      case AdLoadState.loaded:
        return _buildAdWidget(context);
      case AdLoadState.failed:
      case AdLoadState.timeout:
        return _buildErrorWidget(context);
    }
  }

  /// 読み込み中ウィジェット
  Widget _buildLoadingWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(
          AdWidgetConstants.surfaceOpacity,
        ),
        borderRadius: BorderRadius.circular(AdWidgetConstants.borderRadius),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(
            AdWidgetConstants.loadingBorderOpacity,
          ),
          width: AdWidgetConstants.borderWidth,
        ),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  /// 広告ウィジェット
  Widget _buildAdWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_nativeAd == null) {
      return _buildErrorWidget(context);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AdWidgetConstants.borderRadius),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(
            AdWidgetConstants.outlineOpacity,
          ),
          width: AdWidgetConstants.borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AdWidgetConstants.borderRadius),
        child: AdWidget(ad: _nativeAd!),
      ),
    );
  }

  /// エラーウィジェット
  Widget _buildErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    final error = _lastError;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(
          AdWidgetConstants.errorContainerOpacity,
        ),
        borderRadius: BorderRadius.circular(AdWidgetConstants.borderRadius),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(
            AdWidgetConstants.outlineOpacity,
          ),
          width: AdWidgetConstants.borderWidth,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error.withOpacity(
                AdWidgetConstants.errorIconOpacity,
              ),
              size: AdWidgetConstants.errorIconSize,
            ),
            const SizedBox(height: AdWidgetConstants.spacingMedium),
            Text(
              'ネイティブ広告の読み込みに失敗',
              style: TextStyle(
                fontSize: AdWidgetConstants.errorTitleFontSize,
                color: theme.colorScheme.error.withOpacity(
                  AdWidgetConstants.errorTextOpacity,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: AdWidgetConstants.spacingSmall),
              Text(
                error.userMessage,
                style: TextStyle(
                  fontSize: AdWidgetConstants.errorMessageFontSize,
                  color: theme.colorScheme.error.withOpacity(
                    AdWidgetConstants.errorMessageOpacity,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AdWidgetConstants.spacingMedium),
            _buildRetryButton(context),
          ],
        ),
      ),
    );
  }

  /// リトライボタン
  Widget _buildRetryButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextButton(
      onPressed: _manualRetry,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minimumSize: Size.zero,
      ),
      child: Text(
        'リトライ',
        style: TextStyle(
          fontSize: AdWidgetConstants.retryButtonFontSize,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
