/// 最小単位のタスクを表すEnum
enum TaskProgress {
  notStarted(0, '未着手'),
  inProgress(50, '着手済'), 
  completed(100, '完了');

  const TaskProgress(this.value, this.label);
  final int value;
  final String label;

  static TaskProgress fromValue(int value) {
    return TaskProgress.values.firstWhere((e) => e.value == value);
  }

  /// 次の段階に進める
  TaskProgress get next {
    switch (this) {
      case TaskProgress.notStarted:
        return TaskProgress.inProgress;
      case TaskProgress.inProgress:
        return TaskProgress.completed;
      case TaskProgress.completed:
        return TaskProgress.notStarted;
    }
  }
}

/// 最小単位のタスク
class Task {
  final String id;
  final String title;
  final TaskProgress progress;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.progress = TaskProgress.notStarted,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    TaskProgress? progress,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'progress': progress.value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        progress: TaskProgress.fromValue(json['progress'] as int? ?? 0),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      throw FormatException('Invalid Task JSON format: $e');
    }
  }
}
