# 安全配置指南

## 🔐 API Key 安全管理

### 重要提醒

⚠️ **绝对不要将 API Key 提交到 Git 仓库！**

### 本地开发配置

1. **创建 .env 文件**

   \`\`\`bash
   cp .env.example .env
   \`\`\`

2. **配置 Gemini API Key**

   \`\`\`bash
   # 在 .env 文件中添加
   GEMINI_API_KEY=your_actual_api_key_here
   \`\`\`

3. **获取 API Key**
   - 访问 [Google AI Studio](https://makersuite.google.com/app/apikey)
   - 创建新的 API Key
   - 复制到 .env 文件中

### Vercel 部署配置

1. **在 Vercel Dashboard 中设置环境变量**

   - 进入项目设置
   - 选择 "Environment Variables"
   - 添加以下变量：
     - `GEMINI_API_KEY`: 你的 Gemini API Key
     - `ENABLE_AI_FEATURES`: `true`
     - `ENABLE_VOICE_RECORDING`: `true`
     - `ENABLE_SOCIAL_FEATURES`: `true`

2. **部署时环境变量会自动注入**

### Firebase 配置安全

Firebase 配置文件中的 API Key 是公开的，用于客户端身份验证，相对安全。但仍需要：

1. **配置 Firebase 安全规则**

   - 限制数据库访问权限
   - 验证用户身份
   - 防止未授权访问

2. **启用 App Check（推荐）**
   - 防止 API 滥用
   - 验证请求来源

### 检查清单

- [ ] .env 文件已添加到 .gitignore
- [ ] 从 Git 历史中移除了敏感信息
- [ ] Vercel 环境变量已正确配置
- [ ] Firebase 安全规则已部署
- [ ] 定期轮换 API Key

### 紧急情况处理

如果意外提交了 API Key：

1. **立即撤销 API Key**

   \`\`\`bash
   # 在 Google AI Studio 中撤销旧的 API Key
   \`\`\`

2. **生成新的 API Key**

   \`\`\`bash
   # 创建新的 API Key 并更新配置
   \`\`\`

3. **清理 Git 历史**
   \`\`\`bash
   # 使用 git filter-branch 或 BFG Repo-Cleaner
   # 从所有历史记录中移除敏感信息
   \`\`\`

## 🛡️ 最佳实践

1. **使用环境变量**

   - 所有敏感配置都通过环境变量注入
   - 不在代码中硬编码任何密钥

2. **最小权限原则**

   - API Key 只授予必要的权限
   - 定期审查和更新权限

3. **监控和日志**

   - 监控 API 使用情况
   - 设置异常使用告警

4. **定期轮换**
   - 定期更换 API Key
   - 使用密钥管理服务
