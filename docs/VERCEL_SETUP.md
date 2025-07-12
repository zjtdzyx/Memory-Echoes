# Vercel 配置指南

## 🚀 Vercel 环境变量配置

### 1. 访问 Vercel 项目设置

1. 登录 [Vercel Dashboard](https://vercel.com)
2. 找到你的 `Memory-Echoes` 项目
3. 点击项目名称进入项目详情
4. 点击顶部的 **"Settings"** 标签
5. 在左侧菜单中选择 **"Environment Variables"**

### 2. 添加环境变量

点击 **"Add New"** 按钮，逐个添加以下变量：

#### 必需的环境变量

| 变量名                   | 值                      | 环境                             |
| ------------------------ | ----------------------- | -------------------------------- |
| `GEMINI_API_KEY`         | 你的实际 Gemini API Key | Production, Preview, Development |
| `ENABLE_AI_FEATURES`     | `true`                  | Production, Preview, Development |
| `ENABLE_VOICE_RECORDING` | `true`                  | Production, Preview, Development |
| `ENABLE_SOCIAL_FEATURES` | `true`                  | Production, Preview, Development |
| `DEBUG_MODE`             | `false`                 | Production                       |
| `DEBUG_MODE`             | `true`                  | Preview, Development             |

#### 配置步骤截图指南

1. **添加 GEMINI_API_KEY**

   \`\`\`
   Name: GEMINI_API_KEY
   Value: [粘贴你的 Gemini API Key]
   Environment: ✅ Production ✅ Preview ✅ Development
   \`\`\`

2. **添加功能开关**

   \`\`\`
   Name: ENABLE_AI_FEATURES
   Value: true
   Environment: ✅ Production ✅ Preview ✅ Development
   \`\`\`

3. **重复添加其他变量**

### 3. 触发重新部署

添加完所有环境变量后：

1. 进入项目的 **"Deployments"** 标签
2. 点击最新部署右侧的 **"..."** 菜单
3. 选择 **"Redeploy"**
4. 或者简单地推送新的代码到 GitHub 触发自动部署

### 4. 验证部署

部署完成后：

1. 访问你的 Vercel 应用 URL
2. 测试 AI 功能是否正常工作
3. 检查浏览器控制台是否有错误

## 🔧 自动部署配置

### GitHub 集成

你的 GitHub 仓库已经连接到 Vercel，每次推送代码时会自动触发部署：

- **main 分支** → 生产环境部署
- **其他分支** → 预览环境部署

### 部署状态检查

\`\`\`bash
# 检查部署状态
git log --oneline -5  # 查看最近的提交
\`\`\`

### 常见问题排查

1. **环境变量未生效**

   - 检查变量名拼写是否正确
   - 确认已选择正确的环境
   - 重新部署项目

2. **API 调用失败**

   - 验证 Gemini API Key 是否有效
   - 检查 API Key 是否有足够的配额
   - 查看 Vercel 函数日志

3. **构建失败**
   - 检查代码是否有语法错误
   - 确认所有依赖都已正确安装

## 📊 监控和优化

### 性能监控

- 使用 Vercel Analytics 监控应用性能
- 设置 Core Web Vitals 监控
- 监控 API 调用成功率

### 成本控制

- 监控 Gemini API 使用量
- 设置使用量告警
- 优化 API 调用频率

## 🔄 工作流程

### 日常开发流程

1. **本地开发**

   \`\`\`bash
   # 确保本地有 .env 文件
   cp .env.example .env
   # 编辑 .env 文件，添加你的 API Key
   \`\`\`

2. **测试功能**

   \`\`\`bash
   flutter run -d chrome
   \`\`\`

3. **推送到 GitHub**

   \`\`\`bash
   git add .
   git commit -m "feat: add new feature"
   git push origin main
   \`\`\`

4. **自动部署**
   - Vercel 自动检测到 GitHub 推送
   - 自动构建和部署
   - 几分钟后即可访问更新

### v0 UI 设计集成

1. **在 v0 中设计 UI**

   - 访问 [v0.dev](https://v0.dev)
   - 设计新的组件
   - 导出 Flutter 代码

2. **集成到项目**

   \`\`\`bash
   # 创建功能分支
   git checkout -b feature/ui-update

   # 添加新的 UI 组件
   # 适配现有项目结构

   # 提交更改
   git add .
   git commit -m "ui: update design from v0"
   git push origin feature/ui-update
   \`\`\`

3. **预览和测试**
   - Vercel 自动为分支创建预览部署
   - 测试新 UI 是否正常
   - 合并到 main 分支

## 🎯 最佳实践

### 安全性

- 绝不在代码中硬编码 API Key
- 定期轮换 API Key
- 监控 API 使用情况

### 性能优化

- 使用适当的缓存策略
- 优化图片和资源加载
- 实现懒加载

### 用户体验

- 添加加载状态指示器
- 实现错误处理和重试机制
- 提供离线功能支持

这样配置后，你的完整工作流程就是：
`本地开发 → GitHub 推送 → Vercel 自动部署 → v0 UI 设计 → 继续迭代`
