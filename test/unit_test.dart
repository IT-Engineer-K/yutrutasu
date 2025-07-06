// ゆるたす - ユニットテスト
//
// このファイルはアプリケーションのモデルクラスとビジネスロジックをテストします。

import 'package:flutter_test/flutter_test.dart';
import 'package:yurutasu/src/models/yaru_koto.dart';
import 'package:yurutasu/src/models/task_item.dart';
import 'package:yurutasu/src/models/task.dart';

void main() {
  group('YaruKoto Model Tests', () {
    test('新しいYaruKotoの作成テスト', () {
      final now = DateTime.now();
      final yaruKoto = YaruKoto(
        id: 'test-id',
        title: 'テストプロジェクト',
        description: 'テスト用の説明',
        createdAt: now,
      );
      
      expect(yaruKoto.title, 'テストプロジェクト');
      expect(yaruKoto.description, 'テスト用の説明');
      expect(yaruKoto.items, isEmpty);
      expect(yaruKoto.progressPercentage, 0.0);
    });

    test('進捗率の計算テスト', () {
      final now = DateTime.now();
      final yaruKoto = YaruKoto(
        id: 'test-id',
        title: 'テストプロジェクト',
        createdAt: now,
        items: [],
      );
      final item1 = TaskItem(
        id: 'item1',
        title: '項目1',
        createdAt: now,
        tasks: [],
      );
      final item2 = TaskItem(
        id: 'item2',
        title: '項目2',
        createdAt: now,
        tasks: [],
      );
      
      // タスクを追加
      final task1 = Task(
        id: 'task1',
        title: 'タスク1',
        progress: TaskProgress.completed,
        createdAt: now,
      );
      final task2 = Task(
        id: 'task2',
        title: 'タスク2',
        progress: TaskProgress.notStarted,
        createdAt: now,
      );
      
      item1.tasks.add(task1);
      item1.tasks.add(task2);
      yaruKoto.items.add(item1);
      yaruKoto.items.add(item2);
      
      // 進捗率は25%になるはず（item1: 50%, item2: 0%）
      expect(yaruKoto.progressPercentage, 25.0);
    });
  });

  group('TaskItem Model Tests', () {
    test('タスクアイテムの進捗計算テスト', () {
      final now = DateTime.now();
      final item = TaskItem(
        id: 'test-item',
        title: 'テスト項目',
        createdAt: now,
        tasks: [],
      );
      
      final task1 = Task(
        id: 'task1',
        title: 'タスク1',
        progress: TaskProgress.completed,
        createdAt: now,
      );
      final task2 = Task(
        id: 'task2',
        title: 'タスク2',
        progress: TaskProgress.inProgress,
        createdAt: now,
      );
      final task3 = Task(
        id: 'task3',
        title: 'タスク3',
        progress: TaskProgress.notStarted,
        createdAt: now,
      );
      
      item.tasks.addAll([task1, task2, task3]);
      
      // 進捗率は50%になるはず（100 + 50 + 0）/ 3 = 50
      expect(item.progressPercentage, closeTo(50.0, 0.1));
    });
  });

  group('Task Model Tests', () {
    test('タスクの進捗値テスト', () {
      expect(TaskProgress.notStarted.value, 0);
      expect(TaskProgress.inProgress.value, 50);
      expect(TaskProgress.completed.value, 100);
    });
  });
}
