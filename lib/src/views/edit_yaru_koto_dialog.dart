import 'package:flutter/material.dart';

class EditYaruKotoDialog extends StatefulWidget {
  const EditYaruKotoDialog({
    super.key,
    required this.initialTitle,
    this.initialDescription,
    required this.onUpdate,
  });

  final String initialTitle;
  final String? initialDescription;
  final void Function(String title, String? description) onUpdate;

  @override
  State<EditYaruKotoDialog> createState() => _EditYaruKotoDialogState();
}

class _EditYaruKotoDialogState extends State<EditYaruKotoDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

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
    final hintColor = theme.hintColor;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            'プロジェクトを編集',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'プロジェクト名',
              hintText: '例: 読書記録',
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
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: '説明（任意）',
              hintText: '例: 毎日少しずつ本を読む',
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
            maxLines: 3,
          ),
        ],
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
              final description = _descriptionController.text.trim();
              widget.onUpdate(
                title, 
                description.isEmpty ? null : description,
              );
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
