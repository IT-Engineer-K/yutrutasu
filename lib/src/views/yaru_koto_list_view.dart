import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/yaru_koto.dart';
import '../controllers/yaru_koto_controller.dart';
import '../settings/settings_view.dart';
import '../widgets/animated_progress_info.dart';
import '../widgets/smooth_animated_linear_progress_indicator.dart';
import 'yaru_koto_detail_view.dart';
import 'add_yaru_koto_dialog.dart';
import 'edit_yaru_koto_dialog.dart';
import 'native_ad_widget.dart';

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'animated_progress_demo':
                  Navigator.pushNamed(context, '/animated_progress_demo');
                  break;
                case 'download_progress_demo':
                  Navigator.pushNamed(context, '/download_progress_demo');
                  break;
                case 'project_progress_demo':
                  Navigator.pushNamed(context, '/project_progress_demo');
                  break;
                case 'settings':
                  Navigator.pushNamed(context, SettingsView.routeName);
                  break;
              }
            },
            itemBuilder: (context) => [
              // デバッグビルド時のみ表示
              if (kDebugMode) ...[
                const PopupMenuItem(
                  value: 'animated_progress_demo',
                  child: Row(
                    children: [
                      Icon(Icons.animation, size: 20),
                      SizedBox(width: 8),
                      Text('アニメーション進捗デモ'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'download_progress_demo',
                  child: Row(
                    children: [
                      Icon(Icons.download, size: 20),
                      SizedBox(width: 8),
                      Text('ダウンロード進捗デモ'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'project_progress_demo',
                  child: Row(
                    children: [
                      Icon(Icons.business, size: 20),
                      SizedBox(width: 8),
                      Text('プロジェクト進捗デモ'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
              ],
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('設定'),
                  ],
                ),
              ),
            ],
          ),
        ],
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

          return Column(
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.controller.yaruKotoList.length + 1, // +1 for native ad
                    onReorder: (oldIndex, newIndex) {
                      // ネイティブ広告のインデックスは並び替えの対象外
                      if (oldIndex >= widget.controller.yaruKotoList.length || 
                          newIndex > widget.controller.yaruKotoList.length) {
                        return;
                      }
                      widget.controller.reorderYaruKoto(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      // 最後のアイテムの場合はネイティブ広告を表示
                      if (index == widget.controller.yaruKotoList.length) {
                        return Container(
                          key: const ValueKey('native_ad'),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: AspectRatio(
                            aspectRatio: 1.0, // 縦横比1:1に設定
                            child: const NativeAdWidget(
                              factoryId: 'listTile',
                              height: 200, // AspectRatioで実際のサイズは制御される
                            ),
                          ),
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
                ),
              ),
              // FloatingActionButtonとの間隔を確保
              const SizedBox(height: 16),
            ],
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
            child: const Text('削除'),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                              const SizedBox(width: 8),
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
                              const SizedBox(width: 8),
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
                          AnimatedProgressInfo(
                            percentage: progressPercentage,
                            label: yaruKoto.progressLabel,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                            ),
                            percentageStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                            ),
                            decimalPlaces: 0,
                          ),
                          const SizedBox(height: 4),
                          SmoothAnimatedLinearProgressIndicator(
                            value: progressPercentage / 100,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                            valueColor: theme.colorScheme.primary,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'タスク数: ${yaruKoto.totalTaskCount}個',
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
