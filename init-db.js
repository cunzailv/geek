// MongoDB 数据库初始化脚本
// 使用方法: mongo navigation < init-db.js

// 切换到 navigation 数据库
use navigation;

// 创建用户集合
db.createCollection("users");

// 创建导航集合
db.createCollection("navs");

// 创建分类集合
db.createCollection("categories");

// 创建标签集合
db.createCollection("tags");

// 插入默认管理员账户
db.users.insertOne({
  username: "admin",
  password: "$2a$10$Nx0zKz9aFvl6VQ8HjgK8C.Y8X9lQ5mGXc8Wv2yJ9jR4nK7mL3oE8W", // password: admin123
  email: "admin@geekape.net",
  role: "admin",
  createdAt: new Date(),
  updatedAt: new Date()
});

// 插入默认分类
db.categories.insertMany([
  {
    name: "开发工具",
    description: "开发相关工具和资源",
    order: 1,
    status: 1,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: "设计资源",
    description: "UI/UX设计资源",
    order: 2,
    status: 1,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: "编程学习",
    description: "编程教程和学习资源",
    order: 3,
    status: 1,
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

// 插入默认标签
db.tags.insertMany([
  {
    name: "代码",
    description: "代码相关",
    status: 1,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: "开源",
    description: "开源项目",
    status: 1,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: "工具",
    description: "实用工具",
    status: 1,
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

// 插入示例导航数据
db.navs.insertMany([
  {
    title: "GitHub",
    url: "https://github.com",
    description: "全球最大的代码托管平台，汇聚了数百万开发者和项目",
    category: "开发工具",
    tags: ["代码", "开源"],
    status: 1,
    clicks: 0,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    title: "Stack Overflow",
    url: "https://stackoverflow.com",
    description: "程序员问答社区，解决编程问题的最佳平台",
    category: "编程学习",
    tags: ["学习", "问答"],
    status: 1,
    clicks: 0,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    title: "Visual Studio Code",
    url: "https://code.visualstudio.com",
    description: "微软出品的免费开源代码编辑器",
    category: "开发工具",
    tags: ["工具", "编辑器"],
    status: 1,
    clicks: 0,
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

print("✅ 数据库初始化完成！");
print("📊 已创建:");
print("   - " + db.users.countDocuments() + " 个用户");
print("   - " + db.categories.countDocuments() + " 个分类");
print("   - " + db.tags.countDocuments() + " 个标签");
print("   - " + db.navs.countDocuments() + " 个导航");