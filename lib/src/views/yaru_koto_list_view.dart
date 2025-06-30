import 'package:flutter/material.dart';
import '../models/yaru_koto.dart';
import '../controllers/yaru_koto_controller.dart';
import 'yaru_koto_detail_view.dart';
import 'add_yaru_koto_dialog.dart';
import 'edit_yaru_koto_dialog.dart';

class YaruKotoListView extends StatefulWidget {
  const YaruKotoListView({super.key, required this.controller});

  static const routeName = '/';
  final YaruKotoController controller;

  @override
  State<YaruKotoListView> createState() => _YaruKotoListViewState();
}

class _YaruKotoListViewState extends State<YaruKotoListView> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadYaruKoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F5), // やさしい緑の背景
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              '🌱 ゆるたす',
              style: TextStyle(
                color: Color(0xFF2E7D2E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'プロジェクトリスト',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE8F5E8),
        foregroundColor: const Color(0xFF2E7D2E), // AppBar全体のテキスト色を設定
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, child) {
          if (widget.controller.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF66BB6A)),
                  SizedBox(height: 16),
                  Text('読み込み中...', style: TextStyle(color: Color(0xFF66BB6A))),
                ],
              ),
            );
          }

          if (widget.controller.yaruKotoList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.eco,
                    size: 64,
                    color: Color(0xFFAED581),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'まだプロジェクトがありません',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF66BB6A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '下のボタンで新しいプロジェクトを\n追加してみましょう 🌱',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF81C784),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddYaruKotoDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('最初のプロジェクトを追加'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66BB6A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.controller.yaruKotoList.length + 1, // 余白用のアイテムを追加
            itemBuilder: (context, index) {
              // 最後のアイテムは余白として表示
              if (index == widget.controller.yaruKotoList.length) {
                return const SizedBox(height: 80); // FloatingActionButtonとの干渉を避ける余白
              }
              
              final yaruKoto = widget.controller.yaruKotoList[index];
              return _YaruKotoCard(
                yaruKoto: yaruKoto,
                onTap: () => _navigateToDetail(context, yaruKoto),
                onMenuTap: () => _showContextMenu(context, yaruKoto),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddYaruKotoDialog(context),
        backgroundColor: const Color(0xFF66BB6A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddYaruKotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddYaruKotoDialog(
        onAdd: (title, description) {
          widget.controller.addYaruKoto(title, description: description);
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, YaruKoto yaruKoto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => YaruKotoDetailView(
          yaruKoto: yaruKoto,
          controller: widget.controller,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, YaruKoto yaruKoto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text('「${yaruKoto.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              widget.controller.deleteYaruKoto(yaruKoto.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context, YaruKoto yaruKoto) {
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
                _showEditYaruKotoDialog(context, yaruKoto);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('削除'),
              onTap: () {
                Navigator.of(context).pop();
                _confirmDelete(context, yaruKoto);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditYaruKotoDialog(BuildContext context, YaruKoto yaruKoto) {
    showDialog(
      context: context,
      builder: (context) => EditYaruKotoDialog(
        initialTitle: yaruKoto.title,
        initialDescription: yaruKoto.description,
        onUpdate: (title, description) {
          widget.controller.updateYaruKoto(
            yaruKoto.id,
            title: title,
            description: description,
          );
        },
      ),
    );
  }
}

class _YaruKotoCard extends StatelessWidget {
  const _YaruKotoCard({
    required this.yaruKoto,
    required this.onTap,
    required this.onMenuTap,
  });

  final YaruKoto yaruKoto;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final progressPercentage = yaruKoto.progressPercentage;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      yaruKoto.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D2E),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onMenuTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.more_vert,
                        color: Color(0xFF81C784),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              if (yaruKoto.description?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  yaruKoto.description!,
                  style: const TextStyle(
                    color: Color(0xFF616161),
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              yaruKoto.progressLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            Text(
                              '${progressPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progressPercentage / 100,
                          backgroundColor: const Color(0xFFE8F5E8),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF66BB6A)),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '項目数: ${yaruKoto.items.length}個',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF757575),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
