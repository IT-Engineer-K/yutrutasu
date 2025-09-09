# 🎨 デザインガイドライン

## 🌈 カラーパレット

### メインカラー
- **プライマリーグリーン**: `#66BB6A`
  - 用途: メインボタン、アイコン、プログレスバー
  - 意味: 成長、希望、やさしさ

- **ダークグリーン**: `#2E7D2E`
  - 用途: テキスト、見出し、アクセント
  - 意味: 安定、信頼、深み

### サブカラー
- **ライトグリーン**: `#E8F5E8`
  - 用途: カードの境界線、セパレーター
  - 意味: 清潔、穏やか

- **ベージュグリーン**: `#F8FCF8`
  - 用途: カード背景、項目背景
  - 意味: 自然、リラックス

- **ソフトグリーン**: `#AED581`
  - 用途: 空状態のアイコン
  - 意味: 優しさ、包容力

### システムカラー
- **グレー**: `#757575`
  - 用途: 無効状態、補助テキスト
  
- **ライトグレー**: `#9E9E9E`
  - 用途: プレースホルダー、ヒントテキスト

- **ホワイト**: `#FFFFFF`
  - 用途: カード背景、メイン背景

- **エラーレッド**: `#F44336`
  - 用途: 削除ボタン、エラー表示

## 🎭 アイコン・絵文字システム

### 進捗状態の表現
- **未着手**: 
  - 意味: 可能性の種、これから始まる
  
- **進行中**: 🌱（新芽）
  - 意味: 成長の始まり、努力の証
  
- **完了**: 🌳（木）
  - 意味: 成果、達成、成長の完成

### その他のアイコン
- **プロジェクト**: 🌱 Material Icons: `eco`
- **項目追加**: Material Icons: `add_circle_outline`
- **編集**: Material Icons: `edit`
- **削除**: Material Icons: `delete`
- **リスト**: Material Icons: `list_alt`

## 🎯 UI コンポーネント

### 角丸（BorderRadius）統一基準
- **大型カード**: 20px（メインカード、空状態カード）
- **中型カード**: 16px（項目カード、拡張可能カード）
- **小型カード**: 12px（タスクカード、ステータスチップ）
- **ボタン**: 16px（ElevatedButton）、12px（TextButton）
- **入力フィールド**: 16px
- **ダイアログ**: 20px
- **ポップアップメニュー**: 16px
- **FloatingActionButton**: 20px
- **プログレスバー**: 3-4px

### カードデザイン
```dart
Card(
  elevation: 2,
  color: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20), // 大型カード
  ),
  child: // コンテンツ
)
```

### 項目カード
```dart
Card(
  elevation: 1,
  color: const Color(0xFFF8FCF8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16), // 中型カード
    side: const BorderSide(color: Color(0xFFE8F5E8)),
  ),
  child: // コンテンツ
)
```

### ボタンスタイル
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF66BB6A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  child: // テキスト
)
```
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  child: // テキスト
)
```

## 📏 スペーシング

### 標準スペース
- **最小**: 4px
- **小**: 8px
- **中**: 16px
- **大**: 24px
- **特大**: 32px

### コンポーネント間
- **カード間**: 16px
- **セクション間**: 24px
- **画面マージン**: 16px

## 🔤 タイポグラフィ

### 見出し
- **大見出し**: 24px, FontWeight.bold
- **中見出し**: 20px, FontWeight.w600
- **小見出し**: 18px, FontWeight.w600

### 本文
- **通常テキスト**: 16px, FontWeight.w500
- **補助テキスト**: 14px, FontWeight.normal
- **キャプション**: 12px, FontWeight.normal

## 🔄 アニメーション

### 基本原則
- **自然な動き**: イージング関数を使用
- **適切な速度**: 200-400ms
- **意味のある動き**: ユーザーの理解を助ける

### 実装例
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  // プロパティ
)
```

## 📱 レスポンシブデザイン

### ブレークポイント
- **モバイル**: ~600px
- **タブレット**: 600px~1200px
- **デスクトップ**: 1200px~

### 適応方法
- **カードレイアウト**: 画面サイズに応じて列数調整
- **フォントサイズ**: 画面密度に応じて調整
- **タッチターゲット**: 最小44px×44px

## 🎨 使用例

### プロジェクトカード
```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20), // より丸みを持たせた大型カード
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    children: [
      // ヘッダー
      Row(
        children: [
          const Icon(Icons.eco, color: Color(0xFF66BB6A)),
          const SizedBox(width: 8),
          Text(
            'プロジェクト名',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D2E),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      // プログレスバー
      LinearProgressIndicator(
        value: 0.6,
        backgroundColor: const Color(0xFFE8F5E8),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF66BB6A)),
      ),
    ],
  ),
)
```

このデザインガイドラインにより、**一貫性のある、やさしい印象のUI**を実現できます。
