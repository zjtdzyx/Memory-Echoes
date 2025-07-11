# Flutter 应用程序构建指南 - 记忆回响 (Memory Echoes)

> **文档状态**: ✅ 已更新至当前实现版本
> **最后更新**: 2024 年版本 - MVP 核心功能已完成

## 一、macOS 环境准备

### 1. Homebrew 安装软件环境

```bash
# 1. 安装 Flutter SDK
brew install --cask flutter
flutter doctor

# 2. 安装 Xcode
sudo xcodebuild -runFirstLaunch  # 首次运行 Xcode，接受许可协议
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo gem install cocoapods       # 安装 CocoaPods (iOS 依赖管理工具)

# 3. 安装 Android Studio
brew install --cask android-studio
flutter doctor --android-licenses # 接受 Android 许可协议

# 4. 安装 Firebase 环境
dart pub global activate flutterfire_cli # 安装 flutterfire_cli
brew install firebase-cli
```

### 2. Cursor 推荐插件

```
1. Flutter
   官方 Flutter 插件，提供 Dart 语言支持、代码补全、语法高亮、热重载/热重启、
   Widget Inspector、调试工具、新项目向导等核心功能。

2. JSON to Dart
   配合 json_serializable 使用，快速从 JSON 生成 Dart 类的基础结构。

3. Flutter Riverpod Snippets
   提供 Riverpod 相关代码片段，快速生成 Provider、StateNotifierProvider 等。

4. Dart Data Class Generator
   快速生成 Freezed 数据类模板。

5. Flutter Intl
   国际化支持插件。
```

### 3. Flutter 包管理器依赖 (pubspec.yaml) ✅ 已实现

当前项目的 `pubspec.yaml` 已包含所有必要依赖：

```yaml
name: memory_echoes
description: "一个温暖的记忆记录与分享应用"
publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ">=3.1.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # 状态管理 ✅
  flutter_riverpod: ^2.4.9

  # 路由 ✅
  go_router: ^12.1.3

  # Firebase ✅
  firebase_core: ^3.15.1
  firebase_auth: ^5.6.2
  cloud_firestore: ^5.4.1
  firebase_storage: ^12.1.1

  # 网络请求 ✅
  dio: ^5.4.0

  # 本地存储 ✅
  shared_preferences: ^2.2.2

  # JSON 序列化 ✅
  json_annotation: ^4.8.1
  freezed_annotation: ^2.4.1

  # 环境变量 ✅
  flutter_dotenv: ^5.1.0

  # 图片缓存 ✅
  cached_network_image: ^3.3.0

  # 图片选择 ✅
  image_picker: ^1.0.4

  # 路径相关 ✅
  path_provider: ^2.1.2
  path: ^1.8.3

  # 国际化 ✅
  intl: ^0.18.1

  # UI 图标 ✅
  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter

  # 代码检查 ✅
  flutter_lints: ^3.0.0

  # 代码生成 ✅
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
  freezed: ^2.4.6

flutter:
  uses-material-design: true

  assets:
    - .env
    - assets/icons/
    - assets/images/
```

## 二、技术方案 ✅ 已实现

### 1. 核心主题与风格

- **项目名称**: 记忆回响 (Memory Echoes) ✅
- **核心主题**: 温暖治愈、怀旧感伤、非功利性陪伴 ✅
- **设计理念**: "每个人的生活都是一部值得被记录的故事" ✅

### 2. 技术栈选择 ✅ 已完成

#### 前端框架

- **Flutter (Dart)** ✅ - 跨平台一致性 UI，支持 iOS/Android/Web/Desktop
- **Material Design 3** ✅ - 现代化设计系统

#### 状态管理

- **Riverpod 2.4+** ✅ - 编译时安全，易于测试的状态管理
- **Freezed** ✅ - 不可变数据类生成

#### 路由管理

- **GoRouter 12.1+** ✅ - 声明式路由，支持深度链接和认证守卫

#### AI 大模型集成

- **Google Gemini Pro API** ✅ - 智能对话、故事生成、传记创作
- **Dio HTTP Client** ✅ - 强大的网络请求处理

#### 后端即服务 (BaaS)

- **Firebase Authentication** ✅ - 邮箱/密码认证
- **Cloud Firestore** ✅ - NoSQL 文档数据库，实时同步
- **Firebase Storage** ✅ - 图片和音频文件存储

#### 数据处理

- **json_serializable** ✅ - 自动化 JSON 序列化
- **build_runner** ✅ - 代码生成工具链

#### 本地存储

