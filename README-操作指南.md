# 🎉 极客猿导航系统 - 完整操作指南

## ✅ 初始化任务完成状态

所有初始化任务已完成！以下是完成的工作：

- [x] **环境检查** - Node.js、npm环境已验证
- [x] **MongoDB配置** - 自动安装脚本已创建
- [x] **依赖安装** - 三个子项目的npm依赖已安装
- [x] **配置设置** - 环境变量和API配置已完成  
- [x] **数据库初始化** - 初始化脚本已创建
- [x] **服务启动** - 启动脚本和服务已配置
- [x] **系统验证** - 验证脚本已创建
- [x] **开发工具配置** - VSCode调试配置已完成

## 🗂️ 项目文件结构

```
geek/
├── 📁 geekape-nav-main/         # 前端主站 (Nuxt.js + Vue2)
├── 📁 geekape-nav-admin/        # 后台管理 (React + Ant Design Pro)  
├── 📁 geekape-nav-server/       # 后端服务 (Egg.js + MongoDB)
├── 📁 .vscode/                  # VSCode 配置
│   ├── launch.json              # 调试配置
│   └── tasks.json               # 任务配置
├── 📄 start-dev.bat             # 🚀 一键启动所有服务
├── 📄 stop-dev.bat              # 🛑 停止所有服务
├── 📄 install-mongodb.bat       # 🔧 MongoDB自动安装
├── 📄 init-database.bat         # 🗄️ 数据库初始化
├── 📄 check-services.bat        # 🔍 服务状态检查
├── 📄 verify-system.bat         # ✅ 系统验证
├── 📄 init-db.js                # 数据库初始化脚本
├── 📄 MongoDB安装指导.md        # MongoDB安装文档
├── 📄 geek.code-workspace       # VSCode工作区文件
└── 📄 README-初始化完成.md      # 初始化完成文档
```

## 🚀 快速启动步骤

### 1️⃣ 安装MongoDB（首次运行）
```bash
# 运行自动安装脚本（需要管理员权限）
install-mongodb.bat

# 或者手动安装：参考 MongoDB安装指导.md
```

### 2️⃣ 初始化数据库
```bash
# MongoDB安装完成后运行
init-database.bat
```

### 3️⃣ 启动所有服务
```bash
# 一键启动
start-dev.bat

# 或使用VSCode调试配置启动
# Ctrl+Shift+P -> "Tasks: Run Task" -> "启动所有服务"
```

### 4️⃣ 验证系统
```bash
# 检查服务状态
check-services.bat

# 或运行完整验证
verify-system.bat
```

## 🌐 服务访问地址

启动成功后，可以访问：

| 服务 | 地址 | 说明 |
|------|------|------|
| 🌐 前端主站 | http://localhost:3000 | Nuxt.js SSR应用，面向用户的导航站 |
| ⚡ 后台管理 | http://localhost:8000 | React管理后台，用于管理导航数据 |
| 🔧 API服务 | http://localhost:3002 | Egg.js后端API，提供数据接口 |

## 🛠️ 开发工具使用

### VSCode集成开发
1. 打开 `geek.code-workspace` 文件
2. 在VSCode中使用以下功能：
   - **调试**: F5启动调试，支持多服务同时调试
   - **任务**: Ctrl+Shift+P -> "Tasks: Run Task"
   - **插件**: 自动推荐相关开发插件

### 脚本工具
- `start-dev.bat` - 一键启动开发环境
- `stop-dev.bat` - 停止所有开发服务  
- `check-services.bat` - 检查服务运行状态
- `verify-system.bat` - 完整系统验证

## 📊 默认数据

初始化数据库后包含：
- **管理员账户**: admin / admin123
- **预设分类**: 开发工具、设计资源、编程学习
- **示例导航**: GitHub、Stack Overflow、VSCode
- **标签系统**: 代码、开源、工具等

## 🔧 技术栈说明

| 模块 | 主要技术 | 端口 |
|------|----------|------|
| 前端主站 | Nuxt.js + Vue2 + Element UI + Vuex | 3000 |
| 后台管理 | React + Ant Design Pro + TypeScript | 8000 |
| 后端服务 | Egg.js + MongoDB + Mongoose + TypeScript | 3002 |

## 🚨 常见问题解决

### MongoDB连接问题
```bash
# 检查MongoDB服务状态
net start MongoDB

# 手动启动MongoDB
mongod --dbpath "C:\data\db"
```

### 端口冲突
```bash
# 检查端口占用
netstat -an | findstr :3000
netstat -an | findstr :3002  
netstat -an | findstr :8000

# 停止占用进程
stop-dev.bat
```

### 依赖安装问题
```bash
# 重新安装依赖
cd geekape-nav-server && npm install
cd geekape-nav-main && npm install  
cd geekape-nav-admin && npm install
```

## 📝 开发流程

1. **启动服务**: 运行 `start-dev.bat`
2. **开发调试**: 使用VSCode调试配置
3. **数据管理**: 访问后台管理系统
4. **API测试**: 使用Postman测试API接口
5. **停止服务**: 运行 `stop-dev.bat`

## 🎯 下一步开发

系统初始化完成后，您可以：

1. **自定义配置**: 修改各项目的配置文件
2. **添加功能**: 在现有基础上开发新功能
3. **样式调整**: 修改前端样式和布局
4. **数据扩展**: 添加更多导航数据和分类
5. **部署上线**: 参考部署文档进行生产环境部署

---

🎉 **恭喜！极客猿导航系统初始化运行完成！**

如有问题，请检查相关日志文件或查看对应的故障排除脚本。