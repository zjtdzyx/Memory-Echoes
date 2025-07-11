·# 记忆回响 (Memory Echoes)

一个温暖的记忆记录与分享应用，让每一个美好的回忆都被珍藏。

## 🌟 特性

- **AI 智能陪伴**: 基于 Google Gemini Pro 的智能对话系统
- **温暖的设计**: 专注于情感化的用户体验
- **完整的故事生命周期**: 从记录到分享的完整流程
- **个性化传记生成**: AI 驱动的个人传记创作
- **社交化分享**: 温暖回忆的社区分享
- **多媒体支持**: 图片、音频的完整支持

## 🏗️ 技术架构

### 前端框架
- **Flutter**: 跨平台 UI 框架
- **Dart**: 编程语言

### 状态管理
- **Riverpod**: 现代化的状态管理解决方案

### 路由管理
- **GoRouter**: 声明式路由管理

### 后端服务
- **Firebase Authentication**: 用户认证
- **Cloud Firestore**: NoSQL 数据库
- **Firebase Storage**: 文件存储
- **Google Gemini Pro API**: AI 大模型服务

### 架构模式
- **Clean Architecture**: 分层架构设计
- **Repository Pattern**: 数据访问抽象
- **Use Case Pattern**: 业务逻辑封装

## 📱 支持平台

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.1.0
- Dart SDK >= 3.1.0
- Firebase 项目配置

### 安装步骤

1. **克隆项目**
   \`\`\`bash
   git clone https://github.com/your-username/memory-echoes.git
   cd memory-echoes
   \`\`\`

2. **安装依赖**
   \`\`\`bash
   flutter pub get
   \`\`\`

3. **生成代码**
   \`\`\`bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   \`\`\`

4. **配置环境变量**
   
   创建 `.env` 文件并添加必要的配置：
   \`\`\`env
   GEMINI_API_KEY=your_gemini_api_key_here
   \`\`\`

5. **Firebase 配置**
   
   确保已正确配置 Firebase：
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `macos/Runner/GoogleService-Info.plist`

6. **运行应用**
   \`\`\`bash
   flutter run
   \`\`\`

## 📂 项目结构

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

## 🔧 开发指南

### 代码生成

当修改数据模型后，需要重新生成序列化代码：

\`\`\`bash
flutter packages pub run build_runner build --delete-conflicting-outputs
\`\`\`

### 添加新功能

1. 在 `domain/entities/` 中定义实体
2. 在 `domain/repositories/` 中定义仓库接口
3. 在 `domain/usecases/` 中实现用例
4. 在 `data/` 中实现数据层
5. 在 `presentation/` 中实现 UI 层

### 状态管理

使用 Riverpod 进行状态管理：

\`\`\`dart
// 定义提供者
final counterProvider = StateProvider<int>((ref) => 0);

// 在组件中使用
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
\`\`\`

## 🧪 测试

\`\`\`bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/unit/auth_test.dart
\`\`\`

## 📦 构建发布

### Android
\`\`\`bash
flutter build apk --release
flutter build appbundle --release
\`\`\`

### iOS
\`\`\`bash
flutter build ios --release
\`\`\`

### Web
\`\`\`bash
flutter build web --release
\`\`\`

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 联系方式

- 项目链接: [https://github.com/your-username/memory-echoes](https://github.com/your-username/memory-echoes)
- 问题反馈: [Issues](https://github.com/your-username/memory-echoes/issues)

## 🙏 致谢

- [Flutter](https://flutter.dev/) - 跨平台 UI 框架
- [Firebase](https://firebase.google.com/) - 后端即服务
- [Google Gemini](https://ai.google.dev/) - AI 大模型服务
- [Riverpod](https://riverpod.dev/) - 状态管理
- [GoRouter](https://pub.dev/packages/go_router) - 路由管理

---

**让每一个美好的回忆都被珍藏 ❤️**
\`\`\`

## 13. 创建许可证文件

```plaintext file="LICENSE"
MIT License

Copyright (c) 2024 Memory Echoes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