- **shared_preferences** ✅ - 用户偏好设置存储

#### 多媒体

- **cached_network_image** ✅ - 图片缓存优化
- **image_picker** ✅ - 图片选择功能

#### 工具链

- **flutter_dotenv** ✅ - 环境变量安全管理
- **flutter_lints** ✅ - 代码质量检查

### 3. 已实现的核心功能模块 ✅

#### 用户系统 ✅

- **注册与登录**: Firebase Authentication，表单验证，错误反馈
- **会话管理**: 自动持久化，状态同步
- **用户资料**: 头像、昵称管理

#### AI 对话与故事生成 ✅

- **智能对话**: Gemini Pro 多轮对话，上下文维护
- **故事生成**: AI 驱动的结构化故事创作
- **引导提问**: 智能化记忆挖掘

#### 故事库管理 ✅

- **CRUD 操作**: 创建、读取、更新、删除故事
- **分类管理**: 情感标签 (StoryMood 枚举)
- **搜索功能**: 标题、内容、标签搜索
- **时间轴**: 按时间排序的故事浏览

#### 个人传记生成 ✅

- **智能筛选**: 从多个故事中选择关键片段
- **风格定制**: 多种传记写作风格
- **章节组织**: 自动化传记结构

#### 社交分享 ✅

- **公开故事**: 社交广场展示
- **点赞系统**: 基础互动功能
- **隐私控制**: 公开/私密内容控制

#### 多媒体支持 ✅

- **图片管理**: 上传、展示、缓存
- **文件存储**: Firebase Storage 集成

### 4. 项目架构 - Clean Architecture ✅ 已实现

```
presentation/ (表现层) ✅
├── pages/           # 页面组件
├── widgets/         # 可复用 UI 组件
├── providers/       # Riverpod 状态管理
└── routes/          # GoRouter 路由配置

domain/ (领域层) ✅
├── entities/        # 业务实体
├── repositories/    # 仓库接口
├── usecases/        # 业务用例
└── enums/           # 枚举类型

data/ (数据层) ✅
├── datasources/     # 数据源 (Firebase, Gemini API)
├── models/          # 数据模型 (Freezed + JSON)
└── repositories/    # 仓库实现

core/ (核心层) ✅
├── constants/       # 全局常量
├── errors/          # 错误处理
├── services/        # 核心服务
└── utils/           # 工具函数
```

## 三、开发工作流 ✅ 已建立

### 1. 代码生成

```bash
# 生成 Freezed 和 JSON 序列化代码
dart run build_runner build --delete-conflicting-outputs

# 监听文件变化自动生成
dart run build_runner watch
```

### 2. 代码质量

```bash
# 代码分析
flutter analyze

# 运行测试
flutter test

# 格式化代码
dart format .
```

### 3. 调试和热重载

```bash
# 启动开发服务器
flutter run

# 热重载: 在终端中按 'r'
# 热重启: 在终端中按 'R'
```

## 四、部署和发布 ✅ 配置完成

### 1. 环境配置

- **开发环境**: `.env` 文件管理敏感配置
- **Firebase 配置**: 已配置所有平台的 Firebase 项目

### 2. 构建配置

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build macos --release
flutter build windows --release
flutter build linux --release
```

## 五、项目状态总结 ✅

### 已完成的里程碑

- ✅ **基础架构**: Clean Architecture + Riverpod 状态管理
- ✅ **用户认证**: Firebase Auth 集成
- ✅ **数据持久化**: Firestore + Storage 集成
- ✅ **AI 功能**: Gemini Pro API 集成
- ✅ **核心功能**: 故事管理、传记生成、AI 对话
- ✅ **UI/UX**: Material Design 3 + 响应式设计
- ✅ **跨平台**: iOS/Android/Web/Desktop 支持

### 技术亮点

- **类型安全**: Dart 强类型 + Freezed 不可变数据
- **编译时检查**: Riverpod Provider 编译时验证
- **代码生成**: 自动化 JSON 序列化和数据类生成
- **错误处理**: 统一异常处理机制
- **性能优化**: 图片缓存、懒加载、状态管理优化

### 开发体验优化

- **热重载**: 秒级开发反馈
- **类型提示**: 完整的 IDE 支持
- **代码检查**: flutter_lints 规范约束
- **依赖注入**: Riverpod 简化依赖管理

---

> **项目已达到生产就绪状态** 🚀
>
> 当前版本实现了所有 MVP 核心功能，技术架构稳定可靠，代码质量高，具备良好的可维护性和扩展性。可以进入用户测试和部署阶段。
