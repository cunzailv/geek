@echo off
chcp 65001 > nul
echo 🧪 运行系统验证测试...

echo.
echo 🔧 测试后端 API...
curl -s -o nul -w "状态码: %%{http_code}" http://localhost:3002/api/nav
echo.

echo.
echo 🎨 测试前端主站...
curl -s -o nul -w "状态码: %%{http_code}" http://localhost:3000
echo.

echo.
echo ⚡ 测试后台管理...
curl -s -o nul -w "状态码: %%{http_code}" http://localhost:8000
echo.

echo.
echo 🎉 系统验证完成！
echo.
echo 服务地址:
echo   📱 前端主站: http://localhost:3000
echo   🔧 后台管理: http://localhost:8000  
echo   🔗 API服务: http://localhost:3002
echo.
pause