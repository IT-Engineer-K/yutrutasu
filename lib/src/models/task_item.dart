/// タスクの進捗状態を表すEnum
enum TaskProgress {
  notStarted(0, '未着手'),
  inProgress(50, 'ちょっとやった'),
  completed(100, '完了');

  const TaskProgress(this.value, this.label);
  final int value;
  final String label;

  static TaskProgress fromValue(int value) {
    return TaskProgress.values.firstWhere((e) => e.value == value);
  }
}

/// 個別のタスク項目
class TaskItem {
  final String id;
  final String title;
  final TaskProgress progress;

  TaskItem({
    required this.id,
    required this.title,
    this.progress = TaskProgress.notStarted,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    TaskProgress? progress,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'progress': progress.value,
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      title: json['title'],
      progress: TaskProgress.fromValue(json['progress']),
    );
  }
}
