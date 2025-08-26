@echo off
chcp 65001 > nul
echo 🚀 启动极客猿导航开发环境...

REM 检查MongoDB服务是否运行
echo 🔍 检查MongoDB服务状态...
sc query MongoDB > nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ MongoDB服务正在运行
) else (
    echo ❌ MongoDB服务未运行，请先启动MongoDB服务
    echo 可以运行: net start MongoDB
    pause
    exit /b 1
)

REM 创建日志目录
if not exist logs mkdir logs

REM 启动后端服务
echo 🔧 启动后端服务...
cd geekape-nav-server
start "后端服务" cmd /k "npm run dev"
cd ..

REM 等待后端服务启动
echo ⏳ 等待后端服务启动...
timeout /t 10 /nobreak > nul

REM 启动前端主站
echo 🎨 启动前端主站...
cd geekape-nav-main
start "前端主站" cmd /k "npm run dev"
cd ..

REM 启动后台管理
echo ⚡ 启动后台管理...
cd geekape-nav-admin
start "后台管理" cmd /k "npm start"
cd ..

echo.
echo 🎉 所有服务启动完成！
echo 📱 前端主站: http://localhost:3000
echo 🔧 后台管理: http://localhost:8000
echo 🔗 API服务: http://localhost:3002
echo.
echo 按任意键退出...
pause > nul