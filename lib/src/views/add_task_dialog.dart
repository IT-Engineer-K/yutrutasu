import 'package:flutter/material.dart';

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
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final hintColor = theme.hintColor;
    
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
              Row(
                children: [
                  Icon(Icons.add_circle_outline, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    '新しい項目',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: '項目名 *',
                  hintText: '例: 資料を読む',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  labelStyle: TextStyle(color: primaryColor),
                  hintStyle: TextStyle(color: hintColor),
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
                    onPressed: _onAddPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('追加'),
                  ),
                ],
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
