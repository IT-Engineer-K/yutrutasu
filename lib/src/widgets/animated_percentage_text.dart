import 'package:flutter/material.dart';

/// アニメーションで数値が段階的に変化するパーセンテージテキストウィジェット
class AnimatedPercentageText extends StatefulWidget {
  const AnimatedPercentageText({
    super.key,
    required this.percentage,
    this.duration = const Duration(milliseconds: 300),
    this.style,
    this.decimalPlaces = 1,
    this.curve = Curves.easeInOut,
  });

  /// 表示する進捗率（0.0 ～ 100.0）
  final double percentage;
  
  /// アニメーション継続時間
  final Duration duration;
  
  /// テキストスタイル
  final TextStyle? style;
  
  /// 小数点以下の桁数
  final int decimalPlaces;
  
  /// アニメーションカーブ
  final Curve curve;

  @override
  State<AnimatedPercentageText> createState() => _AnimatedPercentageTextState();
}

class _AnimatedPercentageTextState extends State<AnimatedPercentageText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _previousPercentage = widget.percentage;
    _setupAnimation();
  }

  @override
  void didUpdateWidget(AnimatedPercentageText oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // パーセンテージが変わった場合のみアニメーション
    if (oldWidget.percentage != widget.percentage) {
      _previousPercentage = oldWidget.percentage;
      _setupAnimation();
      _controller.forward(from: 0.0);
    }
    
    // 継続時間が変わった場合
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  void _setupAnimation() {
    _animation = Tween<double>(
      begin: _previousPercentage,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${_animation.value.toStringAsFixed(widget.decimalPlaces)}%',
          style: widget.style,
        );
      },
    );
  }
}
