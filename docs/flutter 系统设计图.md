# Flutter 系统设计图 - 记忆回响 (Memory Echoes)

> **文档更新状态**: ✅ 已与当前实现同步 (2024 年版本)
> **实现进度**: MVP 核心功能已完成，包含 AI 对话、故事管理、传记生成等模块

## 1. 系统架构图

### 当前实现状态 ✅

**核心用户角色：**

- **用户 (User)**: ✅ 已实现 - 通过 Flutter App 进行交互
- **管理员 (Admin)**: ✅ 已实现 - 通过 Firebase 控制台管理
- **AI 内容生成 Agent**: ✅ 已实现 - 基于 Gemini Pro 的智能对话和故事生成

**核心技术模块/服务：**

1. **Flutter App (客户端)**: ✅ 已实现
2. **Firebase Authentication**: ✅ 已实现 - 邮箱/密码登录注册
3. **Cloud Firestore**: ✅ 已实现 - 用户、故事、对话数据存储
4. **Firebase Storage**: ✅ 已实现 - 图片和音频文件存储
5. **Google Gemini Pro API**: ✅ 已实现 - AI 对话和故事生成
6. **Firebase Cloud Functions**: 🚧 待扩展 - 后续可用于内容审核

### 系统架构描述

当前系统采用 **Clean Architecture** 分层设计，Flutter App 作为客户端与多个 Firebase 服务和 Google Gemini Pro API 直接交互。

