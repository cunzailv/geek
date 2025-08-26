@echo off
chcp 65001 > nul
echo 🗄️ 数据库初始化验证脚本

echo 🔍 检查 MongoDB 连接...
mongo --eval "db.adminCommand('ismaster')" > nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MongoDB 连接成功
    
    echo 🔧 执行数据库初始化...
    mongo navigation < init-db.js
    
    if %errorlevel% equ 0 (
        echo ✅ 数据库初始化完成！
        
        echo 📊 验证数据...
        mongo navigation --eval "
        print('用户数量: ' + db.users.countDocuments());
        print('分类数量: ' + db.categories.countDocuments());  
        print('标签数量: ' + db.tags.countDocuments());
        print('导航数量: ' + db.navs.countDocuments());
        "
    ) else (
        echo ❌ 数据库初始化失败
    )
) else (
    echo ❌ MongoDB 连接失败
    echo 请先安装并启动 MongoDB 服务
    echo 运行: install-mongodb.bat
)

echo.
pause