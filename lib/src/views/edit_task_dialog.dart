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
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.edit, color: Color(0xFF66BB6A)),
          SizedBox(width: 8),
          Text('項目を編集'),
        ],
      ),
      content: TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: '項目名',
          hintText: '例: 第1章を読む',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF66BB6A)),
          ),
          labelStyle: TextStyle(color: Color(0xFF66BB6A)),
        ),
        autofocus: true,
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
              widget.onUpdate(title);
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