# 记忆回响 (Memory Echoes) 🌟

<div align="center">
  <img src="assets/icons/app_icon.png" alt="Memory Echoes Logo" width="120" height="120" />
  
  **一个温暖的记忆记录与分享应用**
  
  让每一个美好的回忆都被珍藏，用 AI 的力量重新发现生活的故事
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.1.0+-02569B?style=flat&logo=flutter)](https://flutter.dev)
  [![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-blue.svg)](https://flutter.dev)
</div>

---

## 📖 项目简介

**记忆回响 (Memory Echoes)** 是一个基于 AI 技术的温暖记忆记录应用。它不仅仅是一个日记工具，更是一个智能的人生故事编织者。通过与 Google Gemini Pro AI 的深度对话，帮助用户从零散的记忆碎片中发现完整的人生故事，并生成个性化的人生传记。

### ✨ 核心理念

> _"每个人的生活都是一部值得被记录的故事"_

我们相信，每个平凡的日子里都蕴含着不平凡的意义。**记忆回响**致力于：

- 🤖 **AI 智能陪伴** - 通过温暖的对话引导，帮你发现记忆的价值
- 💎 **故事化表达** - 将零散记忆编织成完整的人生故事
- 🎨 **情感化设计** - 温暖治愈的界面，让回忆更有温度
- 🌍 **跨平台体验** - 在任何设备上都能记录和回味美好

---

## 🌈 功能特色

### 🤖 AI 智能对话

- **引导式提问**: Gemini Pro 通过智能提问帮你挖掘记忆细节
- **情感理解**: AI 能理解你的情感状态，给予温暖回应
- **故事生成**: 自动将对话内容整理成结构化的故事

### 📚 智能故事管理

- **记忆分类**: 自动识别并分类不同类型的记忆
- **情感标签**: 为每个故事标注情感色彩（快乐、怀念、感动等）
- **时间轴视图**: 以时间线方式浏览人生轨迹

### 📖 个人传记生成

- **智能筛选**: AI 帮你从众多故事中挑选最有意义的片段
- **风格定制**: 支持多种传记写作风格（经典、现代、诗意等）
- **章节组织**: 自动组织成完整的传记章节

### 🌍 温暖社区

- **故事分享**: 与他人分享你的温暖回忆
- **情感共鸣**: 发现与你有相似经历的人
- **隐私保护**: 完全控制哪些内容公开或私密

### 🎵 多媒体支持

- **语音记录**: 支持语音转文字，随时记录灵感
- **图片珍藏**: 为每个故事添加珍贵的照片
- **音频回忆**: 保存那些有意义的声音片段

---

## 🚀 快速开始

### 环境要求

- **Flutter SDK** >= 3.1.0
- **Dart SDK** >= 3.1.0
- **iOS 开发**: Xcode 13.0+ (macOS)
- **Android 开发**: Android Studio
- **Firebase 项目**: 需要配置 Firebase 项目

### 安装步骤

1. **克隆项目**

   \`\`\`bash
   git clone https://github.com/yourusername/memory-echoes.git
   cd memory-echoes
   \`\`\`

2. **配置环境变量**

   \`\`\`bash
   # 复制环境变量模板
   cp .env.example .env
   
   # 编辑 .env 文件，填入你的 Gemini API Key
   # 获取 API Key: https://makersuite.google.com/app/apikey
   nano .env
   \`\`\`

3. **Firebase 配置**

   - 创建 Firebase 项目: https://console.firebase.google.com/
   - 启用 Authentication、Firestore、Storage 服务
   - 下载配置文件并替换项目中的配置文件
   - 部署 Firestore 安全规则（见下文）

2. **安装依赖**

   \`\`\`bash
   flutter pub get
   \`\`\`

3. **生成代码**

   \`\`\`bash
   dart run build_runner build --delete-conflicting-outputs
   \`\`\`

4. **环境配置**

   创建 `.env` 文件：

   \`\`\`env
   GEMINI_API_KEY=your_gemini_api_key_here
   \`\`\`

5. **Firebase 配置**

   确保以下文件已正确配置：

   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `macos/Runner/GoogleService-Info.plist`

6. **运行应用**
   \`\`\`bash
   flutter run
   \`\`\`

---

## 🏗️ 技术架构

### 核心技术栈

- **🎯 前端框架**: Flutter 3.1.0+ (Dart)
- **⚡ 状态管理**: Riverpod 2.4+
- **🧭 路由管理**: GoRouter 12.1+
- **🔥 后端服务**: Firebase (Auth, Firestore, Storage)
- **🤖 AI 引擎**: Google Gemini Pro API
- **🌐 网络请求**: Dio 5.4+

### 架构设计

\`\`\`
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐│
│  │    Pages    │ │   Widgets   │ │      Providers      ││
│  └─────────────┘ └─────────────┘ └─────────────────────┘│
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────────┐
│                Domain Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐│
│  │  Entities   │ │ Repositories│ │      Use Cases      ││
│  └─────────────┘ └─────────────┘ └─────────────────────┘│
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────────┐
│                  Data Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐│
│  │   Models    │ │ DataSources │ │    Repositories     ││
│  └─────────────┘ └─────────────┘ └─────────────────────┘│
└─────────────────────────────────────────────────────────┘
\`\`\`

### 项目结构

\`\`\`
lib/
├── core/                    # 核心基础模块
│   ├── constants/          # 全局常量
│   ├── errors/             # 错误处理
│   ├── services/           # 核心服务
│   └── utils/              # 工具函数
├── data/                   # 数据层
│   ├── datasources/        # 数据源
│   ├── models/             # 数据模型
│   └── repositories/       # 仓库实现
├── domain/                 # 领域层
│   ├── entities/           # 实体类
│   ├── repositories/       # 仓库接口
│   └── usecases/           # 用例
├── presentation/           # 表现层
│   ├── pages/              # 页面
│   ├── widgets/            # 组件
│   ├── providers/          # 状态管理
│   └── routes/             # 路由配置
├── dependency_injection.dart # 依赖注入
├── firebase_options.dart   # Firebase 配置
└── main.dart              # 应用入口
\`\`\`

---

## 🧪 开发指南

### 代码规范

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 编码规范
- 使用 `flutter_lints` 进行代码检查
- 所有公开 API 必须包含文档注释

### 状态管理模式

\`\`\`dart
// 定义 Provider
final storyProvider = StateNotifierProvider<StoryNotifier, List<Story>>((ref) {
  return StoryNotifier(ref.read(storyRepositoryProvider));
});

// 在组件中使用
class StoryListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storyProvider);
    return ListView.builder(/* ... */);
  }
}
\`\`\`

### 测试策略

\`\`\`bash
# 单元测试
flutter test

# 集成测试
flutter test integration_test/

# 代码覆盖率
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
\`\`\`

---

## 📱 支持平台

| 平台       | 状态        | 版本要求               |
| ---------- | ----------- | ---------------------- |
| 📱 iOS     | ✅ 完全支持 | iOS 11.0+              |
| 🤖 Android | ✅ 完全支持 | Android 6.0+ (API 23+) |
| 🌐 Web     | ✅ 完全支持 | 现代浏览器             |
| 🖥️ macOS   | ✅ 完全支持 | macOS 10.14+           |
| 🖥️ Windows | ✅ 完全支持 | Windows 10+            |
| 🐧 Linux   | ✅ 完全支持 | Ubuntu 18.04+          |

---

## 📦 构建发布

### Android

\`\`\`bash
# 构建 APK
flutter build apk --release

# 构建 App Bundle (推荐)
flutter build appbundle --release
\`\`\`

### iOS

\`\`\`bash
# 构建 iOS 应用
flutter build ios --release
\`\`\`

### Web

\`\`\`bash
# 构建 Web 应用
flutter build web --release
\`\`\`

### Desktop

\`\`\`bash
# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release
\`\`\`

---

## 🤝 贡献指南

我们欢迎所有形式的贡献！无论是功能建议、bug 报告，还是代码贡献。

### 贡献流程

1. **Fork** 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 **Pull Request**

### 开发建议

- 在提交 PR 前运行 `flutter analyze` 和 `flutter test`
- 遵循现有的代码风格和架构模式
- 为新功能添加相应的测试用例
- 更新相关文档

---

## 📄 许可证

本项目采用 **MIT 许可证** - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 🙏 致谢

### 核心技术

- **[Flutter](https://flutter.dev)** - 为美丽的跨平台应用提供动力
- **[Firebase](https://firebase.google.com)** - 可靠的后端即服务
- **[Google Gemini](https://ai.google.dev)** - 强大的 AI 语言模型
- **[Riverpod](https://riverpod.dev)** - 优雅的状态管理解决方案

### 设计灵感

- **Material Design 3** - 现代化的设计系统
- **Human Interface Guidelines** - iOS 平台设计规范

### 社区贡献者

感谢所有为这个项目做出贡献的开发者和用户！

---

## 📞 联系我们

- **🐛 问题反馈**: [GitHub Issues](https://github.com/yourusername/memory-echoes/issues)
- **💡 功能建议**: [GitHub Discussions](https://github.com/yourusername/memory-echoes/discussions)
- **📧 邮件联系**: memory.echoes.app@gmail.com
- **🌐 官方网站**: [www.memory-echoes.com](https://www.memory-echoes.com)

---

<div align="center">
  
  **让每一个美好的回忆都被珍藏 ❤️**
  
  *Memory Echoes - Where every moment becomes a story*
  
  ---
  
  如果这个项目对你有帮助，请给我们一个 ⭐ Star！
  
</div>
