@echo off
chcp 65001 > nul
title MongoDB 服务管理

:menu
cls
echo.
echo ==========================================
echo      🍃 MongoDB 服务管理 🍃
echo ==========================================
echo.
echo [1] 🟢 启动 MongoDB 服务
echo [2] 🔴 停止 MongoDB 服务  
echo [3] 🔄 重启 MongoDB 服务
echo [4] 📊 查看服务状态
echo [5] 🔗 测试数据库连接
echo [6] 📁 打开数据目录
echo [7] 📄 查看日志文件
echo [8] ❌ 退出
echo.
set /p choice=请选择操作 (1-8): 

if "%choice%"=="1" goto :start_service
if "%choice%"=="2" goto :stop_service
if "%choice%"=="3" goto :restart_service
if "%choice%"=="4" goto :check_status
if "%choice%"=="5" goto :test_connection
if "%choice%"=="6" goto :open_data_dir
if "%choice%"=="7" goto :view_logs
if "%choice%"=="8" goto :exit
goto :menu

:start_service
echo.
echo 🚀 启动 MongoDB 服务...
net start MongoDB
if %errorlevel% == 0 (
    echo ✅ MongoDB 服务启动成功
) else (
    echo ❌ 启动失败，尝试手动启动...
    start "MongoDB" mongod --dbpath "C:\data\db" --logpath "C:\data\log\mongod.log"
    echo ⚠️  MongoDB 已在新窗口中手动启动
)
pause
goto :menu

:stop_service  
echo.
echo 🛑 停止 MongoDB 服务...
net stop MongoDB
if %errorlevel% == 0 (
    echo ✅ MongoDB 服务已停止
) else (
    echo ⚠️  停止服务失败，尝试强制终止进程...
    taskkill /f /im mongod.exe >nul 2>&1
    if %errorlevel% == 0 (
        echo ✅ MongoDB 进程已终止
    ) else (
        echo ❌ 未找到 MongoDB 进程
    )
)
pause
goto :menu

:restart_service
echo.
echo 🔄 重启 MongoDB 服务...
call :stop_service
timeout /t 3 >nul
call :start_service
goto :menu

:check_status
echo.
echo 📊 检查 MongoDB 服务状态...
echo.
sc query MongoDB >nul 2>&1
if %errorlevel% == 0 (
    sc query MongoDB | findstr STATE
    echo.
    netstat -an | findstr :27017 | findstr LISTENING
    if %errorlevel_ == 0 (
        echo ✅ MongoDB 正在监听端口 27017
    ) else (
        echo ❌ MongoDB 未监听端口 27017
    )
) else (
    echo ❌ MongoDB 服务未安装或未找到
)
echo.
echo 🔍 检查 MongoDB 进程...
tasklist /fi "imagename eq mongod.exe" | findstr mongod.exe
if %errorlevel_ == 0 (
    echo ✅ MongoDB 进程正在运行
) else (
    echo ❌ MongoDB 进程未运行
)
pause
goto :menu

:test_connection
echo.
echo 🔗 测试数据库连接...
mongo --eval "db.adminCommand('ismaster')" >nul 2>&1
if %errorlevel_ == 0 (
    echo ✅ 数据库连接成功！
    echo.
    mongo --eval "
    print('🗄️  数据库信息:');
    print('   服务器版本: ' + db.version());
    print('   当前数据库: ' + db.getName());
    print('   可用数据库: ' + db.adminCommand('listDatabases').databases.map(db => db.name).join(', '));
    "
    
    echo.
    echo 📊 navigation 数据库统计:
    mongo navigation --eval "
    if (db.stats().collections > 0) {
        print('   📂 集合数量: ' + db.stats().collections);
        print('   👤 用户数量: ' + db.users.countDocuments());
        print('   📂 分类数量: ' + db.categories.countDocuments());
        print('   🏷️  标签数量: ' + db.tags.countDocuments());
        print('   🔗 导航数量: ' + db.navs.countDocuments());
    } else {
        print('   ⚠️  数据库为空，请运行 init-database.bat 初始化');
    }
    " 2>nul
) else (
    echo ❌ 数据库连接失败
    echo.
    echo 💡 故障排查:
    echo    1. 确保 MongoDB 服务正在运行
    echo    2. 检查端口 27017 是否可用
    echo    3. 检查防火墙设置
    echo    4. 查看 MongoDB 日志文件
)
pause
goto :menu

:open_data_dir
echo.
echo 📁 打开 MongoDB 数据目录...
if exist "C:\data\db" (
    explorer "C:\data\db"
    echo ✅ 已打开数据目录: C:\data\db
) else (
    echo ❌ 数据目录不存在: C:\data\db
    echo 请先运行 setup-mongodb.bat 创建目录
)
pause
goto :menu

:view_logs
echo.
echo 📄 查看 MongoDB 日志...
if exist "C:\data\log\mongod.log" (
    echo 最近的日志内容:
    echo ----------------------------------------
    tail -n 20 "C:\data\log\mongod.log" 2>nul || powershell "Get-Content 'C:\data\log\mongod.log' -Tail 20"
    echo ----------------------------------------
    echo.
    echo 是否要打开完整日志文件? (y/n)
    set /p open_log=
    if /i "%open_log%"=="y" (
        notepad "C:\data\log\mongod.log"
    )
) else (
    echo ❌ 日志文件不存在: C:\data\log\mongod.log
    echo MongoDB 可能未配置日志或使用默认控制台输出
)
pause
goto :menu

:exit
echo.
echo 👋 再见！
timeout /t 2 >nul
exit