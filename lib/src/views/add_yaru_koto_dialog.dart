import 'package:flutter/material.dart';
import '../common/theme_helper.dart';

class AddYaruKotoDialog extends StatefulWidget {
  const AddYaruKotoDialog({
    super.key,
    required this.onAdd,
  });

  final Function(String title, String? description) onAdd;

  @override
  State<AddYaruKotoDialog> createState() => _AddYaruKotoDialogState();
}

class _AddYaruKotoDialogState extends State<AddYaruKotoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
                icon: Icons.eco,
                title: '新しいプロジェクト',
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
                  labelText: 'タイトル *',
                  hintText: '例: 今週の目標',
                  context: context,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                ),
                decoration: ThemeHelper.getTextFieldDecoration(
                  labelText: '説明',
                  hintText: '詳細説明（任意）',
                  context: context,
                ),
                maxLines: 3,
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
      final description = _descriptionController.text.trim();
      
      widget.onAdd(title, description.isEmpty ? null : description);
      Navigator.of(context).pop();
    }
  }
}