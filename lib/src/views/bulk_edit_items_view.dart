import 'package:flutter/material.dart';
import '../models/yaru_koto.dart';
import '../models/task_item.dart';
import '../models/task.dart';
import '../controllers/yaru_koto_controller.dart';
import '../common/progress_helpers.dart';

class EditTasksView extends StatefulWidget {
  const EditTasksView({
    super.key,
    required this.yaruKoto,
    required this.taskItem,
    required this.controller,
  });

  final YaruKoto yaruKoto;
  final TaskItem taskItem;
  final YaruKotoController controller;

  @override
  State<EditTasksView> createState() => _EditTasksViewState();
}

class _EditTasksViewState extends State<EditTasksView> {
  late List<TextEditingController> _lineControllers;
  late List<Task?> _originalTasks;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _originalTasks = List.from(widget.taskItem.tasks);
    _lineControllers = [];
    
    // 既存タスクに対応するコントローラーを作成
    for (final task in widget.taskItem.tasks) {
      _lineControllers.add(TextEditingController(text: task.title));
    }
    
    // 空行を1つ追加（新規タスク追加用）
    _lineControllers.add(TextEditingController());
    _originalTasks.add(null);
  }

  @override
  void dispose() {
    for (final controller in _lineControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addNewLine() {
    setState(() {
      _lineControllers.add(TextEditingController());
      _originalTasks.add(null);
    });
  }

  void _removeLine(int index) {
    if (_lineControllers.length <= 1) return; // 最低1行は残す
    
    setState(() {
      _lineControllers[index].dispose();
      _lineControllers.removeAt(index);
      _originalTasks.removeAt(index);
    });
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final taskTitles = _lineControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      await widget.controller.editTasks(
        widget.yaruKoto.id,
        widget.taskItem.id,
        taskTitles,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('タスクを一括更新しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  bool _hasChanges() {
    final currentTitles = _lineControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    
    final originalTitles = widget.taskItem.tasks.map((task) => task.title).toList();
    
    if (currentTitles.length != originalTitles.length) return true;
    
    for (int i = 0; i < currentTitles.length; i++) {
      if (currentTitles[i] != originalTitles[i]) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasChanges = _hasChanges();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'タスク編集',
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          TextButton(
            onPressed: hasChanges && !_isSaving ? _saveChanges : null,
            child: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    '保存',
                    style: TextStyle(
                      color: hasChanges 
                          ? theme.colorScheme.primary 
                          : theme.disabledColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // プロジェクト・項目情報
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.yaruKoto.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '項目: ${widget.taskItem.title}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (widget.taskItem.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.taskItem.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // メイン編集エリア
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ヘルプテキスト
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '1行1タスクで編集してください。右側の×ボタンで行を削除できます。',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // タスク編集リスト
                  Expanded(
                    child: ListView.builder(
                      itemCount: _lineControllers.length,
                      itemBuilder: (context, index) {
                        final originalTask = index < _originalTasks.length ? _originalTasks[index] : null;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              // 左側：タスク状況アイコン
                              SizedBox(
                                width: 32,
                                height: 48,
                                child: originalTask != null
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: ProgressHelpers.getProgressBackgroundColor(originalTask.progress, theme),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: ProgressHelpers.getProgressBorderColor(originalTask.progress, theme),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            ProgressHelpers.getProgressEmoji(originalTask.progress),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: theme.colorScheme.outline.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '🌰',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              
                              // 中央：テキストフィールド
                              Expanded(
                                child: TextField(
                                  controller: _lineControllers[index],
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'タスクを入力...',
                                    hintStyle: TextStyle(
                                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.outline,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.outline.withOpacity(0.5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    if (index == _lineControllers.length - 1) {
                                      _addNewLine();
                                    }
                                  },
                                  onChanged: (text) {
                                    // 最後の行が入力され、かつまだ空行がない場合は新しい行を追加
                                    if (index == _lineControllers.length - 1 && 
                                        text.isNotEmpty) {
                                      _addNewLine();
                                    }
                                  },
                                ),
                              ),
                              
                              const SizedBox(width: 8),
                              
                              // 右側：削除ボタン
                              SizedBox(
                                width: 32,
                                height: 48,
                                child: IconButton(
                                  onPressed: _lineControllers.length > 1 
                                      ? () => _removeLine(index)
                                      : null,
                                  icon: Icon(
                                    Icons.close,
                                    color: _lineControllers.length > 1 
                                        ? theme.colorScheme.error
                                        : theme.disabledColor,
                                    size: 20,
                                  ),
                                  tooltip: '行を削除',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
