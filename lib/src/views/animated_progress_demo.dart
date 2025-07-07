import 'package:flutter/material.dart';
import '../widgets/animated_percentage_text.dart';
import '../widgets/animated_progress_info.dart';

/// アニメーション進捗デモ画面
class AnimatedProgressDemo extends StatefulWidget {
  const AnimatedProgressDemo({super.key});

  static const routeName = '/animated_progress_demo';

  @override
  State<AnimatedProgressDemo> createState() => _AnimatedProgressDemoState();
}

class _AnimatedProgressDemoState extends State<AnimatedProgressDemo> {
  double _currentPercentage = 0.0;
  final List<double> _presetValues = [0, 25, 50, 75, 100];
  int _currentPresetIndex = 0;

  void _incrementProgress() {
    setState(() {
      _currentPercentage = (_currentPercentage + 10).clamp(0, 100);
    });
  }

  void _decrementProgress() {
    setState(() {
      _currentPercentage = (_currentPercentage - 10).clamp(0, 100);
    });
  }

  void _nextPreset() {
    setState(() {
      _currentPresetIndex = (_currentPresetIndex + 1) % _presetValues.length;
      _currentPercentage = _presetValues[_currentPresetIndex];
    });
  }

  void _randomProgress() {
    setState(() {
      _currentPercentage = (DateTime.now().millisecondsSinceEpoch % 101).toDouble();
    });
  }

  String _getProgressLabel(double percentage) {
    if (percentage == 0) return '未着手🌰';
    if (percentage < 100) return 'やってる🌱';
    return '完了🌳';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('アニメーション進捗デモ'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // デモ説明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'アニメーション進捗デモ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '進捗率が変化するときに、数字が段階的にアニメーションで変化します。\n下のボタンで進捗率を変更してアニメーションを確認してください。',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // アニメーション付き進捗表示
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 大きな進捗表示
                    AnimatedProgressInfo(
                      percentage: _currentPercentage,
                      label: _getProgressLabel(_currentPercentage),
                      labelStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      percentageStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      decimalPlaces: 1,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // プログレスバー
                    LinearProgressIndicator(
                      value: _currentPercentage / 100,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // シンプルなパーセンテージ表示
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'シンプル表示: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        AnimatedPercentageText(
                          percentage: _currentPercentage,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                          decimalPlaces: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // コントロールボタン
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'コントロール',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 増減ボタン
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _decrementProgress,
                            icon: const Icon(Icons.remove),
                            label: const Text('-10%'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              foregroundColor: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _incrementProgress,
                            icon: const Icon(Icons.add),
                            label: const Text('+10%'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // プリセットとランダム
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _nextPreset,
                            icon: const Icon(Icons.skip_next),
                            label: const Text('プリセット'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _randomProgress,
                            icon: const Icon(Icons.shuffle),
                            label: const Text('ランダム'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // 設定情報
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'アニメーション設定',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '・継続時間: 500ms\n・カーブ: easeInOut\n・小数点: 1桁',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
