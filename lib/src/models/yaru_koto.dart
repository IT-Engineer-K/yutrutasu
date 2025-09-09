import 'task_item.dart';

/// プロジェクトを表すクラス
class YaruKoto {
  final String id;
  final String title;
  final String? description;
  final List<TaskItem> items;
  final DateTime createdAt;

  YaruKoto({
    required this.id,
    required this.title,
    this.description,
    this.items = const [],
    required this.createdAt,
  });

  /// 全体の進捗率を計算（項目の平均値）
  double get progressPercentage {
    if (items.isEmpty) return 0.0;
    final totalProgress = items.fold<double>(0, (sum, item) => sum + item.progressPercentage);
    return totalProgress / items.length;
  }

  /// 全タスク数を計算
  int get totalTaskCount {
    return items.fold<int>(0, (sum, item) => sum + item.tasks.length);
  }

  /// 進捗率のラベル
  String get progressLabel {
    final percentage = progressPercentage;
    if (percentage == 0) return '未着手';
    if (percentage < 100) return 'やってる🌱';
    return '完了🌳';
  }

  YaruKoto copyWith({
    String? id,
    String? title,
    String? description,
    List<TaskItem>? items,
    DateTime? createdAt,
    bool clearDescription = false,
  }) {
    return YaruKoto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory YaruKoto.fromJson(Map<String, dynamic> json) {
    try {
      return YaruKoto(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((item) => TaskItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      throw FormatException('Invalid YaruKoto JSON format: $e');
    }
  }
}
