@echo off
:menu
cls
echo MySQL 服务状态：
sc query "MySQL" | find "STATE" | find "RUNNING" >nul
if %errorlevel%==0 (
    echo MySQL 服务正在运行.
) else (
    echo MySQL 服务未运行.
)

echo.
echo MySQL 服务自启动状态：
sc qc "MySQL" | find "START_TYPE" | find "2" >nul
if %errorlevel%==0 (
    echo MySQL 服务已设置为开机自启动.
) else (
    echo MySQL 服务未设置为开机自启动.
)
echo.
echo MySQL 服务监听端口：
netstat -ano | findstr "3306"
if %errorlevel%==0 (
    echo MySQL 服务正在监听 3306 端口.
) else (
    echo MySQL 服务未监听 3306 端口.
)

echo.
echo MySQL 版本信息：
mysql --version 2>nul
echo.
echo 请选择一个操作：
echo 0 - 切换 MySQL 服务状态
echo 1 - 切换 MySQL 服务开机自启动状态
echo 2 - 退出

set /p choice=请输入操作的数字： 

if "%choice%"=="0" (
    net start MySQL 2>nul
    if %errorlevel%==0 (
        echo 启动成功.
    ) else (
        net stop MySQL 2>nul
        if %errorlevel%==0 (
            echo 停止成功.
        ) else (
            echo 无法启动或停止 MySQL 服务.
        )
    )
    timeout /t 5 >nul
    goto menu
) else if "%choice%"=="1" (
    sc qc "MySQL" | find "START_TYPE" | find "2" >nul
    if %errorlevel%==0 (
        sc config MySQL start= demand
        if %errorlevel%==0 (
            echo 已关闭 MySQL 服务的开机自启动.
        ) else (
            echo 无法关闭 MySQL 服务的开机自启动.
        )
    ) else (
        sc config MySQL start= auto
        if %errorlevel%==0 (
            echo 已开启 MySQL 服务的开机自启动.
        ) else (
            echo 无法开启 MySQL 服务的开机自启动.
        )
    )
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="2" (
    exit
) else (
    echo 无效的选项，请重新选择.
    timeout /t 2 >nul
    goto menu
)
