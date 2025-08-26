# MongoDB 安装指导 (Windows)

## 1. 下载 MongoDB

1. 访问 MongoDB 官网: https://www.mongodb.com/try/download/community
2. 选择 Windows 平台和 MSI 安装包
3. 下载最新稳定版本 (推荐 6.0+)

## 2. 安装 MongoDB

1. 运行下载的 MSI 文件
2. 选择 "Complete" 完整安装
3. 勾选 "Install MongoDB as a Service" (安装为Windows服务)
4. 勾选 "Install MongoDB Compass" (可选，图形化管理工具)

## 3. 配置环境变量

1. 右键 "此电脑" → "属性" → "高级系统设置"
2. 点击 "环境变量"
3. 在 "系统变量" 中找到 "Path"，点击 "编辑"
4. 添加MongoDB安装路径：`C:\Program Files\MongoDB\Server\6.0\bin`

## 4. 启动 MongoDB 服务

### 方法一：Windows 服务 (推荐)
```cmd
net start MongoDB
```

### 方法二：手动启动
```cmd
mongod --dbpath "C:\data\db"
```

## 5. 验证安装

打开命令行，输入：
```cmd
mongo --version
```

## 6. 初始化数据库

运行项目根目录下的初始化脚本：
```cmd
mongo navigation < init-db.js
```

## 常见问题

### 问题1：找不到 mongod 命令
- 解决：检查环境变量Path是否正确配置MongoDB路径

### 问题2：无法启动服务
- 解决：以管理员身份运行命令行，执行 `net start MongoDB`

### 问题3：连接被拒绝
- 解决：确保MongoDB服务正在运行，检查端口27017是否被占用

## 配置说明

默认配置：
- 端口：27017
- 数据库名：navigation
- 无用户认证（开发环境）

生产环境建议启用用户认证和安全配置。