import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SharingHelpScreen extends StatelessWidget {
  const SharingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOSで共有する方法'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'iOSショートカットで保存',
              icon: Icons.ios_share,
              children: [
                const Text(
                  'iOSの「ショートカット」アプリを使って、InstagramやSafariからレシピを簡単に保存できます。',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildStepCard(
                  step: '1',
                  title: 'ショートカットアプリを開く',
                  description: 'iPhoneに標準搭載されている「ショートカット」アプリを開きます。',
                ),
                _buildStepCard(
                  step: '2',
                  title: '新規ショートカットを作成',
                  description: '右上の「+」ボタンをタップして、「アクションを追加」を選択します。',
                ),
                _buildStepCard(
                  step: '3',
                  title: 'アクションを設定',
                  description: '以下のアクションを順番に追加:\n'
                      '① 共有シートに表示をON\n'
                      '② 入力を受け取る(URL)\n'
                      '③ URLを取得\n'
                      '④ URLを開く → https://hoshipad.vercel.app/add?url=[ショートカット入力]',
                ),
                _buildStepCard(
                  step: '4',
                  title: '名前をつけて保存',
                  description: '「Hoshipadに保存」などの分かりやすい名前をつけて完了をタップ。',
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _launchDetailedGuide(),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('詳しい設定方法を見る'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '使い方',
              icon: Icons.touch_app,
              children: [
                _buildUsageCard(
                  title: 'Instagramから保存',
                  steps: [
                    '料理の投稿を開く',
                    '「...」メニューから「リンクをコピー」',
                    'Safariでリンクを開く',
                    '共有ボタン → 「Hoshipadに保存」',
                  ],
                ),
                const SizedBox(height: 12),
                _buildUsageCard(
                  title: 'Safariから保存',
                  steps: [
                    'レシピページを開く',
                    '共有ボタン → 「Hoshipadに保存」',
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'トラブルシューティング',
              icon: Icons.help_outline,
              children: [
                _buildTroubleshootCard(
                  question: '「Hoshipadに保存」が表示されない',
                  answer: '共有シートを下にスクロールして「ショートカット」セクションを探してください。'
                      'ショートカットアプリで「共有シートに表示」がONになっているか確認してください。',
                ),
                _buildTroubleshootCard(
                  question: 'URLが正しく渡されない',
                  answer: 'ショートカットの「URLを開く」アクションで、URLの末尾に「ショートカット入力」が追加されているか確認してください。',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'その他の方法',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Safariを使用している場合は、ブックマークレット機能も利用できます。'
                      'ホーム画面のブックマークボタンから設定できます。',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 28, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildStepCard({
    required String step,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCard({
    required String title,
    required List<String> steps,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...steps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}. ',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootCard({
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  Future<void> _launchDetailedGuide() async {
    final url = Uri.parse(
      'https://github.com/sin1kbk/hoshipad/blob/main/docs/ios_sharing_guide.md',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
