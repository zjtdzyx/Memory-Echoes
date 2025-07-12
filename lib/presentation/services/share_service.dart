import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareText(String text) async {
    await Share.share(text);
  }

  static Future<void> shareStory(String title, String content) async {
    final text = '''
📖 $title

$content

来自记忆回响 - 温暖的记忆分享应用
''';
    await Share.share(text);
  }

  static Future<void> shareBiography(String title, String content) async {
    final text = '''
📜 $title

$content

由记忆回响 AI 生成 - 让每个故事都被珍藏
''';
    await Share.share(text);
  }

  static Future<void> shareApp() async {
    const text = '''
📱 记忆回响 - 温暖的记忆记录与分享应用

用 AI 的力量重新发现生活的故事，让每一个美好的回忆都被珍藏。

立即下载体验！
''';
    await Share.share(text);
  }
}
