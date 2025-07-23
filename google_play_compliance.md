# Google Play コンプライアンスチェックリスト

## 実装済み対策

### ✅ 1. プライバシーポリシーの実装
- [x] プライバシーポリシーの作成 (`privacy_policy.md`)
- [x] Web版プライバシーポリシーの作成 (`web/privacy_policy.html`)
- [x] アプリ内でのプライバシーポリシー表示機能 (`PrivacyPolicyScreen`)
- [x] メインメニューからのアクセス

### ✅ 2. AdMobの適切な実装
- [x] テスト広告IDの使用（開発環境）
- [x] 本番環境向けの設定分離（`.env`ファイル）
- [x] 広告の適切な配置とユーザー体験への配慮

### ✅ 3. App Tracking Transparency (ATT) 対応
- [x] `app_tracking_transparency` パッケージの追加
- [x] `AttService` クラスの実装
- [x] iOS用の使用許可説明文の追加
- [x] 適切な広告設定の実装

### ✅ 4. 権限とメタデータの適切な設定
- [x] Android `AndroidManifest.xml` の権限設定
- [x] iOS `Info.plist` の設定
- [x] AdMobメタデータの設定

### ✅ 5. ProGuard設定の最適化
- [x] AdMob関連クラスの保護
- [x] ネイティブ広告ファクトリーの保護
- [x] デバッグ情報の適切な除去

## 今後実装が必要な項目

### 🔄 1. 本番環境での設定
- [ ] 実際のAdMob IDに置き換え
- [ ] テスト広告IDの削除
- [ ] プライバシーポリシーURLの本番環境への設定

### 🔄 2. 追加のプライバシー対応
- [ ] データ収集の最小化
- [ ] ユーザーのオプトアウト機能
- [ ] GDPR対応（EU向け）

### 🔄 3. Google Play Console設定
- [ ] アプリの対象年齢設定（13歳以上）
- [ ] データ安全性セクションの記入
- [ ] 広告IDの使用に関する申告

## デプロイ前チェックリスト

### 必須事項
- [ ] `.env` ファイルの本番環境設定
- [ ] プライバシーポリシーURLの更新
- [ ] テスト広告IDの削除確認
- [ ] アプリの対象年齢設定の確認

### 推奨事項
- [ ] 広告の表示頻度の調整
- [ ] ユーザーフィードバック機能の実装
- [ ] アプリ内通知の適切な実装

## 注意事項

1. **広告ID使用の申告**: Google Play Console で広告IDの使用を適切に申告してください
2. **データ収集の透明性**: 収集するデータについて明確に説明してください
3. **子供向けアプリではない**: 13歳未満を対象としていないことを明確にしてください
4. **定期的な更新**: プライバシーポリシーとコンプライアンス状況を定期的に見直してください

## 参考リンク

- [Google Play デベロッパー プログラム ポリシー](https://support.google.com/googleplay/android-developer/answer/9899234)
- [AdMob ポリシー](https://support.google.com/admob/answer/9760862)
- [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency)
- [GDPR コンプライアンス](https://developers.google.com/admob/ump/android/quick-start)

---

**更新日**: 2025年7月16日
**ステータス**: 基本対策完了 - デプロイ準備中
