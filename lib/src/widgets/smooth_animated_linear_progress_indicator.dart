import 'package:flutter/material.dart';

/// より滑らかなアニメーションを持つ進捗バー
class SmoothAnimatedLinearProgressIndicator extends StatefulWidget {
  const SmoothAnimatedLinearProgressIndicator({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.valueColor,
    this.minHeight = 4.0,
    this.borderRadius,
    this.curve = Curves.easeInOutCubic,
  });

  /// 進捗値（0.0 ～ 1.0）
  final double value;
  
  /// アニメーション継続時間
  final Duration duration;
  
  /// 背景色
  final Color? backgroundColor;
  
  /// 進捗バーの色
  final Color? valueColor;
  
  /// バーの最小高さ
  final double minHeight;
  
  /// 角の丸み
  final BorderRadiusGeometry? borderRadius;
  
  /// アニメーションカーブ
  final Curve curve;

  @override
  State<SmoothAnimatedLinearProgressIndicator> createState() => _SmoothAnimatedLinearProgressIndicatorState();
}

class _SmoothAnimatedLinearProgressIndicatorState extends State<SmoothAnimatedLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _currentValue = 0.0;
    _setupAnimation(widget.value);
    
    // 初期アニメーションを開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(SmoothAnimatedLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 進捗値が変わった場合のみアニメーション
    if ((oldWidget.value - widget.value).abs() > 0.001) {
      _setupAnimation(widget.value);
      _controller.forward(from: 0.0);
    }
    
    // 継続時間が変わった場合
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  void _setupAnimation(double targetValue) {
    _animation = Tween<double>(
      begin: _currentValue,
      end: targetValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    
    _animation.addListener(() {
      setState(() {
        _currentValue = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: widget.minHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.primary.withOpacity(0.2),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.minHeight / 2),
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.minHeight / 2),
        child: Stack(
          children: [
            // 進捗バー部分
            FractionallySizedBox(
              widthFactor: _currentValue.clamp(0.0, 1.0),
              child: Container(
                height: widget.minHeight,
                decoration: BoxDecoration(
                  color: widget.valueColor ?? theme.colorScheme.primary,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.minHeight / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
