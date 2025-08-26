# 极客猿导航系统本地启动设计方案

## 概述

极客猿导航系统是一个基于前后端分离架构的导航站点，包含前端主站、后台管理和后端API三个子系统。本设计文档详细描述项目的本地开发环境启动方案，确保开发者能够快速搭建和运行完整的开发环境。

## 项目架构

### 整体架构图

```mermaid
graph TB
    A[用户浏览器] --> B[前端主站<br/>Nuxt.js:3000]
    C[管理员浏览器] --> D[后台管理<br/>React:8000] 
    B --> E[后端API<br/>Egg.js:3002]
    D --> E
    E --> F[MongoDB<br/>27017]
    
    subgraph "开发环境"
        B
        D  
        E
        F
    end
```

### 子系统说明

| 子系统 | 技术栈 | 端口 | 功能描述 |
|--------|--------|------|----------|
| geekape-nav-main | Nuxt.js + Vue2 + Element UI + Vuex | 3000 | SSR前端主站，面向终端用户的导航展示 |
| geekape-nav-admin | React + Ant Design Pro + TypeScript | 8000 | 后台管理系统，用于管理导航数据 |
| geekape-nav-server | Egg.js + MongoDB + Mongoose + TypeScript | 3002 | RESTful API服务，提供数据接口 |

## 依赖环境要求

### 系统要求
- **操作系统**: Windows 10/11
- **Node.js**: >= 14.0.0 (推荐 16.x)
- **npm**: >= 6.0.0
- **MongoDB**: >= 4.4 (推荐 6.0+)

### 环境检查

```mermaid
flowchart TD
    A[环境检查开始] --> B{Node.js版本检查}
    B -->|≥14.0.0| C{npm版本检查}
    B -->|<14.0.0| D[更新Node.js]
    C -->|≥6.0.0| E{MongoDB服务检查}
    C -->|<6.0.0| F[更新npm]
    E -->|运行中| G[环境检查通过]
    E -->|未运行| H[启动MongoDB服务]
    D --> B
    F --> C
    H --> E
```

## 数据库设计

### MongoDB配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| 数据库名 | navigation | 主数据库 |
| 端口 | 27017 | 默认端口 |
| 认证 | 无 | 开发环境暂无认证 |

### 数据模型关系

```mermaid
erDiagram
    USER ||--o{ NAV : creates
    USER ||--o{ CATEGORY : manages
    USER ||--o{ TAG : creates
    NAV }o--|| CATEGORY : belongs_to
    NAV }o--o{ TAG : has_many
    
    USER {
        ObjectId id
        string username
        string password
        string email
        date createdAt
        date updatedAt
    }
    
    CATEGORY {
        ObjectId id
        string name
        string description
        number sort
        boolean status
        date createdAt
        date updatedAt
    }
    
    NAV {
        ObjectId id
        string title
        string url
        string description
        ObjectId categoryId
        array tagIds
        boolean status
        number sort
        date createdAt
        date updatedAt
    }
    
    TAG {
        ObjectId id
        string name
        string color
        date createdAt
        date updatedAt
    }
```

## 启动流程设计

### 启动时序图

```mermaid
sequenceDiagram
    participant Dev as 开发者
    participant Script as 启动脚本
    participant MongoDB as MongoDB服务
    participant Server as 后端服务
    participant Main as 前端主站
    participant Admin as 后台管理
    
    Dev->>Script: 执行 start-dev.bat
    Script->>MongoDB: 检查MongoDB服务状态
    MongoDB-->>Script: 返回服务状态
    
    alt MongoDB未运行
        Script->>MongoDB: 启动MongoDB服务
        MongoDB-->>Script: 服务启动确认
    end
    
    Script->>Server: 启动后端服务 (端口3002)
    Server-->>Script: 服务启动确认
    
    Script->>Main: 启动前端主站 (端口3000)
    Main-->>Script: 服务启动确认
    
    Script->>Admin: 启动后台管理 (端口8000)
    Admin-->>Script: 服务启动确认
    
    Script-->>Dev: 所有服务启动完成
```

### 启动脚本架构

```mermaid
flowchart TD
    A[start-dev.bat执行] --> B{MongoDB服务检查}
    B -->|服务运行中| C[创建日志目录]
    B -->|服务未运行| D[提示启动MongoDB]
    D --> E[脚本终止]
    
    C --> F[启动后端服务<br/>geekape-nav-server:3002]
    F --> G[等待10秒]
    G --> H[启动前端主站<br/>geekape-nav-main:3000]
    H --> I[启动后台管理<br/>geekape-nav-admin:8000]
    I --> J[显示服务访问地址]
    J --> K[脚本完成]
```

## 环境配置管理

### 配置文件结构

```mermaid
graph TB
    A[项目根目录] --> B[geekape-nav-server/config]
    A --> C[geekape-nav-main/nuxt.config.js]  
    A --> D[geekape-nav-admin/config]
    
    B --> B1[config.default.ts<br/>基础配置]
    B --> B2[config.local.ts<br/>本地开发配置]
    B --> B3[mongodb.ts<br/>数据库配置]
    
    C --> C1[开发环境配置<br/>NODE_ENV=develop]
    C --> C2[API根路径<br/>root=http://localhost:3002/]
    
    D --> D1[config.dev.ts<br/>开发环境配置]
    D --> D2[proxy.ts<br/>代理配置]
```

### 环境变量配置

| 服务 | 变量名 | 值 | 说明 |
|------|--------|-----|------|
| 后端服务 | PORT | 3002 | API服务端口 |
| 后端服务 | MONGODB_URL | mongodb://localhost:27017/navigation | 数据库连接串 |
| 前端主站 | NODE_ENV | develop | 开发环境标识 |
| 前端主站 | root | http://localhost:3002/ | API根路径 |
| 后台管理 | UMI_ENV | dev | UMI开发环境 |
| 后台管理 | REACT_APP_ENV | dev | React应用环境 |

## 服务端架构

### Egg.js后端服务架构

```mermaid
graph TB
    A[HTTP请求] --> B[路由层<br/>app/router.ts]
    B --> C[中间件层]
    C --> D[控制器层<br/>app/controller/]
    D --> E[服务层<br/>app/service/]
    E --> F[模型层<br/>app/model/]
    F --> G[MongoDB数据库]
    
    subgraph "中间件"
























































































































































































































