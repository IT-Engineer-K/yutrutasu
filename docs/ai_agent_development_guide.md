# 🤖 AIエージェント向け開発ガイド

## 📋 プロジェクト概要

ゆるたすは3階層構造の進捗管理アプリです：
- **YaruKoto** (プロジェクト) → **TaskItem** (項目) → **Task** (タスク)

## 🏗️ アーキテクチャ

### フォルダ構造
```
lib/src/
├── models/          # データモデル
│   ├── yaru_koto.dart
│   ├── task_item.dart
│   └── task.dart
├── controllers/     # ビジネスロジック
│   └── yaru_koto_controller.dart
├── services/        # データ永続化
│   └── yaru_koto_service.dart
└── views/           # UI コンポーネント
    ├── yaru_koto_list_view.dart
    ├── yaru_koto_detail_view.dart
    ├── task_item_detail_view.dart
    └── widgets/         # 再利用可能なウィジェット
        ├── animated_percentage_text.dart
        ├── smooth_animated_linear_progress_indicator.dart
        └── animated_progress_info.dart
```

### データフロー
1. **View** → **Controller** → **Service** → **SharedPreferences**
2. すべての操作は`YaruKotoController`を経由
3. 状態変更は`notifyListeners()`で通知

## 🔧 開発時の注意点

### 型安全性
- すべてのJSONパースでnullチェック実装済み
- `try-catch`でエラーハンドリング必須

### 進捗計算
- **Task**: 0%, 50%, 100%の3段階直接指定
- **TaskItem**: 配下のTaskの平均値
- **YaruKoto**: 配下のTaskItemの平均値

### ID管理
- すべてのエンティティでUUIDを使用
- `_uuid.v4()`で生成

### アニメーション進捗表示
- **AnimatedPercentageText**: 進捗率数値のアニメーション（30.5%形式）
- **SmoothAnimatedLinearProgressIndicator**: 滑らかな進捗バー
- **AnimatedProgressInfo**: ラベル付き進捗表示の統合ウィジェット
- アニメーション時間: 500ms、変化時のみアニメーション実行

## 🛠️ 開発ワークフロー

### 新機能追加時のステップ
1. **モデル**: 必要に応じてプロパティ追加・JSONシリアライゼーション更新
2. **コントローラー**: CRUD操作メソッド追加・エラーハンドリング実装
3. **サービス**: データ永続化処理・例外処理
4. **ビュー**: UI実装・アクセシビリティ対応・アニメーション対応
5. **エラーハンドリング**: try-catch実装
6. **検証**: `flutter analyze`による静的解析・実機動作確認
7. **テスト**: 実機での動作確認・アニメーション動作確認

### コントローラーメソッドの命名規則
- `add{Entity}()`: 追加
- `update{Entity}()`: 更新
- `delete{Entity}()`: 削除
- `reorder{Entities}()`: 並び替え
- `next{Entity}Progress()`: 進捗進める

## 🚨 避けるべきパターン

1. **直接的なState変更**: 必ず`notifyListeners()`を呼ぶ
2. **UIからの直接Service呼び出し**: 必ずController経由
3. **エラーハンドリングの省略**: 例外処理を必ず実装
4. **不要なコメント**: コードは自己説明的に

## 📝 コードスタイル

- **命名**: 日本語概念は英語で、UIテキストは日本語
- **コメント**: 必要最小限、わかりやすいコードを書く
- **Import**: 相対パス使用、アルファベット順
- **型注釈**: 明示的に記述
- **アニメーション**: 一貫性のため専用ウィジェット使用（LinearProgressIndicator直接使用禁止）

## 🔍 デバッグガイド

### よくある問題と解決法
1. **型エラー**: JSON パース時のnull安全性確認
2. **状態同期**: `notifyListeners()`呼び出し確認
3. **データ不整合**: サービス層のエラーハンドリング確認

### デバッグコマンド
```bash
flutter analyze              # 静的解析
flutter run --debug         # デバッグモード実行
flutter logs                # ログ確認
```

## 🎯 今後の拡張方針

1. **テスト充実**: ユニット・ウィジェット・統合テスト
2. **機能追加**: クラウド同期、統計機能
3. **UI改善**: アクセシビリティ、レスポンシブ対応
