# 🏗️ アーキテクチャ設計書

## 📋 概要
ゆるたすアプリケーションは、Flutter MVCアーキテクチャパターンを採用し、保守性と拡張性を重視した設計となっています。

## 🎯 アーキテクチャ原則

### 1. 関心の分離（Separation of Concerns）
- **Model**: データ構造とビジネスロジック
- **View**: UI表示とユーザーインタラクション
- **Controller**: 状態管理とデータフロー制御

### 2. 単一責任の原則（Single Responsibility Principle）
- 各クラスは一つの責任のみを持つ
- 変更理由が複数ある場合はクラスを分割

### 3. 依存性逆転の原則（Dependency Inversion Principle）
- 抽象に依存し、具象に依存しない
- インターフェースを通じた疎結合

## 🏛️ レイヤーアーキテクチャ

```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│  ┌─────────────┐  ┌─────────────┐   │
│  │    Views    │  │   Dialogs   │   │
│  └─────────────┘  └─────────────┘   │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│          Application Layer          │
│  ┌─────────────┐  ┌─────────────┐   │
│  │ Controllers │  │   Services  │   │
│  └─────────────┘  └─────────────┘   │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│            Domain Layer             │
│  ┌─────────────┐  ┌─────────────┐   │
│  │   Models    │  │   Entities  │   │
│  └─────────────┘  └─────────────┘   │
└─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────┐
│       Infrastructure Layer          │
│  ┌─────────────┐  ┌─────────────┐   │
│  │   Storage   │  │   External  │   │
│  │             │  │   Services  │   │
│  └─────────────┘  └─────────────┘   │
└─────────────────────────────────────┘
```

## 📦 コンポーネント詳細

### 1. Presentation Layer（プレゼンテーション層）

#### Views
```dart
// 画面コンポーネント
- YaruKotoListView         // プロジェクト一覧画面
- YaruKotoDetailView       // プロジェクト詳細画面（項目一覧）
- TaskItemDetailView       // 項目詳細画面（タスク一覧）
- SettingsView             // 設定画面
```

#### Dialogs
```dart
// ダイアログコンポーネント
- AddYaruKotoDialog        // プロジェクト追加ダイアログ
- EditYaruKotoDialog       // プロジェクト編集ダイアログ
- AddTaskItemDialog        // 項目追加ダイアログ
- EditTaskItemDialog       // 項目編集ダイアログ
- AddTaskDialog            // タスク追加ダイアログ
- EditTaskDialog           // タスク編集ダイアログ
```

### 2. Application Layer（アプリケーション層）

#### Controllers
```dart
// 状態管理・ビジネスロジック制御
YaruKotoController extends ChangeNotifier {
  - List<YaruKoto> _yaruKotoList
  - bool _isLoading
  
  // プロジェクト操作
  + addYaruKoto(String title, String? description)
  + updateYaruKoto(String id, String? title, String? description)
  + deleteYaruKoto(String id)
  + reorderYaruKoto(int oldIndex, int newIndex)
  
  // 項目操作（中間階層）
  + addTaskItem(String yaruKotoId, String itemTitle, String? description)
  + updateTaskItem(String yaruKotoId, String taskItemId, String? title, String? description)
  + deleteTaskItem(String yaruKotoId, String taskItemId)
  + reorderTaskItems(String yaruKotoId, int oldIndex, int newIndex)
  
  // タスク操作（最小単位）
  + addTask(String yaruKotoId, String taskItemId, String taskTitle)
  + updateTask(String yaruKotoId, String taskItemId, String taskId, String newTitle)
  + updateTaskProgress(String yaruKotoId, String taskItemId, String taskId, TaskProgress progress)
  + nextTaskProgress(String yaruKotoId, String taskItemId, String taskId)
  + deleteTask(String yaruKotoId, String taskItemId, String taskId)
  + reorderTasks(String yaruKotoId, String taskItemId, int oldIndex, int newIndex)
}
```

#### Services
```dart
// 外部サービスとの連携
YaruKotoService {
  + getAllYaruKoto(): Future<List<YaruKoto>>
  + saveYaruKoto(List<YaruKoto> list): Future<void>
  + addYaruKoto(YaruKoto yaruKoto): Future<void>
  + updateYaruKoto(YaruKoto yaruKoto): Future<void>
  + deleteYaruKoto(String id): Future<void>
}

AdMobService {
  + initialize(): Future<void>
  + loadBannerAd(): BannerAd
  + loadInterstitialAd(): InterstitialAd
}
```

