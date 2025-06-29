import 'package:flutter/material.dart';

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
                  const Icon(Icons.eco, color: Color(0xFF66BB6A)),
                  const SizedBox(width: 8),
                  const Text(
                    '新しいプロジェクト',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'タイトル *',
                  hintText: '例: 今週の目標',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF66BB6A)),
                  ),
                  labelStyle: TextStyle(color: Color(0xFF66BB6A)),
                  hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
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
                decoration: const InputDecoration(
                  labelText: 'メモ（任意）',
                  hintText: '例: 毎日少しずつでも...',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF66BB6A)),
                  ),
                  labelStyle: TextStyle(color: Color(0xFF66BB6A)),
                  hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(color: Color(0xFF757575)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _onAddPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66BB6A),
                      foregroundColor: Colors.white,
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
      final description = _descriptionController.text.trim();
      
      widget.onAdd(title, description.isEmpty ? null : description);
      Navigator.of(context).pop();
    }
  }
}
