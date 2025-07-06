# AdMob ネイティブアドバンスト広告 セットアップガイド

## 準備が完了したもの

✅ `.env` ファイル（環境変数設定）
✅ `.gitignore` ファイル（機密情報保護）  
✅ `pubspec.yaml` への依存関係追加
✅ Android `AndroidManifest.xml` 設定
✅ iOS `Info.plist` 設定
✅ AdMob サービスクラス
✅ ネイティブ広告ウィジェット
✅ Android ネイティブ広告ファクトリー
✅ iOS ネイティブ広告ファクトリー
✅ カスタムレイアウトファイル

## 次の手順

### 1. 依存関係をインストール
```bash
flutter pub get
```

### 2. AdMob アカウントの設定

1. [Google AdMob](https://admob.google.com/) でアカウントを作成
2. 新しいアプリを追加
3. ネイティブアドバンスト広告ユニットを作成

### 3. 本番用の AdMob ID を設定

`.env` ファイル内のテスト用 ID を実際の AdMob ID に置き換えてください：

```env
# 本番環境のAdMob App IDとAd Unit IDに置き換え
ANDROID_ADMOB_APP_ID=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
IOS_ADMOB_APP_ID=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX

# ネイティブ広告ユニットID
ANDROID_NATIVE_AD_UNIT_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
IOS_NATIVE_AD_UNIT_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
```

### 4. ネイティブ広告の使用例

```dart
import 'package:yurutasu/src/views/native_ad_widget.dart';
import 'package:yurutasu/src/views/native_ad_sample_screen.dart';

// 基本的なネイティブ広告
const NativeAdWidget()

// カスタムサイズとファクトリーID
const NativeAdWidget(
  height: 250,
  factoryId: 'medium',
)

// サンプル画面を表示
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NativeAdSampleScreen(),
  ),
);
```

### 5. カスタマイズ

#### Android
- レイアウト: `android/app/src/main/res/layout/native_ad_layout.xml`
- ファクトリー: `android/app/src/main/kotlin/.../NativeAdFactoryExample.kt`

#### iOS  
- XIBファイル: `ios/Runner/ListTileNativeAdView.xib` (作成が必要)
- ファクトリー: `ios/Runner/ListTileNativeAdFactory.swift`

## ネイティブ広告の特徴

- ✅ コンテンツに自然に溶け込む
- ✅ アプリのデザインに合わせてカスタマイズ可能
- ✅ ユーザー体験を損なわない
- ✅ 高いクリック率を期待できる

## 注意事項

- ネイティブ広告は必ず「広告」と明記する必要があります
- AdMob ポリシーを遵守してください
- iOS の XIB ファイルは手動で作成する必要があります
- テスト用 ID は開発時のみ使用

## トラブルシューティング

### iOS で XIB ファイルが見つからないエラー
1. Xcode で iOS プロジェクトを開く
2. `ListTileNativeAdView.xib` と `MediumNativeAdView.xib` を作成
3. ネイティブ広告のレイアウトを設定

### Android でレイアウトエラー
- `res/layout` ディレクトリにレイアウトファイルが正しく配置されているか確認
- ファクトリークラスが正しく登録されているか確認
