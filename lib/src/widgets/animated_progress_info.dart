import 'package:flutter/material.dart';
import '../widgets/animated_percentage_text.dart';

/// アニメーション付きの進捗情報を表示するウィジェット
class AnimatedProgressInfo extends StatelessWidget {
  const AnimatedProgressInfo({
    super.key,
    required this.percentage,
    required this.label,
    this.duration = const Duration(milliseconds: 300),
    this.labelStyle,
    this.percentageStyle,
    this.decimalPlaces = 1,
  });

  /// 進捗率（0.0 ～ 100.0）
  final double percentage;
  
  /// 進捗ラベル（例：「やってる🌱」）
  final String label;
  
  /// アニメーション継続時間
  final Duration duration;
  
  /// ラベルのスタイル
  final TextStyle? labelStyle;
  
  /// パーセンテージのスタイル
  final TextStyle? percentageStyle;
  
  /// 小数点以下の桁数
  final int decimalPlaces;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        AnimatedPercentageText(
          percentage: percentage,
          duration: duration,
          style: percentageStyle,
          decimalPlaces: decimalPlaces,
        ),
      ],
    );
  }
}
