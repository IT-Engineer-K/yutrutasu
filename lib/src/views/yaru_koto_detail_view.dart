import 'package:flutter/material.dart';
import '../models/yaru_koto.dart';
import '../models/task_item.dart';
import '../models/task.dart';
import '../controllers/yaru_koto_controller.dart';
import 'edit_task_dialog.dart';
import 'edit_item_dialog.dart';
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
        title: const Text(
          '一覧へ',
          style: TextStyle(
            color: Color(0xFF2E7D2E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFE8F5E8),
        foregroundColor: const Color(0xFF2E7D2E),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          final currentYaruKoto = controller.yaruKotoList
              .firstWhere((e) => e.id == yaruKoto.id, orElse: () => yaruKoto);

          if (currentYaruKoto.items.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProgressCard(yaruKoto: currentYaruKoto),
                  const SizedBox(height: 16),
                  _EmptyItemsWidget(
                    onAddItem: () => _showAddItemDialog(context),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: _ProgressCard(yaruKoto: currentYaruKoto),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: currentYaruKoto.items.length,
                  itemBuilder: (context, index) {
                    final item = currentYaruKoto.items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ExpandableTaskItemCard(
                        item: item,
                        yaruKoto: currentYaruKoto,
                        controller: controller,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: const Color(0xFF66BB6A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新しい項目を追加'),
        content: AddItemDialogContent(
          onSubmit: (title, description) {
            controller.addTaskItem(yaruKoto.id, title, description: description);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.yaruKoto});

  final YaruKoto yaruKoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  yaruKoto.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: yaruKoto.progressPercentage / 100,
            backgroundColor: const Color(0xFFE8F5E8),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF66BB6A)),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${yaruKoto.progressPercentage.toStringAsFixed(1)}% (${yaruKoto.totalTaskCount}個のタスク)',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (yaruKoto.description != null) ...[
            const SizedBox(height: 8),
            Text(
              yaruKoto.description!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyItemsWidget extends StatelessWidget {
  const _EmptyItemsWidget({required this.onAddItem});

  final VoidCallback onAddItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.folder_open,
            size: 64,
            color: Color(0xFF66BB6A),
          ),
          const SizedBox(height: 16),
          const Text(
            'まだ項目がありません',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D2E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '項目を追加して、\nタスクを整理しましょう！',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAddItem,
            icon: const Icon(Icons.add),
            label: const Text('項目を追加'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}



class _ExpandableTaskItemCard extends StatefulWidget {
  const _ExpandableTaskItemCard({
    required this.item,
    required this.yaruKoto,
    required this.controller,
  });

  final TaskItem item;
  final YaruKoto yaruKoto;
  final YaruKotoController controller;

  @override
  State<_ExpandableTaskItemCard> createState() => _ExpandableTaskItemCardState();
}

class _ExpandableTaskItemCardState extends State<_ExpandableTaskItemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xFFF8FCF8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE8F5E8)),
      ),
      child: Column(
        children: [
          // 項目ヘッダー部分
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: _isExpanded 
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                : BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF2E7D2E),
                              ),
                            ),
                            if (widget.item.description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.item.description!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color(0xFF66BB6A),
                              size: 20,
                            ),
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  _showEditItemDialog(context);
                                  break;
                                case 'delete':
                                  _confirmDeleteItem(context);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Color(0xFF66BB6A), size: 16),
                                    SizedBox(width: 8),
                                    Text('編集', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red, size: 16),
                                    SizedBox(width: 8),
                                    Text('削除', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: const Color(0xFF66BB6A),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: widget.item.progressPercentage / 100,
                    backgroundColor: const Color(0xFFE8F5E8),
                    valueColor: AlwaysStoppedAnimation<Color>(_getProgressBorderColor()),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.item.progressPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getProgressBorderColor(),
                        ),
                      ),
                      Text(
                        '${widget.item.tasks.length}個のタスク',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // 展開可能なタスクリスト部分
          if (_isExpanded) ...[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE8F5E8)),
                ),
              ),
              child: Column(
                children: [
                  // タスクリストヘッダー
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: const Color(0xFFF0F7F0),
                    child: Row(
                      children: [
                        const Icon(Icons.task_alt, color: Color(0xFF66BB6A), size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'タスク',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D2E),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _showAddTaskDialog(context),
                          icon: const Icon(Icons.add, color: Color(0xFF66BB6A), size: 16),
                          label: const Text(
                            '追加',
                            style: TextStyle(color: Color(0xFF66BB6A), fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // タスクリスト
                  if (widget.item.tasks.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Icon(Icons.task_alt, color: Color(0xFF66BB6A), size: 32),
                          SizedBox(height: 8),
                          Text(
                            'まだタスクがありません',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...widget.item.tasks.map((task) => _CompactTaskCard(
                          task: task,
                          yaruKoto: widget.yaruKoto,
                          taskItem: widget.item,
                          controller: widget.controller,
                          onProgressTap: () => widget.controller.nextTaskProgress(
                            widget.yaruKoto.id,
                            widget.item.id,
                            task.id,
                          ),
                          onEditTap: () => _showEditTaskDialog(context, task),
                          onDeleteTap: () => _confirmDeleteTask(context, task),
                        )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (title) {
          widget.controller.addTask(widget.yaruKoto.id, widget.item.id, title);
        },
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        initialTitle: task.title,
        onUpdate: (title) {
          widget.controller.updateTask(
            widget.yaruKoto.id,
            widget.item.id,
            task.id,
            title,
          );
        },
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: Text('「${task.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              widget.controller.deleteTask(widget.yaruKoto.id, widget.item.id, task.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditItemDialog(
        initialTitle: widget.item.title,
        initialDescription: widget.item.description,
        onUpdate: (title, description) {
          widget.controller.updateTaskItem(
            widget.yaruKoto.id,
            widget.item.id,
            title: title,
            description: description,
          );
        },
      ),
    );
  }

  void _confirmDeleteItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('項目を削除'),
        content: Text('「${widget.item.title}」を削除しますか？\n配下のタスクも全て削除されます。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              widget.controller.deleteTaskItem(widget.yaruKoto.id, widget.item.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  Color _getProgressBorderColor() {
    final percentage = widget.item.progressPercentage;
    if (percentage == 0) return const Color(0xFFBDBDBD);
    if (percentage < 100) return const Color(0xFF66BB6A);
    return const Color(0xFF2E7D2E);
  }
}

class _CompactTaskCard extends StatelessWidget {
  const _CompactTaskCard({
    required this.task,
    required this.yaruKoto,
    required this.taskItem,
    required this.controller,
    required this.onProgressTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final Task task;
  final YaruKoto yaruKoto;
  final TaskItem taskItem;
  final YaruKotoController controller;
  final VoidCallback onProgressTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getProgressBorderColor(task.progress).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 進捗部分（タップ可能）
          Expanded(
            child: GestureDetector(
              onTap: onProgressTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getProgressColor(task.progress),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getProgressBorderColor(task.progress),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          task.progress == TaskProgress.completed ? '✓' : '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getProgressBorderColor(task.progress),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title.isEmpty ? '（タイトルなし）' : task.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: task.title.isEmpty ? Colors.grey : const Color(0xFF2E7D2E),
                          fontStyle: task.title.isEmpty ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getProgressBorderColor(task.progress).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getProgressBorderColor(task.progress),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        task.progress.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: _getProgressBorderColor(task.progress),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // メニューボタン
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: _getProgressBorderColor(task.progress),
              size: 16,
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEditTap();
                  break;
                case 'delete':
                  onDeleteTap();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF66BB6A), size: 16),
                    SizedBox(width: 8),
                    Text('編集', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 16),
                    SizedBox(width: 8),
                    Text('削除', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.notStarted:
        return const Color(0xFFF5F5F5);
      case TaskProgress.inProgress:
        return const Color(0xFFE8F5E8);
      case TaskProgress.completed:
        return const Color(0xFFDCEDC8);
    }
  }

  Color _getProgressBorderColor(TaskProgress progress) {
    switch (progress) {
      case TaskProgress.notStarted:
        return const Color(0xFFBDBDBD);
      case TaskProgress.inProgress:
        return const Color(0xFF66BB6A);
      case TaskProgress.completed:
        return const Color(0xFF2E7D2E);
    }
  }
}

class AddItemDialogContent extends StatefulWidget {
  const AddItemDialogContent({super.key, required this.onSubmit});

  final Function(String, String?) onSubmit;

  @override
  State<AddItemDialogContent> createState() => _AddItemDialogContentState();
}

class _AddItemDialogContentState extends State<AddItemDialogContent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: '項目名',
            hintText: '項目名を入力してください',
          ),
          autofocus: true,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: '説明（任意）',
            hintText: '説明を入力してください',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  final description = _descriptionController.text.trim();
                  widget.onSubmit(title, description.isEmpty ? null : description);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66BB6A),
                foregroundColor: Colors.white,
              ),
              child: const Text('追加'),
            ),
          ],
        ),
      ],
    );
  }
}
