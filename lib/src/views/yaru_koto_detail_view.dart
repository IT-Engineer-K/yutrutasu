import 'package:flutter/material.dart';
import '../models/yaru_koto.dart';
import '../models/task_item.dart';
import '../controllers/yaru_koto_controller.dart';
import 'edit_task_dialog.dart';
import 'item_task_integrated_view.dart';

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
                      child: _TaskItemCard(
                        item: item,
                        yaruKoto: currentYaruKoto,
                        controller: controller,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemTaskIntegratedView(
                                yaruKoto: currentYaruKoto,
                                taskItem: item,
                                controller: controller,
                              ),
                            ),
                          );
                        },
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
              Text(
                yaruKoto.progressLabel,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
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
            '${yaruKoto.progressPercentage.toStringAsFixed(1)}% (${yaruKoto.items.length}個の項目)',
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

class _HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: const [
          Icon(Icons.list_alt, color: Color(0xFF66BB6A)),
          SizedBox(width: 8),
          Text(
            '項目一覧',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskItemCard extends StatefulWidget {
  const _TaskItemCard({
    required this.item,
    required this.yaruKoto,
    required this.controller,
    required this.onTap,
  });

  final TaskItem item;
  final YaruKoto yaruKoto;
  final YaruKotoController controller;
  final VoidCallback onTap;

  @override
  State<_TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<_TaskItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: const Color(0xFFF8FCF8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE8F5E8)),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
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
                      color: _getProgressColor(),
                      border: Border.all(
                        color: _getProgressBorderColor(),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.item.progressLabel.split('')[0],
                        style: const TextStyle(fontSize: 16),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.item.progressPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getProgressBorderColor(),
                        ),
                      ),
                      Text(
                        '${widget.item.tasks.length}個',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _showTaskContextMenu(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.more_vert,
                        color: Color(0xFF66BB6A),
                        size: 20,
                      ),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor() {
    final percentage = widget.item.progressPercentage;
    if (percentage == 0) return const Color(0xFFF5F5F5);
    if (percentage < 100) return const Color(0xFFE8F5E8);
    return const Color(0xFFDCEDC8);
  }

  Color _getProgressBorderColor() {
    final percentage = widget.item.progressPercentage;
    if (percentage == 0) return const Color(0xFFBDBDBD);
    if (percentage < 100) return const Color(0xFF66BB6A);
    return const Color(0xFF2E7D2E);
  }

  void _showTaskContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF66BB6A)),
              title: const Text('名前を編集'),
              onTap: () {
                Navigator.of(context).pop();
                _showEditTaskDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('削除'),
              onTap: () {
                Navigator.of(context).pop();
                _confirmDeleteTask(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        initialTitle: widget.item.title,
        onUpdate: (title) {
          widget.controller.updateTaskItem(
            widget.yaruKoto.id, 
            widget.item.id, 
            title: title,
          );
        },
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('項目を削除'),
        content: Text('「${widget.item.title}」を削除しますか？'),
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
