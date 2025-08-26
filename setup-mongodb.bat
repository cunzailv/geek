@echo off
chcp 65001 > nul
title MongoDB 完整配置脚本
color 0A

echo.
echo ==========================================
echo     🍃 MongoDB 完整配置脚本 🍃
echo ==========================================
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorLevel% == 0 (
    echo ✅ 管理员权限已获取
) else (
    echo ❌ 需要管理员权限运行此脚本
    echo 请右键选择"以管理员身份运行"
    pause
    exit /b 1
)

echo.
echo 🔍 检查MongoDB是否已安装...
where mongod >nul 2>&1
if %errorLevel% == 0 (
    echo ✅ MongoDB已安装
    mongod --version
    goto :configure_existing
) else (
    echo ❌ MongoDB未安装
    goto :install_mongodb
)

:install_mongodb
echo.
echo 📥 开始安装MongoDB...
echo.
echo 选择安装方式:
echo [1] 使用winget自动安装 (推荐)
echo [2] 手动下载安装
echo [3] 使用Chocolatey安装
echo.
set /p choice=请选择 (1-3): 

if "%choice%"=="1" goto :winget_install
if "%choice%"=="2" goto :manual_install  
if "%choice%"=="3" goto :choco_install
goto :install_mongodb

:winget_install
echo.
echo 🚀 使用winget安装MongoDB Community Server...
winget install MongoDB.Server
if %errorLevel% == 0 (
    echo ✅ MongoDB安装成功！
    goto :configure_mongodb
) else (
    echo ❌ winget安装失败，尝试其他方式
    goto :manual_install
)

:choco_install
echo.
echo 🍫 检查Chocolatey...
choco --version >nul 2>&1
if %errorLevel% == 0 (
    echo ✅ Chocolatey已安装，开始安装MongoDB...
    choco install mongodb -y
    if %errorLevel% == 0 (
        echo ✅ MongoDB安装成功！
        goto :configure_mongodb
    ) else (
        echo ❌ Chocolatey安装失败
        goto :manual_install
    )
) else (
    echo ❌ Chocolatey未安装
    echo 是否要安装Chocolatey? (y/n)
    set /p install_choco=
    if /i "%install_choco%"=="y" (
        echo 安装Chocolatey...
        powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        if %errorLevel% == 0 (
            echo ✅ Chocolatey安装成功，重新启动脚本
            pause
            "%~f0"
            exit
        )
    )
    goto :manual_install
)

:manual_install
echo.
echo 📋 手动安装步骤:
echo.
echo 1. 访问MongoDB官网下载页面:
echo    https://www.mongodb.com/try/download/community
echo.
echo 2. 选择平台: Windows
echo 3. 选择版本: 7.0.x (Current)
echo 4. 选择包类型: msi
echo.
echo 5. 下载完成后双击安装，选择以下选项:
echo    - Install Type: Complete
echo    - ✅ Install MongoDB as a Service
echo    - ✅ Install MongoDB Compass (可选)
echo.
echo 6. 安装完成后重新运行此脚本
echo.
echo 按任意键打开下载页面...
pause >nul
start https://www.mongodb.com/try/download/community
echo.
echo 安装完成后按任意键继续...
pause >nul
goto :configure_mongodb

:configure_existing
:configure_mongodb
echo.
echo 🔧 配置MongoDB...

REM 创建数据目录
if not exist "C:\data\db" (
    mkdir "C:\data\db"
    echo ✅ 创建数据目录: C:\data\db
) else (
    echo ✅ 数据目录已存在: C:\data\db
)

REM 创建日志目录
if not exist "C:\data\log" (
    mkdir "C:\data\log"
    echo ✅ 创建日志目录: C:\data\log
) else (
    echo ✅ 日志目录已存在: C:\data\log
)

REM 启动MongoDB服务
echo.
echo 🚀 启动MongoDB服务...
net start MongoDB >nul 2>&1
if %errorLevel__ == 0 (
    echo ✅ MongoDB服务启动成功
) else (
    echo ⚠️  Windows服务启动失败，尝试手动启动...
    start "MongoDB" mongod --dbpath "C:\data\db" --logpath "C:\data\log\mongod.log"
    timeout /t 3 >nul
)

REM 验证MongoDB连接
echo.
echo 🔍 验证MongoDB连接...
timeout /t 5 >nul
mongo --eval "db.adminCommand('ismaster')" >nul 2>&1
if %errorLevel__ == 0 (
    echo ✅ MongoDB连接成功！
    goto :init_database
) else (
    echo ❌ MongoDB连接失败
    echo.
    echo 故障排查:
    echo 1. 检查MongoDB服务是否运行: net start MongoDB
    echo 2. 检查端口27017是否被占用: netstat -an ^| findstr :27017
    echo 3. 检查防火墙设置
    echo 4. 查看MongoDB日志: C:\data\log\mongod.log
    pause
    exit /b 1
)

:init_database
echo.
echo 🗄️  初始化数据库...
if exist "init-db.js" (
    echo 执行数据库初始化脚本...
    mongo navigation < init-db.js
    if %errorLevel__ == 0 (
        echo ✅ 数据库初始化完成！
        
        echo.
        echo 📊 验证初始化数据...
        mongo navigation --eval "
        print('👤 用户数量: ' + db.users.countDocuments());
        print('📂 分类数量: ' + db.categories.countDocuments());  
        print('🏷️  标签数量: ' + db.tags.countDocuments());
        print('🔗 导航数量: ' + db.navs.countDocuments());
        "
    ) else (
        echo ❌ 数据库初始化失败
    )
) else (
    echo ⚠️  找不到数据库初始化脚本 init-db.js
)

echo.
echo 🎉 MongoDB配置完成！
echo.
echo 📋 配置信息:
echo    - 服务端口: 27017
echo    - 数据目录: C:\data\db
echo    - 日志目录: C:\data\log
echo    - 数据库名: navigation
echo.
echo 💡 常用命令:
echo    启动服务: net start MongoDB
echo    停止服务: net stop MongoDB
echo    连接数据库: mongo navigation
echo    查看状态: mongo --eval "db.adminCommand('ismaster')"
echo.
echo 🚀 下一步: 运行 start-dev.bat 启动完整系统
echo.
pause