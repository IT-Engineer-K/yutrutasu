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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '🌱 ゆるたす',
              style: theme.appBarTheme.titleTextStyle,
            ),
            const SizedBox(width: 8),
            Text(
              'プロジェクトリスト',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.appBarTheme.foregroundColor?.withOpacity(0.8),
              ),
            ),
          ],
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, child) {
          if (widget.controller.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('読み込み中...', style: TextStyle(color: theme.colorScheme.primary)),
                ],
              ),
            );
          }

          if (widget.controller.yaruKotoList.isEmpty) {
            return Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.eco,
                        size: 64,
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'まだプロジェクトがありません',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '下のボタンで新しいプロジェクトを\n追加してみましょう 🌱',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.primary.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showAddYaruKotoDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('最初のプロジェクトを追加'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }
            );
          }

          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.controller.yaruKotoList.length + 1,
              onReorder: (oldIndex, newIndex) {
                if (oldIndex >= widget.controller.yaruKotoList.length || 
                    newIndex > widget.controller.yaruKotoList.length) {
                  return;
                }
                widget.controller.reorderYaruKoto(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                if (index == widget.controller.yaruKotoList.length) {
                  return Container(
                    key: const ValueKey('spacer'),
                    height: 80,
                  );
                }
                
                final yaruKoto = widget.controller.yaruKotoList[index];
                return _YaruKotoCard(
                  key: ValueKey(yaruKoto.id),
                  yaruKoto: yaruKoto,
                  onTap: () => _navigateToDetail(context, yaruKoto),
                  onEditTap: () => _showEditYaruKotoDialog(context, yaruKoto),
                  onDeleteTap: () => _confirmDelete(context, yaruKoto),
                  index: index,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return FloatingActionButton(
            onPressed: () => _showAddYaruKotoDialog(context),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: const Icon(Icons.add),
          );
        }
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Text(
              '削除の確認',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text('「${yaruKoto.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'キャンセル',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.controller.deleteYaruKoto(yaruKoto.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
            child: Text(
              '削除',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
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
    super.key,
    required this.yaruKoto,
    required this.onTap,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.index,
  });

  final YaruKoto yaruKoto;
  final VoidCallback onTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressPercentage = yaruKoto.progressPercentage;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: theme.cardColor,
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEditTap();
                          break;
                        case 'delete':
                          onDeleteTap();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: theme.colorScheme.primary, size: 16),
                            SizedBox(width: 8),
                            Text(
                              '名前を編集', 
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: theme.colorScheme.error, size: 16),
                            SizedBox(width: 8),
                            Text(
                              '削除', 
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (yaruKoto.description?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  yaruKoto.description!,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '${progressPercentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progressPercentage / 100,
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
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
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
