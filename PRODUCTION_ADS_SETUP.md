# 本番広告への移行手順

## 完了した変更

✅ `.env`ファイルの本番環境設定への更新
✅ Android `AndroidManifest.xml`の本番App ID設定
✅ Android `strings.xml`リソースファイルの作成
✅ iOS `Info.plist`の本番App ID設定
✅ `AdMobConfig`クラスの本番優先ロジック実装

## 次の手順

### 1. AdMob管理画面でApp IDと広告ユニットIDを取得

1. [Google AdMob](https://admob.google.com/)にログイン
2. アプリを選択または新規作成
3. 以下のIDを取得：

#### App ID
- Android: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`
- iOS: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`

#### 広告ユニットID
各プラットフォームで以下の広告タイプを作成：
- インタースティシャル広告
- リワード広告
- ネイティブ広告

### 2. 環境変数ファイル（.env）の更新

`.env`ファイル内の `ca-app-pub-XXXXXXXXXXXXXXXX` 部分を実際のIDに置き換え：

```env
# 実際のIDに置き換え
ANDROID_ADMOB_APP_ID=ca-app-pub-1234567890123456~1234567890
IOS_ADMOB_APP_ID=ca-app-pub-1234567890123456~0987654321

ANDROID_INTERSTITIAL_AD_UNIT_ID=ca-app-pub-1234567890123456/1111111111
IOS_INTERSTITIAL_AD_UNIT_ID=ca-app-pub-1234567890123456/2222222222

ANDROID_REWARDED_AD_UNIT_ID=ca-app-pub-1234567890123456/3333333333
IOS_REWARDED_AD_UNIT_ID=ca-app-pub-1234567890123456/4444444444

ANDROID_NATIVE_AD_UNIT_ID=ca-app-pub-1234567890123456/5555555555
IOS_NATIVE_AD_UNIT_ID=ca-app-pub-1234567890123456/6666666666
```

### 3. プラットフォーム固有設定の更新

#### Android
`android/app/src/main/res/values/strings.xml`の`admob_app_id`を実際のApp IDに更新：

```xml
<string name="admob_app_id">ca-app-pub-1234567890123456~1234567890</string>
```

#### iOS
`ios/Runner/Info.plist`の`GADApplicationIdentifier`を実際のApp IDに更新：

```xml
<string>ca-app-pub-1234567890123456~0987654321</string>
```

### 4. アプリの動作確認

1. `flutter clean`
2. `flutter pub get`
3. デバイスまたはエミュレータでアプリをテスト
4. 広告が正しく表示されることを確認

### 5. 安全措置

- 本番IDが設定されていない場合、自動的にテスト広告にフォールバック
- コンソールに警告メッセージが表示される
- `.env`ファイルは`.gitignore`に含まれているため、機密情報は保護される

## 注意事項

⚠️ **重要**: 本番環境では必ず実際のAdMob IDを使用してください
⚠️ **テスト用IDは本番リリースで使用禁止**
⚠️ **App Store/Play Storeの審査前に本番IDの設定を確認**

## トラブルシューティング

### 広告が表示されない場合
1. AdMob管理画面でアプリとユニットIDが正しく設定されているか確認
2. `.env`ファイルのIDが正しいか確認
3. アプリが AdMob の配信ポリシーに準拠しているか確認

### テスト広告が表示される場合
1. `.env`ファイルの本番IDが`XXXXXXXXXXXXXXXX`になっていないか確認
2. アプリを再ビルドしてキャッシュをクリア
3. コンソールログで警告メッセージを確認
