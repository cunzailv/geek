@echo off
chcp 65001 > nul
echo 🛑 停止所有开发服务...

echo.
echo 🔍 查找并停止相关进程...

REM 停止端口3000的进程
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do (
    echo 停止端口3000进程 %%a
    taskkill /f /pid %%a > nul 2>&1
)

REM 停止端口3002的进程  
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3002 ^| findstr LISTENING') do (
    echo 停止端口3002进程 %%a
    taskkill /f /pid %%a > nul 2>&1
)

REM 停止端口8000的进程
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING') do (
    echo 停止端口8000进程 %%a
    taskkill /f /pid %%a > nul 2>&1
)

REM 停止所有Node.js相关进程
echo 停止Node.js开发服务进程...
taskkill /f /im node.exe > nul 2>&1
taskkill /f /im npm.cmd > nul 2>&1

echo.
echo ✅ 所有开发服务已停止
echo.
echo 💡 提示：
echo   - 如需重新启动，运行: start-dev.bat
echo   - 或者在VSCode中使用调试配置启动
echo.
pause