import 'package:share_plus/share_plus.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';
import 'package:memory_echoes/domain/entities/biography_entity.dart';

class ShareService {
  static Future<void> shareStory(StoryEntity story) async {
    final text = '''
📖 ${story.title}

${story.content}

${story.tags.isNotEmpty ? '\n🏷️ ${story.tags.join(' #')}' : ''}

来自记忆回响 - 温暖的记忆分享应用
''';

    await Share.share(
      text,
      subject: '分享一个温暖的故事：${story.title}',
    );
  }

  static Future<void> shareBiography(BiographyEntity biography) async {
    final text = '''
📚 ${biography.title}

${biography.content}

来自记忆回响 - 温暖的记忆分享应用
''';

    await Share.share(
      text,
      subject: '分享我的人生传记：${biography.title}',
    );
  }

  static Future<void> shareText(String text, {String? subject}) async {
    await Share.share(
      text,
      subject: subject ?? '来自记忆回响的分享',
    );
  }

  static Future<void> shareAppInvitation() async {
    const text = '''
🌟 推荐一个温暖的记忆分享应用：记忆回响

让AI帮你整理珍贵的回忆，生成专属的人生传记。
每个人的生活都是一部值得被记录的故事。

快来记录你的美好时光吧！
''';

    await Share.share(text, subject: '推荐记忆回响应用');
  }
}
