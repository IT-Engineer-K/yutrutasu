import 'package:flutter/material.dart';

/// プライバシーポリシー画面
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late Future<String> _privacyPolicyFuture;

  @override
  void initState() {
    super.initState();
    _privacyPolicyFuture = _loadPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: FutureBuilder<String>(
        future: _privacyPolicyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'プライバシーポリシーの読み込みに失敗しました',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // 再読み込み
                      setState(() {
                        _privacyPolicyFuture = _loadPrivacyPolicy();
                      });
                    },
                    child: const Text('再試行'),
                  ),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // プライバシーポリシー内容
                Text(
                  snapshot.data ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                
                // 最終更新日
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.update,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '最終更新: 2025年7月16日',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // お問い合わせ情報
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.contact_support,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'お問い合わせ',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'プライバシーに関するご質問やご懸念がございましたら、お気軽にお問い合わせください。',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// プライバシーポリシーを読み込み
  Future<String> _loadPrivacyPolicy() async {
    try {
      // assets/privacy_policy.txtから読み込み（将来的に実装予定）
      // 現在は簡略版を返す
      return _getPrivacyPolicyText();
    } catch (e) {
      throw Exception('プライバシーポリシーの読み込みに失敗しました');
    }
  }

  /// プライバシーポリシーのテキストを取得
  String _getPrivacyPolicyText() {
    return '''
プライバシーポリシー

1. はじめに
本アプリケーション「ゆるたす」（以下、「本アプリ」）は、ユーザーのプライバシーを尊重し、個人情報の保護に努めています。本プライバシーポリシーでは、本アプリが収集する情報とその使用方法について説明します。

2. 収集する情報
本アプリは以下の情報を収集する場合があります：
• デバイス識別子（広告ID）
• アプリの使用状況データ
• 広告の表示・クリック情報

3. 情報の使用目的
収集した情報は以下の目的で使用されます：
• 広告の表示とパーソナライゼーション
• アプリの改善とバグ修正
• 統計情報の分析

4. 第三者への情報提供
本アプリは以下の第三者サービスを使用しています：

Google AdMob
• 広告の表示のため
• プライバシーポリシー: https://policies.google.com/privacy

5. データの保存と削除
• ユーザーデータは主にデバイス上にローカル保存されます
• 広告関連のデータは第三者の広告サービスによって管理されます
• ユーザーはアプリをアンインストールすることで、ローカルデータを削除できます

6. 子供のプライバシー
本アプリは13歳未満の子供を対象としていません。13歳未満の子供から故意に個人情報を収集することはありません。

7. プライバシーポリシーの変更
本プライバシーポリシーは予告なく変更される場合があります。重要な変更については、アプリ内で通知します。

8. お問い合わせ
プライバシーに関するご質問やご懸念がある場合は、以下までお問い合わせください：
• GitHub Issues: https://github.com/IT-Engineer-K/yurutasu/issues
''';
  }
}
