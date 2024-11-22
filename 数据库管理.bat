@echo off
:menu
cls
color 1f
echo =========================================
echo             服务管理菜单              
echo =========================================

echo.
:: MySQL, Redis, MongoDB 服务状态概览
echo [服务状态概览]
call :print_service_summary "MySQL" "3306"
call :print_service_summary "Redis" "6379"
call :print_service_summary "MongoDB" "27017"

echo =========================================
echo 请选择一个操作：
echo [1] - 切换 MySQL 服务状态
echo [2] - 切换 MySQL 服务开机自启动状态
echo [3] - 切换 Redis 服务状态
echo [4] - 切换 Redis 服务开机自启动状态
echo [5] - 切换 MongoDB 服务状态
echo [6] - 切换 MongoDB 服务开机自启动状态
echo [7] - 退出

echo.
set /p choice=请输入操作的数字：

if "%choice%"=="1" (
    call :toggle_service "MySQL"
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="2" (
    call :toggle_autostart "MySQL"
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="3" (
    call :toggle_service "Redis"
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="4" (
    call :toggle_autostart "Redis"
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="5" (
    call :toggle_service "MongoDB"
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="6" (
    call :toggle_autostart "MongoDB"
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="7" (
    exit
) else (
    echo 无效的选项，请重新选择.
    timeout /t 2 >nul
    goto menu
)

goto :eof

:: 打印服务状态概览
:print_service_summary
set service_name=%~1
set port=%~2
sc query "%service_name%" | find "STATE" | find "RUNNING" >nul
if %errorlevel%==0 (
    echo  %service_name% 服务状态  ：正在运行
    netstat -ano | findstr "%port%" >nul
    if %errorlevel%==0 (
        echo  监听端口          ：正在监听 %port% 端口
    ) else (
        echo  监听端口          ：未监听 %port% 端口
    )
    echo  内存占用            ：
    if "%service_name%"=="MongoDB" (
        tasklist /fi "imagename eq mongod.exe" /fo table 2>nul | findstr "mongod.exe"
    ) else if "%service_name%"=="MySQL" (
        tasklist /fi "imagename eq mysqld.exe" /fo table 2>nul | findstr "mysqld.exe"
    ) else if "%service_name%"=="Redis" (
        tasklist /fi "imagename eq redis-server.exe" /fo table 2>nul | findstr "redis-server.exe"
    )
) else (
    echo  %service_name% 服务状态  ：未运行
)
echo.
goto :eof

:: 切换服务状态
:toggle_service
set service_name=%~1
sc query "%service_name%" | find "STATE" | find "RUNNING" >nul
if %errorlevel%==0 (
    net stop %service_name% 2>nul
    if %errorlevel%==0 (
        echo %service_name% 服务已停止.
    ) else (
        echo 无法停止 %service_name% 服务.
    )
) else (
    net start %service_name% 2>nul
    if %errorlevel%==0 (
        echo %service_name% 服务已启动.
    ) else (
        echo 无法启动 %service_name% 服务.
    )
)
goto :eof

:: 切换服务自启动状态
:toggle_autostart
set service_name=%~1
sc qc "%service_name%" | find "START_TYPE" | find "2" >nul
if %errorlevel%==0 (
    sc config %service_name% start= demand
    if %errorlevel%==0 (
        echo 已关闭 %service_name% 服务的开机自启动.
    ) else (
        echo 无法关闭 %service_name% 服务的开机自启动.
    )
) else (
    sc config %service_name% start= auto
    if %errorlevel%==0 (
        echo 已开启 %service_name% 服务的开机自启动.
    ) else (
        echo 无法开启 %service_name% 服务的开机自启动.
    )
)
goto :eof
