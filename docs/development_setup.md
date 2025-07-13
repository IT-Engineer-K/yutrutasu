# 🔧 開発環境セットアップガイド

## 📋 前提条件

### 必要なツール
- **Flutter SDK**: ^3.5.3
- **Dart SDK**: ^3.5.3
- **Android Studio**: 最新版（Android開発用）
- **Xcode**: 最新版（iOS開発用・macOSのみ）
- **VS Code**: 推奨エディター

### 対象プラットフォーム
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🚀 セットアップ手順

### 1. リポジトリのクローン
```bash
git clone <repository_url>
cd yurutasu
```

### 2. 依存関係のインストール
```bash
flutter pub get
```

### 3. 環境変数の設定
プロジェクトルートに`.env`ファイルを作成し、AdMob設定を追加してください：

```bash
# .env ファイルを作成
touch .env  # Linux/macOS
# New-Item .env  # Windows PowerShell

# .env に以下の内容を追加
ADMOB_APP_ID_ANDROID=ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx
ADMOB_APP_ID_IOS=ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx
ADMOB_BANNER_AD_UNIT_ID_ANDROID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
ADMOB_BANNER_AD_UNIT_ID_IOS=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
```

### 4. プラットフォーム別設定

#### Android
```bash
# Android SDKのパス確認
flutter doctor

# 必要に応じてライセンス同意
flutter doctor --android-licenses
```

#### iOS（macOSのみ）
```bash
# CocoaPodsのインストール
sudo gem install cocoapods

# iOS依存関係のインストール
cd ios && pod install && cd ..
```

### 5. 実行確認
```bash
# デバイス・エミュレーターの確認
flutter devices

# アプリケーションの実行
flutter run
```

## 🛠️ 開発ツールの設定

### VS Code拡張機能
```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode"
  ]
}
```

### デバッグ設定
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "yurutasu",
      "request": "launch",
      "type": "dart",
      "flutterMode": "debug"
    },
    {
      "name": "yurutasu (Profile)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile"
    },
    {
      "name": "yurutasu (Release)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release"
    }
  ]
}
```

## 📦 パッケージ管理

### 主要依存関係
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  shared_preferences: ^2.2.2    # ローカルストレージ
  uuid: ^4.1.0                  # UUID生成
  google_mobile_ads: ^5.1.0     # AdMob統合
  flutter_dotenv: ^5.1.0        # 環境変数管理

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0         # Linting
  flutter_launcher_icons: ^0.13.1  # アイコン生成
```

### パッケージの更新
```bash
# 依存関係の更新確認
flutter pub outdated

# 更新実行
flutter pub upgrade
```

## 🔧 ビルド設定

### Android
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.konju.yurutasu"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        
        // AdMob App ID
        resValue "string", "admob_app_id", "ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx"
    }
}
```

### iOS
```xml
<!-- ios/Runner/Info.plist -->
<dict>
    <!-- AdMob App ID -->
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>
    
    <!-- アプリ権限 -->
    <key>NSUserTrackingUsageDescription</key>
    <string>広告をパーソナライズするために使用されます</string>
</dict>
```

## 🧪 テスト環境

### 単体テスト
```bash
# 全テスト実行
flutter test

# 特定ファイルのテスト
flutter test test/unit_test.dart

# カバレッジ付きテスト
flutter test --coverage
```

### 統合テスト
```bash
# 統合テスト実行
flutter drive --target=test_driver/app.dart
```

### ウィジェットテスト
```bash
# ウィジェットテスト実行
flutter test test/widget_test.dart
```

## 🚀 ビルド・デプロイ

### Android APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Bundle（Google Play用）
flutter build appbundle --release
```

### iOS
```bash
# iOS Archive
flutter build ios --release

# App Store用
flutter build ipa --release
```

### Web
```bash
# Web用ビルド
flutter build web --release
```

### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📊 パフォーマンス測定

### Flutter Inspector
```bash
# パフォーマンス分析
flutter run --profile

# メモリ使用量確認
flutter run --track-widget-creation
```

### サイズ分析
```bash
# アプリサイズ分析
flutter build apk --analyze-size
flutter build ios --analyze-size
```

## 🔍 デバッグ・トラブルシューティング

### よくある問題と解決法

#### 1. Flutter Doctor の警告
```bash
# 問題の確認
flutter doctor -v

# Android License問題
flutter doctor --android-licenses
```

#### 2. 依存関係の競合
```bash
# パッケージキャッシュクリア
flutter pub cache clean
flutter pub get
```

#### 3. iOS CocoaPods問題
```bash
# Pod再インストール
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

#### 4. Android Gradle問題
```bash
# Gradleキャッシュクリア
cd android
./gradlew clean
cd ..
```

## 📝 コーディング規約

### Dartコード規約
```bash
# コードフォーマット
flutter format .

# Lint実行
flutter analyze

# 自動修正
dart fix --apply
```

### ファイル命名規則
```
クラス名: PascalCase (YaruKotoController)
ファイル名: snake_case (yaru_koto_controller.dart)
変数名: camelCase (yaruKotoList)
定数名: UPPER_SNAKE_CASE (DEFAULT_TITLE)
```

## 🔧 IDEの設定

### VS Code設定
```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 120,
  "dart.insertArgumentPlaceholders": false,
  "dart.showTodos": true,
  "dart.previewLsp": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

これで開発環境のセットアップが完了です！🎉
