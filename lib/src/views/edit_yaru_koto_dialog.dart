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
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.edit, color: Color(0xFF66BB6A)),
          SizedBox(width: 8),
          Text('プロジェクトを編集'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'プロジェクト名',
              hintText: '例: 読書記録',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF66BB6A)),
              ),
              labelStyle: TextStyle(color: Color(0xFF66BB6A)),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: '説明（任意）',
              hintText: '例: 毎日少しずつ本を読む',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF66BB6A)),
              ),
              labelStyle: TextStyle(color: Color(0xFF66BB6A)),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
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
            backgroundColor: const Color(0xFF66BB6A),
            foregroundColor: Colors.white,
          ),
          child: const Text('更新'),
        ),
      ],
    );
  }
}
