import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/yaru_koto.dart';
import '../models/task_item.dart';
import '../services/yaru_koto_service.dart';

class YaruKotoController extends ChangeNotifier {
  final YaruKotoService _service = YaruKotoService();
  final Uuid _uuid = const Uuid();
  
  List<YaruKoto> _yaruKotoList = [];
  bool _isLoading = false;

  List<YaruKoto> get yaruKotoList => _yaruKotoList;
  bool get isLoading => _isLoading;

  /// データを読み込む
  Future<void> loadYaruKoto() async {
    _isLoading = true;
    notifyListeners();

    try {
      _yaruKotoList = await _service.getAllYaruKoto();
    } catch (e) {
      debugPrint('Error loading yaru koto: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 新しいプロジェクトを追加
  Future<void> addYaruKoto(String title, {String? description}) async {
    final yaruKoto = YaruKoto(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    try {
      await _service.addYaruKoto(yaruKoto);
      _yaruKotoList.add(yaruKoto);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding yaru koto: $e');
    }
  }

  /// プロジェクトにタスク項目を追加
  Future<void> addTaskItem(String yaruKotoId, String taskTitle) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final taskItem = TaskItem(
      id: _uuid.v4(),
      title: taskTitle,
    );

    final updatedItems = List<TaskItem>.from(_yaruKotoList[yaruKotoIndex].items)
      ..add(taskItem);

    final updatedYaruKoto = _yaruKotoList[yaruKotoIndex].copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task item: $e');
    }
  }

  /// タスク項目の進捗を更新
  Future<void> updateTaskProgress(String yaruKotoId, String taskId, TaskProgress progress) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskIndex = yaruKoto.items.indexWhere((e) => e.id == taskId);
    if (taskIndex == -1) return;

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskIndex] = updatedItems[taskIndex].copyWith(progress: progress);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating task progress: $e');
    }
  }

  /// タスク項目の進捗を次のステップに進める
  Future<void> nextTaskProgress(String yaruKotoId, String taskId) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskIndex = yaruKoto.items.indexWhere((e) => e.id == taskId);
    if (taskIndex == -1) return;

    final currentProgress = yaruKoto.items[taskIndex].progress;
    TaskProgress nextProgress;

    switch (currentProgress) {
      case TaskProgress.notStarted:
        nextProgress = TaskProgress.inProgress;
        break;
      case TaskProgress.inProgress:
        nextProgress = TaskProgress.completed;
        break;
      case TaskProgress.completed:
        nextProgress = TaskProgress.notStarted;
        break;
    }

    await updateTaskProgress(yaruKotoId, taskId, nextProgress);
  }

  /// プロジェクトを削除
  Future<void> deleteYaruKoto(String id) async {
    try {
      await _service.deleteYaruKoto(id);
      _yaruKotoList.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting yaru koto: $e');
    }
  }

  /// プロジェクト名・説明を更新
  Future<void> updateYaruKoto(String id, {String? title, String? description}) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == id);
    if (yaruKotoIndex == -1) return;

    final updatedYaruKoto = _yaruKotoList[yaruKotoIndex].copyWith(
      title: title,
      description: description,
    );

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating yaru koto: $e');
    }
  }

  /// タスク項目を削除
  Future<void> deleteTaskItem(String yaruKotoId, String taskId) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final updatedItems = yaruKoto.items.where((e) => e.id != taskId).toList();

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task item: $e');
    }
  }

  /// タスク項目の名前を更新
  Future<void> updateTaskItem(String yaruKotoId, String taskId, String newTitle) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskIndex = yaruKoto.items.indexWhere((e) => e.id == taskId);
    if (taskIndex == -1) return;

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskIndex] = updatedItems[taskIndex].copyWith(title: newTitle);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating task item: $e');
    }
  }

  /// タスク項目の順序を変更
  Future<void> reorderTaskItems(String yaruKotoId, int oldIndex, int newIndex) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final updatedItems = List<TaskItem>.from(yaruKoto.items);

    // リストの並べ替え処理
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final TaskItem item = updatedItems.removeAt(oldIndex);
    updatedItems.insert(newIndex, item);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      debugPrint('Error reordering task items: $e');
    }
  }

  /// プロジェクト一覧の順序を変更
  Future<void> reorderYaruKoto(int oldIndex, int newIndex) async {
    // リストの並べ替え処理
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final YaruKoto item = _yaruKotoList.removeAt(oldIndex);
    _yaruKotoList.insert(newIndex, item);

    try {
      // 全てのプロジェクトを更新（順序を保存するため）
      for (int i = 0; i < _yaruKotoList.length; i++) {
        await _service.updateYaruKoto(_yaruKotoList[i]);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error reordering yaru koto: $e');
    }
  }
}
