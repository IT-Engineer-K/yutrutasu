import 'package:flutter_test/flutter_test.dart';
import 'package:yurutasu/src/models/yaru_koto.dart';
import 'package:yurutasu/src/models/task_item.dart';

void main() {
  group('copyWith バグ修正テスト', () {
    test('TaskItem: 説明フィールドをnullで明示的にクリアできる', () {
      // 初期状態: 説明ありのTaskItemを作成
      final taskItem = TaskItem(
        id: 'test-id',
        title: 'テストタイトル',
        description: '元の説明',
        createdAt: DateTime.now(),
      );
      
      expect(taskItem.description, '元の説明');
      
      // copyWithを使って説明をnullにクリア
      final updatedTaskItem = taskItem.copyWith(
        description: null,
        clearDescription: true,
      );
      
      // 説明がnullになっていることを確認
      expect(updatedTaskItem.description, isNull);
      expect(updatedTaskItem.title, 'テストタイトル'); // 他のフィールドは変更されない
    });
    
    test('TaskItem: 説明フィールドを新しい値で更新できる', () {
      final taskItem = TaskItem(
        id: 'test-id',
        title: 'テストタイトル',
        description: '元の説明',
        createdAt: DateTime.now(),
      );
      
      // copyWithを使って説明を新しい値に更新
      final updatedTaskItem = taskItem.copyWith(
        description: '新しい説明',
      );
      
      expect(updatedTaskItem.description, '新しい説明');
    });
    
    test('TaskItem: descriptionパラメータなしの場合は元の値を保持', () {
      final taskItem = TaskItem(
        id: 'test-id',
        title: 'テストタイトル',
        description: '元の説明',
        createdAt: DateTime.now(),
      );
      
      // descriptionを指定せずにcopyWith
      final updatedTaskItem = taskItem.copyWith(
        title: '新しいタイトル',
      );
      
      expect(updatedTaskItem.description, '元の説明'); // 元の値が保持される
      expect(updatedTaskItem.title, '新しいタイトル');
    });
    
    test('YaruKoto: 説明フィールドをnullで明示的にクリアできる', () {
      final yaruKoto = YaruKoto(
        id: 'test-id',
        title: 'テストプロジェクト',
        description: '元の説明',
        createdAt: DateTime.now(),
      );
      
      expect(yaruKoto.description, '元の説明');
      
      // copyWithを使って説明をnullにクリア
      final updatedYaruKoto = yaruKoto.copyWith(
        description: null,
        clearDescription: true,
      );
      
      expect(updatedYaruKoto.description, isNull);
      expect(updatedYaruKoto.title, 'テストプロジェクト');
    });
    
    test('YaruKoto: 説明フィールドを新しい値で更新できる', () {
      final yaruKoto = YaruKoto(
        id: 'test-id',
        title: 'テストプロジェクト',
        description: '元の説明',
        createdAt: DateTime.now(),
      );
      
      final updatedYaruKoto = yaruKoto.copyWith(
        description: '新しい説明',
      );
      
      expect(updatedYaruKoto.description, '新しい説明');
    });
  });
  
  group('元々のnullクリア動作のテスト', () {
    test('新しい実装で説明が正しくクリアされることを確認', () {
      final taskItem = TaskItem(
        id: 'test-id',
        title: 'テストタイトル',
        description: '消したい説明',
        createdAt: DateTime.now(),
      );
      
      // 新しい実装ではclearDescriptionフラグでクリアできる
      final clearedTaskItem = taskItem.copyWith(
        clearDescription: true,
      );
      
      expect(clearedTaskItem.description, isNull);
    });
    
    test('空文字列の説明を設定できることを確認', () {
      final taskItem = TaskItem(
        id: 'test-id',
        title: 'テストタイトル',
        description: '元の説明',
        createdAt: DateTime.now(),
      );
      
      // 空文字列を設定
      final emptyDescTaskItem = taskItem.copyWith(
        description: '',
      );
      
      expect(emptyDescTaskItem.description, '');
      expect(emptyDescTaskItem.description, isNot(isNull));
    });
  });
}
