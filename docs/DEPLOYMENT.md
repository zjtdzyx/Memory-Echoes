# Vercel 部署配置指南

## 🚀 部署流程概述

你的工作流程：

\`\`\`
本地开发 → GitHub 推送 → Vercel 自动部署 → v0 UI 设计 → 继续迭代
\`\`\`

## 📋 部署前检查清单

### 1. 代码准备

- [x] 所有功能已实现并测试
- [x] .env 文件已从 Git 中移除
- [x] .gitignore 已正确配置
- [x] 代码已推送到 GitHub

### 2. Firebase 配置

- [ ] Firebase 项目已创建
- [ ] Firestore 安全规则已部署
- [ ] Firebase Storage 已启用
- [ ] Authentication 已配置

### 3. API Key 管理

- [ ] Gemini API Key 已获取
- [ ] 环境变量已在 Vercel 中配置

## 🔧 Vercel 配置步骤

### 1. 连接 GitHub 仓库

1. **访问 Vercel Dashboard**

   - 登录 [Vercel](https://vercel.com)
   - 点击 "New Project"

2. **导入 GitHub 仓库**

   - 选择你的 GitHub 账户
   - 找到 `Memory-Echoes` 仓库
   - 点击 "Import"

3. **项目配置**
   \`\`\`json
   {
     "name": "memory-echoes",
     "framework": "flutter",
     "buildCommand": "flutter build web",
     "outputDirectory": "build/web",
     "installCommand": "flutter pub get"
   }
   \`\`\`

### 2. 配置环境变量

在 Vercel 项目设置中添加以下环境变量：

#### 必需的环境变量

\`\`\`bash
# AI 功能
GEMINI_API_KEY=your_actual_gemini_api_key_here

# 功能开关
ENABLE_AI_FEATURES=true
ENABLE_VOICE_RECORDING=true
ENABLE_SOCIAL_FEATURES=true

# 开发配置
DEBUG_MODE=false
ENABLE_LOGGING=true
LOG_LEVEL=info

# 网络配置
API_TIMEOUT_SECONDS=30
MAX_RETRY_ATTEMPTS=3
\`\`\`

#### 配置步骤

1. 进入项目 → Settings → Environment Variables
2. 逐个添加上述变量
3. 选择适用的环境（Production, Preview, Development）

### 3. 部署配置

#### vercel.json 配置

\`\`\`json
{
  "github": {
    "silent": true
  },
  "build": {
    "env": {
      "GEMINI_API_KEY": "@gemini-api-key",
      "ENABLE_AI_FEATURES": "true",
      "ENABLE_VOICE_RECORDING": "true",
      "ENABLE_SOCIAL_FEATURES": "true"
    }
  },
  "functions": {
    "pages/api/**/*.dart": {
      "runtime": "dart"
    }
  }
}
\`\`\`

### 4. 自动部署配置

#### 分支策略

- **main 分支** → Production 部署
- **develop 分支** → Preview 部署
- **feature/** 分支 → 开发预览

#### 部署触发器

\`\`\`bash
# 推送到 main 分支时自动部署
git push origin main

# 创建 Pull Request 时创建预览
git push origin feature/new-feature
\`\`\`

## 🎨 v0 集成工作流

### 1. UI 设计流程

1. **在 v0 中设计 UI**

   - 访问 [v0.dev](https://v0.dev)
   - 创建新的组件设计
   - 生成 Flutter 代码

2. **集成到项目**

   \`\`\`bash
   # 创建新的功能分支
   git checkout -b feature/ui-update

   # 复制 v0 生成的代码
   # 适配现有的项目结构

   # 提交更改
   git add .
   git commit -m "ui: update component design from v0"
   git push origin feature/ui-update
   \`\`\`

3. **预览和测试**
   - Vercel 会自动为分支创建预览部署
   - 在预览环境中测试 UI
   - 确认无误后合并到 main 分支

### 2. 持续集成流程

\`\`\`mermaid
graph LR
    A[本地开发] --> B[推送到 GitHub]
    B --> C[Vercel 自动构建]
    C --> D[预览部署]
    D --> E[测试验证]
    E --> F[合并到 main]
    F --> G[生产部署]
    G --> H[v0 UI 设计]
    H --> A
\`\`\`

## 🔍 部署监控

### 1. 部署状态检查

\`\`\`bash
# 检查部署状态
vercel --prod

# 查看部署日志
vercel logs
\`\`\`

### 2. 性能监控

- **Core Web Vitals** 监控
- **构建时间** 优化
- **包大小** 分析

### 3. 错误监控

- Vercel Analytics
- 自定义错误上报
- 用户反馈收集

## 🛠️ 故障排除

### 常见问题

1. **构建失败**

   \`\`\`bash
   # 检查 Flutter 版本
   flutter --version

   # 清理缓存
   flutter clean
   flutter pub get
   \`\`\`

2. **环境变量未生效**

   - 检查变量名拼写
   - 确认环境选择正确
   - 重新部署项目

3. **API 调用失败**
   - 验证 API Key 有效性
   - 检查网络配置
   - 查看 Vercel 函数日志

### 调试命令

\`\`\`bash
# 本地模拟生产环境
vercel dev

# 检查环境变量
vercel env ls

# 查看部署详情
vercel inspect [deployment-url]
\`\`\`

## 📈 优化建议

### 1. 构建优化

- 启用 Tree Shaking
- 压缩资源文件
- 使用 CDN 加速

### 2. 缓存策略

- 静态资源缓存
- API 响应缓存
- 图片优化和缓存

### 3. 性能监控

- 设置性能预算
- 监控关键指标
- 定期性能审计

## 🔄 更新流程

### 日常开发流程

1. **本地开发**

   \`\`\`bash
   git checkout -b feature/new-feature
   # 开发新功能
   git commit -m "feat: add new feature"
   \`\`\`

2. **推送和预览**

   \`\`\`bash
   git push origin feature/new-feature
   # Vercel 自动创建预览部署
   \`\`\`

3. **测试和合并**

   \`\`\`bash
   # 在预览环境测试
   # 创建 Pull Request
   # 合并到 main 分支
   git checkout main
   git merge feature/new-feature
   git push origin main
   \`\`\`

4. **生产部署**
   - Vercel 自动部署到生产环境
   - 监控部署状态和性能

这样你就有了一个完整的 CI/CD 流程！
