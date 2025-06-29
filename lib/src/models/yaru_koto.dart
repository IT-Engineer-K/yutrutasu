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
    final totalProgress = items.fold<int>(0, (sum, item) => sum + item.progress.value);
    return totalProgress / items.length;
  }

  /// 進捗率のラベル
  String get progressLabel {
    final percentage = progressPercentage;
    if (percentage == 0) return '未着手';
    if (percentage < 100) return 'やってる🌱';
    return '完了🌿';
  }

  YaruKoto copyWith({
    String? id,
    String? title,
    String? description,
    List<TaskItem>? items,
    DateTime? createdAt,
  }) {
    return YaruKoto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
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
    return YaruKoto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      items: (json['items'] as List)
          .map((item) => TaskItem.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
