import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/chat_message_model.dart';

abstract class GeminiApiService {
  Future<String> generateStoryFromConversation(List<ChatMessageModel> messages);
  Future<String> getChatResponse(
      String message, List<ChatMessageModel> context);
  Future<List<String>> generateStoryTags(String content);
  Future<String> improveStoryContent(String content);
  Future<String> generateBiography(List<String> storyContents, String theme);
}

class GeminiApiServiceImpl implements GeminiApiService {
  final Dio _dio;
  late final String _apiKey;

  GeminiApiServiceImpl(this._dio) {
    _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (_apiKey.isEmpty) {
      throw Exception('Gemini API Key not found in environment variables');
    }

    _dio.options.baseUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<String> generateStoryFromConversation(
      List<ChatMessageModel> messages) async {
    final prompt = _buildStoryGenerationPrompt(messages);

    try {
      final response = await _dio.post(
        'gemini-pro:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          }
        },
      );

      final content =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      return content ?? '生成故事时出现错误';
    } on DioException catch (e) {
      throw Exception('生成故事失败: ${e.message}');
    }
  }

  @override
  Future<String> getChatResponse(
      String message, List<ChatMessageModel> context) async {
    final prompt = _buildChatPrompt(message, context);

    try {
      final response = await _dio.post(
        'gemini-pro:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.8,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        },
      );

      final content =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      return content ?? '很抱歉，我现在无法回应。';
    } on DioException catch (e) {
      throw Exception('获取AI回复失败: ${e.message}');
    }
  }

  @override
  Future<List<String>> generateStoryTags(String content) async {
    final prompt = '''
请为以下故事内容生成3-5个相关的标签，标签应该简洁且富有情感色彩。
请只返回标签，用逗号分隔，不要其他内容。

故事内容：
$content
''';

    try {
      final response = await _dio.post(
        'gemini-pro:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.5,
            'maxOutputTokens': 100,
          }
        },
      );

      final content =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      return content?.split(',').map((tag) => tag.trim()).toList() ?? [];
    } on DioException {
      return ['回忆', '温暖', '故事']; // 默认标签
    }
  }

  @override
  Future<String> improveStoryContent(String content) async {
    final prompt = '''
请帮助改善以下故事内容，使其更加温暖、感人和富有文学性。
保持原有的情感和核心内容，但让表达更加优美。

原始内容：
$content
''';

    try {
      final response = await _dio.post(
        'gemini-pro:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 2048,
          }
        },
      );

      final improvedContent =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      return improvedContent ?? content;
    } on DioException {
      return content; // 如果改善失败，返回原内容
    }
  }

  @override
  Future<String> generateBiography(List<String> storyContents, String theme) async {
    final prompt = _buildBiographyPrompt(storyContents, theme);
    
    try {
      final response = await _dio.post(
        'gemini-pro:generateContent?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 3000,
          }
        },
      );

      final content = response.data['candidates'][0]['content']['parts'][0]['text'];
      return content ?? '传记生成时出现错误';
    } on DioException catch (e) {
      throw Exception('传记生成失败: ${e.message}');
    }
  }

  String _buildStoryGenerationPrompt(List<ChatMessageModel> messages) {
    final conversation = messages.map((msg) {
      final role = msg.isUser ? '用户' : 'AI';
      return '$role: ${msg.content}';
    }).join('\n');

    return '''
你是一个温暖的记忆整理师，擅长将对话转化为感人的故事。
请根据以下对话内容，创作一个温暖、治愈的故事。

要求：
1. 保持对话中的核心情感和事件
2. 使用温暖、怀旧的语调
3. 适当添加细节描述，增强画面感
4. 字数控制在500-800字
5. 结尾要有温暖的感悟或寓意

对话内容：
$conversation

请创作故事：
''';
  }

  String _buildChatPrompt(String message, List<ChatMessageModel> context) {
    final contextStr = context.isNotEmpty
        ? context
            .map((msg) => '${msg.isUser ? "用户" : "AI"}: ${msg.content}')
            .join('\n')
        : '';

    return '''
你是"记忆回响"应用中的AI陪伴者，一个温暖、善解人意的朋友。
你的使命是帮助用户整理和珍藏他们的记忆，提供情感支持和陪伴。

性格特点：
- 温暖、耐心、善于倾听
- 富有同理心，能够理解用户的情感
- 善于引导用户分享更多细节
- 语言风格温和、治愈，带有一些诗意
- 会适时提供温暖的建议和感悟

对话历史：
$contextStr

用户说：$message

请以温暖、治愈的方式回应用户，帮助他们整理记忆或提供情感支持：
''';
  }

  String _buildBiographyPrompt(List<String> storyContents, String theme) {
    final stories = storyContents.join('\n\n---\n\n');
    
    String themeDescription;
    switch (theme) {
      case 'classic':
        themeDescription = '经典传记风格：传统的叙述方式，温暖而正式，具有文学性';
        break;
      case 'modern':
        themeDescription = '现代传记风格：现代化的表达，简洁而生动，贴近生活';
        break;
      case 'vintage':
        themeDescription = '复古传记风格：怀旧的语调，充满诗意，富有韵味';
        break;
      case 'elegant':
        themeDescription = '优雅传记风格：优雅的文笔，富有文学性，细腻动人';
        break;
      default:
        themeDescription = '温暖传记风格：温暖治愈，充满人情味';
    }

    return '''
你是一位专业的传记作家，擅长将生活故事编织成感人的传记。
请根据以下故事内容，创作一部完整的个人传记。

写作要求：
1. 风格：$themeDescription
2. 结构：按时间顺序或主题分章节
3. 内容：提炼故事的核心情感和意义
4. 语言：优美流畅，富有感染力
5. 长度：2000-3000字
6. 结尾：有深刻的人生感悟

故事内容：
$stories

请创作传记：
''';
  }
}
