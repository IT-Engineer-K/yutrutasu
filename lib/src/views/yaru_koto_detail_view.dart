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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '一覧へ',
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
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
                  _ProjectHeader(yaruKoto: currentYaruKoto),
                  const SizedBox(height: 16),
                  // 区切り線
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
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
              // プロジェクト情報ヘッダー
              _ProjectHeader(yaruKoto: currentYaruKoto),
              
              // 区切り線
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),

              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: currentYaruKoto.items.length + 1,
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex >= currentYaruKoto.items.length || 
                          newIndex > currentYaruKoto.items.length) {
                        return;
                      }
                      controller.reorderTaskItems(yaruKoto.id, oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      if (index == currentYaruKoto.items.length) {
                        return Container(
                          key: const ValueKey('spacer'),
                          height: 80,
                        );
                      }
                      
                      final item = currentYaruKoto.items[index];
                      return Padding(
                        key: ValueKey(item.id),
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
              ),
            ],
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return FloatingActionButton(
            onPressed: () => _showAddItemDialog(context),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: const Icon(Icons.add),
          );
        }
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final primaryColor = theme.colorScheme.primary;
        
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.add, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                '新しい項目を追加',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: AddItemDialogContent(
            onSubmit: (title, description) {
              controller.addTaskItem(yaruKoto.id, title, description: description);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader({required this.yaruKoto});

  final YaruKoto yaruKoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // プロジェクトタイトル
          Text(
            yaruKoto.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          if (yaruKoto.description != null) ...[
            const SizedBox(height: 4),
            Text(
              yaruKoto.description!,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // 進捗情報
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                yaruKoto.progressLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '${yaruKoto.progressPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: yaruKoto.progressPercentage / 100,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${yaruKoto.totalTaskCount}個のタスク',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Icon(
            Icons.folder_open,
            size: 64,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'まだ項目がありません',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '項目を追加して、\nタスクを整理しましょう！',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAddItem,
            icon: const Icon(Icons.add),
            label: const Text('項目を追加'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
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
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
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
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            if (widget.item.description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.item.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                            icon: Icon(
                              Icons.more_vert,
                              color: theme.colorScheme.primary,
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
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: theme.colorScheme.primary, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      '編集', 
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: theme.colorScheme.error, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      '削除', 
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: widget.item.progressPercentage / 100,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
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
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                ),
              ),
              child: Column(
                children: [
                  // タスクリストヘッダー
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(Icons.task_alt, color: theme.colorScheme.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'タスク',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _showAddTaskDialog(context),
                          icon: Icon(Icons.add, color: theme.colorScheme.primary, size: 16),
                          label: Text(
                            '追加',
                            style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),
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
                      child: Column(
                        children: [
                          Icon(Icons.task_alt, color: theme.colorScheme.primary, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'まだタスクがありません',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.transparent,
                      ),
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.item.tasks.length,
                        onReorder: (oldIndex, newIndex) {
                          widget.controller.reorderTasks(
                            widget.yaruKoto.id,
                            widget.item.id,
                            oldIndex,
                            newIndex,
                          );
                        },
                        itemBuilder: (context, index) {
                          final task = widget.item.tasks[index];
                          return _CompactTaskCard(
                            key: ValueKey(task.id),
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
                          );
                        },
                      ),
                    ),
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Text(
              'タスクを削除',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text('「${task.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'キャンセル',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.controller.deleteTask(widget.yaruKoto.id, widget.item.id, task.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Text(
              '項目を削除',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text('「${widget.item.title}」を削除しますか？\n配下のタスクも全て削除されます。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'キャンセル',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.controller.deleteTaskItem(widget.yaruKoto.id, widget.item.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  Color _getProgressBorderColor() {
    final context = this.context;
    final theme = Theme.of(context);
    final percentage = widget.item.progressPercentage;
    if (percentage == 0) return theme.colorScheme.onSurface.withOpacity(0.4);
    if (percentage < 100) return theme.colorScheme.primary;
    return theme.colorScheme.primary;
  }
}

class _CompactTaskCard extends StatelessWidget {
  const _CompactTaskCard({
    super.key,
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
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getProgressBorderColor(task.progress, theme).withOpacity(0.3),
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
                        color: _getProgressColor(task.progress, theme),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getProgressBorderColor(task.progress, theme),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          task.progress == TaskProgress.completed ? '✓' : '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getProgressBorderColor(task.progress, theme),
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
                          color: task.title.isEmpty ? theme.colorScheme.onSurface.withOpacity(0.5) : theme.colorScheme.primary,
                          fontStyle: task.title.isEmpty ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getProgressBorderColor(task.progress, theme).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getProgressBorderColor(task.progress, theme),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        task.progress.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: _getProgressBorderColor(task.progress, theme),
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
              color: _getProgressBorderColor(task.progress, theme),
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
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: theme.colorScheme.primary, size: 16),
                    SizedBox(width: 8),
                    Text(
                      '編集', 
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: theme.colorScheme.error, size: 16),
                    SizedBox(width: 8),
                    Text(
                      '削除', 
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(TaskProgress progress, ThemeData theme) {
    switch (progress) {
      case TaskProgress.notStarted:
        return theme.colorScheme.surface;
      case TaskProgress.inProgress:
        return theme.colorScheme.primary.withOpacity(0.2);
      case TaskProgress.completed:
        return theme.colorScheme.primary.withOpacity(0.3);
    }
  }

  Color _getProgressBorderColor(TaskProgress progress, ThemeData theme) {
    switch (progress) {
      case TaskProgress.notStarted:
        return theme.colorScheme.onSurface.withOpacity(0.4);
      case TaskProgress.inProgress:
        return theme.colorScheme.primary;
      case TaskProgress.completed:
        return theme.colorScheme.primary;
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: '項目名',
            hintText: '項目名を入力してください',
            labelStyle: TextStyle(color: primaryColor),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
          autofocus: true,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: '説明（任意）',
            hintText: '説明を入力してください',
            labelStyle: TextStyle(color: primaryColor),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'キャンセル',
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
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
                backgroundColor: primaryColor,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text('追加'),
            ),
          ],
        ),
      ],
    );
  }
}