\`\`\`mermaid
graph TB
    User[用户 User] --> FlutterApp[Flutter App<br/>iOS/Android/Web 客户端]
    FlutterApp --> FirebaseAuth[Firebase Authentication<br/>用户注册/登录/会话]
    FlutterApp --> Firestore[Cloud Firestore<br/>用户、故事、传记、<br/>点赞、收藏、对话上下文]
    FlutterApp --> Storage[Firebase Storage<br/>用户图片/音频文件]
    FlutterApp --> GeminiAPI[Google Gemini Pro API<br/>核心故事/传记生成，<br/>引导式提问]

    Admin[管理员 Admin] --> FirebaseConsole[Firebase 控制台]
    FirebaseConsole --> FirebaseAuth
    FirebaseConsole --> Firestore
    FirebaseConsole --> Storage
    
    %% 未来扩展
    CloudFunctions[Firebase Cloud Functions<br/>AI 内容审核 Agent<br/>复杂业务逻辑编排] -.-> Firestore
    CloudFunctions -.-> GeminiAPI
    Admin -.-> CloudFunctions
\`\`\`

### 当前实现的模块结构 ✅

基于 Clean Architecture 的三层结构已完全实现：

\`\`\`
lib/
├── core/                        # ✅ 核心基础模块
│   ├── constants/              # ✅ 全局常量 (主题、路由等)
│   ├── errors/                 # ✅ 错误处理机制
│   ├── services/               # ✅ 核心服务 (文件上传等)
│   └── utils/                  # ✅ 工具函数 (日期格式化、验证等)
├── data/                       # ✅ 数据层
│   ├── datasources/            # ✅ 数据源
│   │   └── remote/            # ✅ 远程数据源
│   │       ├── firebase_auth_datasource.dart      # ✅ Firebase 认证
│   │       ├── firestore_story_datasource.dart    # ✅ Firestore 故事数据
│   │       ├── firebase_storage_datasource.dart   # ✅ 文件存储
│   │       └── gemini_api_service.dart            # ✅ Gemini API 服务
│   ├── models/                 # ✅ 数据模型 (Freezed + JSON)
│   │   ├── user_model.dart     # ✅ 用户模型
│   │   ├── story_model.dart    # ✅ 故事模型
│   │   └── chat_message_model.dart  # ✅ 聊天消息模型
│   └── repositories/           # ✅ 仓库实现
│       ├── auth_repository_impl.dart     # ✅ 认证仓库
│       ├── story_repository_impl.dart    # ✅ 故事仓库
│       └── ai_repository_impl.dart       # ✅ AI 仓库
├── domain/                     # ✅ 领域层
│   ├── entities/               # ✅ 实体类
│   │   ├── user_entity.dart    # ✅ 用户实体
│   │   ├── story_entity.dart   # ✅ 故事实体
│   │   ├── chat_message_entity.dart  # ✅ 聊天消息实体
│   │   └── biography_entity.dart     # ✅ 传记实体
│   ├── enums/                  # ✅ 枚举类型
│   │   └── story_mood.dart     # ✅ 故事情感枚举
│   ├── repositories/           # ✅ 仓库接口
│   │   ├── auth_repository.dart      # ✅ 认证仓库接口
│   │   ├── story_repository.dart     # ✅ 故事仓库接口
│   │   └── ai_repository.dart        # ✅ AI 仓库接口
│   └── usecases/               # ✅ 用例
│       ├── auth_usecases.dart        # ✅ 认证用例
│       ├── story_usecases.dart       # ✅ 故事用例
│       └── ai_chat_usecases.dart     # ✅ AI 聊天用例
├── presentation/               # ✅ 表现层
│   ├── pages/                  # ✅ 页面
│   │   ├── auth/              # ✅ 认证页面 (登录、注册)
│   │   ├── home/              # ✅ 首页
│   │   ├── story/             # ✅ 故事页面 (列表、详情、创建、编辑)
│   │   ├── chat/              # ✅ AI 对话页面
│   │   ├── biography/         # ✅ 传记页面
│   │   ├── social/            # ✅ 社交广场
│   │   ├── search/            # ✅ 搜索页面
│   │   └── settings/          # ✅ 设置页面
│   ├── widgets/               # ✅ 通用组件
│   │   ├── common/            # ✅ 通用组件 (空状态、卡片等)
│   │   ├── story/             # ✅ 故事相关组件
│   │   ├── chat/              # ✅ 聊天相关组件
│   │   └── biography/         # ✅ 传记相关组件
│   ├── providers/             # ✅ Riverpod 状态管理
│   │   ├── auth_provider.dart        # ✅ 认证状态
│   │   ├── story_provider.dart       # ✅ 故事状态
│   │   ├── chat_provider.dart        # ✅ 聊天状态
│   │   └── search_provider.dart      # ✅ 搜索状态
│   └── routes/                # ✅ 路由配置
│       └── app_router.dart    # ✅ GoRouter 路由配置
├── dependency_injection.dart   # ✅ Riverpod 依赖注入
├── firebase_options.dart      # ✅ Firebase 配置
└── main.dart                  # ✅ 应用入口
\`\`\`

### 依赖关系说明 ✅

- **Presentation** 层通过 Riverpod Providers 调用 **Domain** 层的 UseCases
- **Domain** 层的 UseCases 调用抽象的 Repository 接口
- **Data** 层实现 Repository 接口，协调各种 DataSources
- 所有层都可以使用 **Core** 层的通用工具和常量
- 依赖注入通过 `dependency_injection.dart` 统一管理

## 3. 核心功能实现状态

### ✅ 已实现功能

1. **用户认证系统**

   - 邮箱/密码注册登录
   - 会话持久化
   - 用户状态管理

2. **AI 对话系统**

   - Gemini Pro API 集成
   - 多轮对话上下文维护
   - 实时消息处理

3. **故事管理系统**

   - 故事创建、编辑、删除
   - 故事列表与详情展示
   - 情感标签和分类

4. **传记生成系统**

   - 基于故事的传记生成
   - 多种生成风格支持
   - 传记保存和管理

5. **搜索系统**

   - 故事内容搜索
   - 情感筛选
   - 标签筛选

6. **社交系统**

   - 公开故事浏览
   - 点赞功能架构

7. **多媒体支持**
   - 图片上传与展示
   - Firebase Storage 集成

## 4. 技术栈更新状态

### ✅ 已采用技术

- **前端**: Flutter 3.1.0+ (Dart)
- **状态管理**: Riverpod 2.4+ ✅
- **路由**: GoRouter 12.1+ ✅
- **后端**: Firebase 全家桶 ✅
- **AI**: Google Gemini Pro API ✅
- **网络**: Dio 5.4+ ✅
- **JSON**: json_serializable + Freezed ✅
- **代码生成**: build_runner ✅

### 📋 开发工具链

- **IDE**: VS Code / Cursor ✅
- **版本控制**: Git ✅
- **CI/CD**: 🚧 待配置
- **测试**: flutter_test ✅
- **代码检查**: flutter_lints ✅

---

> **总结**: 当前 MVP 版本已实现所有核心功能，技术架构稳定可靠。文档内容与实际实现高度一致，为后续功能扩展奠定了坚实基础。
