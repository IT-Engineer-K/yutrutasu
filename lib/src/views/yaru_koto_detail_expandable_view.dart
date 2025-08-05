import 'package:flutter/material.dart';
import '../models/yaru_koto.dart';
import '../models/task_item.dart';
import '../models/task.dart';
import '../controllers/yaru_koto_controller.dart';
import '../widgets/animated_percentage_text.dart';
import '../widgets/animated_progress_info.dart';
import '../widgets/smooth_animated_linear_progress_indicator.dart';
import '../common/dialog_helpers.dart';
import '../common/progress_helpers.dart';
import '../common/theme_helpers.dart';
import 'edit_task_dialog.dart';
import 'bulk_edit_items_view.dart';

class YaruKotoDetailExpandableView extends StatelessWidget {
  const YaruKotoDetailExpandableView({
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
          yaruKoto.title,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _HeaderWidget(),
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
      builder: (context) => AlertDialog(
        title: const Text('新しい項目'),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelpers.getCardColor(context), // 動的にカード色を決定
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeHelpers.getShadowColor(context), // 動的に影の色を決定
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedProgressInfo(
            percentage: yaruKoto.progressPercentage,
            label: yaruKoto.progressLabel,
            labelStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            percentageStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            yaruKoto.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          SmoothAnimatedLinearProgressIndicator(
            value: yaruKoto.progressPercentage / 100,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            valueColor: theme.colorScheme.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${yaruKoto.progressPercentage.toStringAsFixed(1)}% (${yaruKoto.items.length}個の項目)',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          if (yaruKoto.description != null) ...[
            const SizedBox(height: 8),
            Text(
              yaruKoto.description!,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeHelpers.getCardColor(context), // 動的にカード色を決定
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ThemeHelpers.getShadowColor(context), // 動的に影の色を決定
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

class _HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.list_alt, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '項目一覧',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
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
      color: ThemeHelpers.getCardColor(context), // 動的にカード色を決定
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )
                : BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getPercentageBasedProgressColor(widget.item.progressPercentage, theme),
                          border: Border.all(
                            color: ProgressHelpers.getPercentageBasedBorderColor(widget.item.progressPercentage, theme),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.item.progressLabel.split('')[0],
                            style: TextStyle(
                              fontSize: 16,
                              color: ProgressHelpers.getPercentageBasedBorderColor(widget.item.progressPercentage, theme),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                          Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SmoothAnimatedLinearProgressIndicator(
                    value: widget.item.progressPercentage / 100,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    valueColor: ProgressHelpers.getPercentageBasedBorderColor(widget.item.progressPercentage, theme),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedPercentageText(
                        percentage: widget.item.progressPercentage,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ProgressHelpers.getPercentageBasedBorderColor(widget.item.progressPercentage, theme),
                        ),
                      ),
                      Text(
                        '${widget.item.tasks.length}個のタスク',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showEditTasksDialog(context),
                              icon: Icon(Icons.edit_note, color: theme.colorScheme.primary, size: 16),
                              label: Text(
                                '編集',
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
                          const SizedBox(height: 8),
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

  void _showEditTasksDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTasksView(
          yaruKoto: widget.yaruKoto,
          taskItem: widget.item,
          controller: widget.controller,
        ),
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
    DialogHelpers.showDeleteConfirmDialog(
      context: context,
      title: task.title,
      onConfirm: () {
        widget.controller.deleteTask(widget.yaruKoto.id, widget.item.id, task.id);
      },
    );
  }

  Color _getPercentageBasedProgressColor(double percentage, ThemeData theme) {
    if (percentage == 0) return theme.colorScheme.surface;
    if (percentage < 100) return theme.colorScheme.primary.withOpacity(0.2);
    return theme.colorScheme.primary.withOpacity(0.3);
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
    final theme = Theme.of(context);
    
    // 進捗更新中かどうかを判定
    final uniqueId = '${yaruKoto.id}-${taskItem.id}-${task.id}';
    final isUpdating = controller.updatingTaskIds.contains(uniqueId);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: ThemeHelpers.getCardColor(context), // 動的にカード色を決定
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ProgressHelpers.getProgressBorderColor(task.progress, theme).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 進捗部分（タップ可能）
          Expanded(
            child: GestureDetector(
              onTap: isUpdating ? null : onProgressTap, // 更新中はタップを無効化
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: ProgressHelpers.getProgressBackgroundColor(task.progress, theme),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ProgressHelpers.getProgressBorderColor(task.progress, theme),
                          width: 1,
                        ),
                      ),
                      child: isUpdating
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ProgressHelpers.getProgressBorderColor(task.progress, theme),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                ProgressHelpers.getProgressEmoji(task.progress),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ProgressHelpers.getProgressTextColor(task.progress, theme),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Opacity(
                        opacity: isUpdating ? 0.6 : 1.0,
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: task.progress == TaskProgress.completed 
                          ? ProgressHelpers.getProgressBorderColor(task.progress, theme)
                          : ProgressHelpers.getProgressBorderColor(task.progress, theme).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ProgressHelpers.getProgressBorderColor(task.progress, theme),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        task.progress.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: ProgressHelpers.getProgressTextColor(task.progress, theme),
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
              color: ProgressHelpers.getProgressBorderColor(task.progress, theme),
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
            itemBuilder: (context) => DialogHelpers.getEditDeleteMenuItems(),
          ),
        ],
      ),
    );
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
          decoration: InputDecoration(
            labelText: '項目名',
            hintText: '例：本題',
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
                style: TextStyle(color: theme.colorScheme.outline),
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
