import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/yaru_koto.dart';
import '../models/task_item.dart';
import '../models/task.dart';
import '../services/yaru_koto_service.dart';

class YaruKotoController extends ChangeNotifier {
  final YaruKotoService _service = YaruKotoService();
  final Uuid _uuid = const Uuid();
  
  List<YaruKoto> _yaruKotoList = [];
  bool _isLoading = false;

  List<YaruKoto> get yaruKotoList => _yaruKotoList;
  bool get isLoading => _isLoading;

  /// チE�Eタを読み込む
  Future<void> loadYaruKoto() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      _yaruKotoList = await _service.getAllYaruKoto();
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading yaru koto: $e');
      _yaruKotoList = [];
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
      if (kDebugMode) debugPrint('Error adding yaru koto: $e');
    }
  }

  /// プロジェクトに頁E��を追加
  Future<void> addTaskItem(String yaruKotoId, String itemTitle, {String? description}) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final taskItem = TaskItem(
      id: _uuid.v4(),
      title: itemTitle,
      description: description,
      createdAt: DateTime.now(),
    );

    final updatedItems = List<TaskItem>.from(_yaruKotoList[yaruKotoIndex].items)
      ..add(taskItem);

    final updatedYaruKoto = _yaruKotoList[yaruKotoIndex].copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error adding task item: $e');
    }
  }

  /// 頁E��にタスクを追加
  Future<void> addTask(String yaruKotoId, String taskItemId, String taskTitle) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskItemIndex = yaruKoto.items.indexWhere((e) => e.id == taskItemId);
    if (taskItemIndex == -1) return;

    final task = Task(
      id: _uuid.v4(),
      title: taskTitle,
      createdAt: DateTime.now(),
    );

    final updatedTasks = List<Task>.from(yaruKoto.items[taskItemIndex].tasks)
      ..add(task);

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskItemIndex] = updatedItems[taskItemIndex].copyWith(tasks: updatedTasks);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error adding task: $e');
    }
  }

  /// タスクの進捗を更新
  Future<void> updateTaskProgress(String yaruKotoId, String taskItemId, String taskId, TaskProgress progress) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskItemIndex = yaruKoto.items.indexWhere((e) => e.id == taskItemId);
    if (taskItemIndex == -1) return;

    final taskItem = yaruKoto.items[taskItemIndex];
    final taskIndex = taskItem.tasks.indexWhere((e) => e.id == taskId);
    if (taskIndex == -1) return;

    final updatedTasks = List<Task>.from(taskItem.tasks);
    updatedTasks[taskIndex] = updatedTasks[taskIndex].copyWith(progress: progress);

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskItemIndex] = updatedItems[taskItemIndex].copyWith(tasks: updatedTasks);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating task progress: $e');
    }
  }

  /// タスクの進捗を次のスチE��プに進める
  Future<void> nextTaskProgress(String yaruKotoId, String taskItemId, String taskId) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskItemIndex = yaruKoto.items.indexWhere((e) => e.id == taskItemId);
    if (taskItemIndex == -1) return;

    final taskItem = yaruKoto.items[taskItemIndex];
    final taskIndex = taskItem.tasks.indexWhere((e) => e.id == taskId);
    if (taskIndex == -1) return;

    final currentProgress = taskItem.tasks[taskIndex].progress;
    final nextProgress = currentProgress.next;

    await updateTaskProgress(yaruKotoId, taskItemId, taskId, nextProgress);
  }

  /// プロジェクトを削除
  Future<void> deleteYaruKoto(String id) async {
    try {
      await _service.deleteYaruKoto(id);
      _yaruKotoList.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting yaru koto: $e');
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
      if (kDebugMode) debugPrint('Error updating yaru koto: $e');
    }
  }

  /// 頁E��を削除
  Future<void> deleteTaskItem(String yaruKotoId, String taskItemId) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final updatedItems = yaruKoto.items.where((e) => e.id != taskItemId).toList();

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting task item: $e');
    }
  }

  /// 頁E��の名前・説明を更新
  Future<void> updateTaskItem(String yaruKotoId, String taskItemId, {String? title, String? description}) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskItemIndex = yaruKoto.items.indexWhere((e) => e.id == taskItemId);
    if (taskItemIndex == -1) return;

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskItemIndex] = updatedItems[taskItemIndex].copyWith(
      title: title,
      description: description,
    );

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating task item: $e');
    }
  }

  /// タスクを削除
  Future<void> deleteTask(String yaruKotoId, String taskItemId, String taskId) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskItemIndex = yaruKoto.items.indexWhere((e) => e.id == taskItemId);
    if (taskItemIndex == -1) return;

    final taskItem = yaruKoto.items[taskItemIndex];
    final updatedTasks = taskItem.tasks.where((e) => e.id != taskId).toList();

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskItemIndex] = updatedItems[taskItemIndex].copyWith(tasks: updatedTasks);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting task: $e');
    }
  }

  /// タスクの名前を更新
  Future<void> updateTask(String yaruKotoId, String taskItemId, String taskId, String newTitle) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskItemIndex = yaruKoto.items.indexWhere((e) => e.id == taskItemId);
    if (taskItemIndex == -1) return;

    final taskItem = yaruKoto.items[taskItemIndex];
    final taskIndex = taskItem.tasks.indexWhere((e) => e.id == taskId);
    if (taskIndex == -1) return;

    final updatedTasks = List<Task>.from(taskItem.tasks);
    updatedTasks[taskIndex] = updatedTasks[taskIndex].copyWith(title: newTitle);

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskItemIndex] = updatedItems[taskItemIndex].copyWith(tasks: updatedTasks);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating task: $e');
    }
  }

  /// 頁E��の頁E��を変更
  Future<void> reorderTaskItems(String yaruKotoId, int oldIndex, int newIndex) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final updatedItems = List<TaskItem>.from(yaruKoto.items);

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
      if (kDebugMode) debugPrint('Error reordering task items: $e');
    }
  }

  /// タスクの頁E��を変更
  Future<void> reorderTasks(String yaruKotoId, String taskItemId, int oldIndex, int newIndex) async {
    final yaruKotoIndex = _yaruKotoList.indexWhere((e) => e.id == yaruKotoId);
    if (yaruKotoIndex == -1) return;

    final yaruKoto = _yaruKotoList[yaruKotoIndex];
    final taskItemIndex = yaruKoto.items.indexWhere((e) => e.id == taskItemId);
    if (taskItemIndex == -1) return;

    final taskItem = yaruKoto.items[taskItemIndex];
    final updatedTasks = List<Task>.from(taskItem.tasks);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Task task = updatedTasks.removeAt(oldIndex);
    updatedTasks.insert(newIndex, task);

    final updatedItems = List<TaskItem>.from(yaruKoto.items);
    updatedItems[taskItemIndex] = updatedItems[taskItemIndex].copyWith(tasks: updatedTasks);

    final updatedYaruKoto = yaruKoto.copyWith(items: updatedItems);

    try {
      await _service.updateYaruKoto(updatedYaruKoto);
      _yaruKotoList[yaruKotoIndex] = updatedYaruKoto;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error reordering tasks: $e');
    }
  }

  /// プロジェクト一覧の頁E��を変更
  Future<void> reorderYaruKoto(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final YaruKoto item = _yaruKotoList.removeAt(oldIndex);
    _yaruKotoList.insert(newIndex, item);

    try {
      for (int i = 0; i < _yaruKotoList.length; i++) {
        await _service.updateYaruKoto(_yaruKotoList[i]);
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error reordering yaru koto: $e');
    }
  }
}
