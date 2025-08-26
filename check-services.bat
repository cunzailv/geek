@echo off
chcp 65001 > nul
echo 🚀 服务启动检查脚本

echo.
echo 🔍 检查端口占用情况...
echo 检查端口 3000 (前端主站):
netstat -an | findstr :3000 | findstr LISTENING
if %errorlevel% equ 0 (
    echo ✅ 端口 3000 已被占用 (前端主站可能已启动)
) else (
    echo ❌ 端口 3000 未被占用
)

echo.
echo 检查端口 3002 (后端服务):
netstat -an | findstr :3002 | findstr LISTENING
if %errorlevel% equ 0 (
    echo ✅ 端口 3002 已被占用 (后端服务可能已启动)
) else (
    echo ❌ 端口 3002 未被占用
)

echo.
echo 检查端口 8000 (后台管理):
netstat -an | findstr :8000 | findstr LISTENING  
if %errorlevel% equ 0 (
    echo ✅ 端口 8000 已被占用 (后台管理可能已启动)
) else (
    echo ❌ 端口 8000 未被占用
)

echo.
echo 🌐 尝试访问服务...

echo 测试后端 API...
curl -s -o nul -w "后端服务状态码: %%{http_code}" http://localhost:3002/api/nav 2>nul
echo.

echo 测试前端主站...
curl -s -o nul -w "前端主站状态码: %%{http_code}" http://localhost:3000 2>nul  
echo.

echo 测试后台管理...
curl -s -o nul -w "后台管理状态码: %%{http_code}" http://localhost:8000 2>nul
echo.

echo.
echo 💡 提示：
echo   - 状态码 200: 服务正常运行
echo   - 状态码 000: 服务未启动或连接失败
echo   - 其他状态码: 服务有问题

echo.
pause