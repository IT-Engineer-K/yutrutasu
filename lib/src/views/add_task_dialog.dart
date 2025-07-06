import 'package:flutter/material.dart';
import '../common/theme_helper.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({
    super.key,
    required this.onAdd,
  });

  final Function(String title) onAdd;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemeHelper.buildDialogHeader(
                icon: Icons.add_circle_outline,
                title: '新しい項目',
                context: context,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                ),
                decoration: ThemeHelper.getTextFieldDecoration(
                  labelText: '項目名 *',
                  hintText: '例: 資料を読む',
                  context: context,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '項目名を入力してください';
                  }
                  return null;
                },
                autofocus: true,
                onFieldSubmitted: (_) => _onAddPressed(),
              ),
              const SizedBox(height: 16),
              Text(
                '💡 ヒント: 小さなステップに分けると取り組みやすくなります',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              ThemeHelper.buildDialogActions(
                onCancel: () => Navigator.of(context).pop(),
                onConfirm: _onAddPressed,
                confirmText: '追加',
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddPressed() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      widget.onAdd(title);
      Navigator.of(context).pop();
    }
  }
}
