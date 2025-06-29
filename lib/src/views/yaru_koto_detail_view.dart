import 'package:flutter/material.dart';
import '../models/yaru_koto.dart';
import '../models/task_item.dart';
import '../controllers/yaru_koto_controller.dart';
import 'add_task_dialog.dart';

class YaruKotoDetailView extends StatelessWidget {
  const YaruKotoDetailView({
    super.key,
    required this.yaruKoto,
    required this.controller,
  });

  final YaruKoto yaruKoto;
  final YaruKotoController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5),
      appBar: AppBar(
        title: Text(
          yaruKoto.title,
          style: const TextStyle(
            color: Color(0xFF2E7D2E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFE8F5E8),
        foregroundColor: const Color(0xFF2E7D2E), // AppBar全体のテキスト色を設定
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          // 最新の状態を取得
          final currentYaruKoto = controller.yaruKotoList
              .firstWhere((e) => e.id == yaruKoto.id, orElse: () => yaruKoto);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProgressCard(yaruKoto: currentYaruKoto),
                const SizedBox(height: 16),
                _TaskListCard(
                  yaruKoto: currentYaruKoto,
                  controller: controller,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: const Color(0xFF66BB6A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (title) {
          controller.addTaskItem(yaruKoto.id, title);
        },
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.yaruKoto});

  final YaruKoto yaruKoto;

  @override
  Widget build(BuildContext context) {
    final progressPercentage = yaruKoto.progressPercentage;

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.eco, color: Color(0xFF66BB6A)),
                const SizedBox(width: 8),
                const Text(
                  '進捗状況',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (yaruKoto.description?.isNotEmpty == true) ...[
              Text(
                yaruKoto.description!,
                style: const TextStyle(
                  color: Color(0xFF616161),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  yaruKoto.progressLabel,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                Text(
                  '${progressPercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progressPercentage / 100,
              backgroundColor: const Color(0xFFE8F5E8),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF66BB6A)),
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Text(
              '項目数: ${yaruKoto.items.length}個',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListCard extends StatelessWidget {
  const _TaskListCard({
    required this.yaruKoto,
    required this.controller,
  });

  final YaruKoto yaruKoto;
  final YaruKotoController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.list_alt, color: Color(0xFF66BB6A)),
                const SizedBox(width: 8),
                const Text(
                  '項目一覧',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (yaruKoto.items.isEmpty)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      size: 48,
                      color: Color(0xFFAED581),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'まだ項目がありません',
                      style: TextStyle(
                        color: Color(0xFF81C784),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '右下の + ボタンで追加しましょう',
                      style: TextStyle(
                        color: Color(0xFFAED581),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...yaruKoto.items.map((item) => _TaskItemTile(
                item: item,
                onProgressTap: () => controller.nextTaskProgress(yaruKoto.id, item.id),
                onDelete: () => _confirmDeleteTask(context, item),
              )),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, TaskItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('項目を削除'),
        content: Text('「${item.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTaskItem(yaruKoto.id, item.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}

class _TaskItemTile extends StatelessWidget {
  const _TaskItemTile({
    required this.item,
    required this.onProgressTap,
    required this.onDelete,
  });

  final TaskItem item;
  final VoidCallback onProgressTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8F5E8)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.progress == TaskProgress.completed
                ? TextDecoration.lineThrough
                : null,
            color: item.progress == TaskProgress.completed
                ? const Color(0xFF757575)
                : const Color(0xFF2E7D2E),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: InkWell(
          onTap: onProgressTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getProgressColor(item.progress),
              border: Border.all(
                color: _getProgressBorderColor(item.progress),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _getProgressEmoji(item.progress),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.progress.label,
              style: TextStyle(
                fontSize: 12,
                color: _getProgressBorderColor(item.progress),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 20),
              color: const Color(0xFFFF7043),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.notStarted:
        return const Color(0xFFF5F5F5);
      case TaskProgress.inProgress:
        return const Color(0xFFFFF3E0);
      case TaskProgress.completed:
        return const Color(0xFFE8F5E8);
    }
  }

  Color _getProgressBorderColor(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.notStarted:
        return const Color(0xFFBDBDBD);
      case TaskProgress.inProgress:
        return const Color(0xFFFF9800);
      case TaskProgress.completed:
        return const Color(0xFF4CAF50);
    }
  }

  String _getProgressEmoji(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.notStarted:
        return '⚪';
      case TaskProgress.inProgress:
        return '🌱';
      case TaskProgress.completed:
        return '🌿';
    }
  }
}
