@echo off
chcp 65001 > nul
echo 🔧 MongoDB 自动安装脚本

echo 📥 正在下载MongoDB Community Server...
echo 请访问以下链接手动下载：
echo https://www.mongodb.com/try/download/community
echo.
echo 或者使用 Chocolatey 自动安装：

REM 检查是否安装了 Chocolatey
choco --version > nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 检测到 Chocolatey，开始自动安装 MongoDB...
    choco install mongodb -y
    if %errorlevel% equ 0 (
        echo ✅ MongoDB 安装成功！
        goto :configure_mongo
    ) else (
        echo ❌ MongoDB 安装失败
        goto :manual_install
    )
) else (
    echo ❌ 未检测到 Chocolatey 包管理器
    goto :install_chocolatey
)

:install_chocolatey
echo.
echo 🍫 安装 Chocolatey 包管理器...
echo 请以管理员身份运行以下命令：
echo.
echo Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
echo.
echo 安装完成后重新运行此脚本
goto :end

:configure_mongo
echo.
echo 🔧 配置 MongoDB...

REM 创建数据目录
if not exist "C:\data\db" (
    mkdir "C:\data\db"
    echo ✅ 创建数据目录：C:\data\db
)

REM 启动 MongoDB 服务
echo 🚀 启动 MongoDB 服务...
net start MongoDB
if %errorlevel% equ 0 (
    echo ✅ MongoDB 服务启动成功！
) else (
    echo ⚠️ MongoDB 服务启动失败，尝试手动启动...
    mongod --dbpath "C:\data\db" --port 27017
)

echo.
echo 🗄️ 初始化数据库...
mongo navigation < init-db.js
if %errorlevel% equ 0 (
    echo ✅ 数据库初始化成功！
) else (
    echo ❌ 数据库初始化失败
)

goto :end

:manual_install
echo.
echo 📋 手动安装步骤：
echo 1. 访问 https://www.mongodb.com/try/download/community
echo 2. 下载 Windows MSI 安装包
echo 3. 运行安装程序，选择 "Complete" 安装
echo 4. 勾选 "Install MongoDB as a Service"
echo 5. 重新运行此脚本

:end
echo.
echo 💡 提示：
echo   - MongoDB 默认端口：27017
echo   - 数据目录：C:\data\db
echo   - 配置文件：C:\Program Files\MongoDB\Server\6.0\bin\mongod.cfg
echo.
pause