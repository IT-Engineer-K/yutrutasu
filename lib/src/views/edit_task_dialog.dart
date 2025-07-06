import 'package:flutter/material.dart';

class EditTaskDialog extends StatefulWidget {
  const EditTaskDialog({
    super.key,
    required this.initialTitle,
    required this.onUpdate,
  });

  final String initialTitle;
  final void Function(String title) onUpdate;

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
  }

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
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            'タスクを編集',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: TextField(
        controller: _titleController,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: '項目名',
          hintText: '例: 第1章を読む',
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
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'キャンセル',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text.trim();
            if (title.isNotEmpty) {
              widget.onUpdate(title);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: const Text('更新'),
        ),
      ],
    );
  }
}