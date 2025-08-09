import 'task.dart';

/// プロジェクト内の項目（中間階層）
/// 複数のタスクを含み、それらの平均値で進捗を計算する
class TaskItem {
  final String id;
  final String title;
  final String? description;
  final List<Task> tasks;
  final DateTime createdAt;

  TaskItem({
    required this.id,
    required this.title,
    this.description,
    this.tasks = const [],
    required this.createdAt,
  });

  /// 配下のタスクの進捗率を計算（タスクの平均値）
  double get progressPercentage {
    if (tasks.isEmpty) return 0.0;
    final totalProgress = tasks.fold<int>(0, (sum, task) => sum + task.progress.value);
    return totalProgress / tasks.length;
  }

  /// 進捗率のラベル
  String get progressLabel {
    final percentage = progressPercentage;
    if (percentage == 0) return '未着手🌰';
    if (percentage < 100) return 'やってる🌱';
    return '完了🌳';
  }

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    List<Task>? tasks,
    DateTime? createdAt,
    bool clearDescription = false,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    try {
      return TaskItem(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        tasks: (json['tasks'] as List<dynamic>? ?? [])
            .map((task) => Task.fromJson(task as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      throw FormatException('Invalid TaskItem JSON format: $e');
    }
  }
}