### 3. Domain Layer（ドメイン層）

#### Models
```dart
// ビジネスドメインのエンティティ
class YaruKoto {
  final String id;
  final String title;
  final String? description;
  final List<TaskItem> items;
  final DateTime createdAt;
  
  double get progressPercentage; // 項目の平均値
  String get progressLabel;
}

class TaskItem {
  final String id;
  final String title;
  final String? description;
  final List<Task> tasks;
  final DateTime createdAt;
  
  double get progressPercentage; // タスクの平均値
  String get progressLabel;
}

class Task {
  final String id;
  final String title;
  final TaskProgress progress;
  final DateTime createdAt;
}

enum TaskProgress {
  notStarted(0, '未着手'),
  inProgress(50, 'ちょっとやった'),
  completed(100, '完了');
}
```

### 4. Infrastructure Layer（インフラストラクチャ層）

#### Storage
```dart
// データ永続化
SharedPreferences {
  + getString(String key): String?
  + setString(String key, String value): Future<bool>
}
```

#### External Services
```dart
// 外部サービス
GoogleMobileAds {
  + initialize(): Future<void>
  + BannerAd
  + InterstitialAd
  + NativeAd
}
```

## 🔄 データフロー

### 1. ユーザーアクション → UI更新
```
User Action → View → Controller → Service → Model → Controller → View
```

### 2. データ永続化フロー
```
Controller → Service → SharedPreferences → JSON Storage
```

### 3. アプリ起動時のデータ読み込み
```
App Start → Controller.loadData() → Service.getAllYaruKoto() → SharedPreferences → JSON Parse → Model List
```

## 🎨 状態管理パターン

### Provider Pattern
```dart
// main.dart
ChangeNotifierProvider(
  create: (context) => YaruKotoController(),
  child: MyApp(),
)

// View
Consumer<YaruKotoController>(
  builder: (context, controller, child) {
    return ListView.builder(
      itemCount: controller.yaruKotoList.length,
      itemBuilder: (context, index) {
        return YaruKotoCard(controller.yaruKotoList[index]);
      },
    );
  },
)
```

## 🚀 拡張性の考慮

### 1. 新機能追加時
```dart
// 新しいサービスの追加
abstract class StatisticsService {
  Future<Statistics> getStatistics();
}

class StatisticsServiceImpl implements StatisticsService {
  @override
  Future<Statistics> getStatistics() async {
    // 実装
  }
}
```

### 2. データストレージの変更
```dart
// 抽象化によりストレージ変更が容易
abstract class StorageService {
  Future<List<YaruKoto>> getAllYaruKoto();
  Future<void> saveYaruKoto(List<YaruKoto> list);
}

class SharedPreferencesStorage implements StorageService {
  // SharedPreferences実装
}

class SqliteStorage implements StorageService {
  // SQLite実装
}
```

## 🔧 テスト戦略

### 1. 単体テスト
```dart
// モデルのテスト
test('YaruKoto progress calculation', () {
  final yaruKoto = YaruKoto(
    id: '1',
    title: 'Test Project',
    items: [
      TaskItem(id: '1', title: 'Task 1', progress: TaskProgress.completed),
      TaskItem(id: '2', title: 'Task 2', progress: TaskProgress.inProgress),
    ],
    createdAt: DateTime.now(),
  );
  
  expect(yaruKoto.progressPercentage, 75.0);
});
```

### 2. 統合テスト
```dart
// Controller + Service のテスト
testWidgets('Add YaruKoto integration test', (tester) async {
  final controller = YaruKotoController();
  await controller.addYaruKoto('Test Project');
  
  expect(controller.yaruKotoList.length, 1);
  expect(controller.yaruKotoList.first.title, 'Test Project');
});
```

## 📈 パフォーマンス最適化

### 1. ListView最適化
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return YaruKotoCard(key: ValueKey(items[index].id), item: items[index]);
  },
)
```

### 2. 状態管理最適化
```dart
// 必要な部分のみ更新
Consumer<YaruKotoController>(
  builder: (context, controller, child) {
    return Text(controller.yaruKotoList.length.toString());
  },
)
```

この設計により、**保守性が高く、拡張しやすいアプリケーション**を実現しています。
