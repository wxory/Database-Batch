@echo off
:menu
cls
color 1f
echo =========================================
echo             �������˵�              
echo =========================================

echo.
:: MySQL, Redis, MongoDB ����״̬����
echo [����״̬����]
call :print_service_summary "MySQL" "3306"
call :print_service_summary "Redis" "6379"
call :print_service_summary "MongoDB" "27017"

echo =========================================
echo ��ѡ��һ��������
echo [1] - �л� MySQL ����״̬
echo [2] - �л� MySQL ���񿪻�������״̬
echo [3] - �л� Redis ����״̬
echo [4] - �л� Redis ���񿪻�������״̬
echo [5] - �л� MongoDB ����״̬
echo [6] - �л� MongoDB ���񿪻�������״̬
echo [7] - �˳�

echo.
set /p choice=��������������֣�

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
    echo ��Ч��ѡ�������ѡ��.
    timeout /t 2 >nul
    goto menu
)

goto :eof

:: ��ӡ����״̬����
:print_service_summary
set service_name=%~1
set port=%~2
sc query "%service_name%" | find "STATE" | find "RUNNING" >nul
if %errorlevel%==0 (
    echo  %service_name% ����״̬  ����������
    netstat -ano | findstr "%port%" >nul
    if %errorlevel%==0 (
        echo  �����˿�          �����ڼ��� %port% �˿�
    ) else (
        echo  �����˿�          ��δ���� %port% �˿�
    )
    echo  �ڴ�ռ��            ��
    if "%service_name%"=="MongoDB" (
        tasklist /fi "imagename eq mongod.exe" /fo table 2>nul | findstr "mongod.exe"
    ) else if "%service_name%"=="MySQL" (
        tasklist /fi "imagename eq mysqld.exe" /fo table 2>nul | findstr "mysqld.exe"
    ) else if "%service_name%"=="Redis" (
        tasklist /fi "imagename eq redis-server.exe" /fo table 2>nul | findstr "redis-server.exe"
    )
) else (
    echo  %service_name% ����״̬  ��δ����
)
echo.
goto :eof

:: �л�����״̬
:toggle_service
set service_name=%~1
sc query "%service_name%" | find "STATE" | find "RUNNING" >nul
if %errorlevel%==0 (
    net stop %service_name% 2>nul
    if %errorlevel%==0 (
        echo %service_name% ������ֹͣ.
    ) else (
        echo �޷�ֹͣ %service_name% ����.
    )
) else (
    net start %service_name% 2>nul
    if %errorlevel%==0 (
        echo %service_name% ����������.
    ) else (
        echo �޷����� %service_name% ����.
    )
)
goto :eof

:: �л�����������״̬
:toggle_autostart
set service_name=%~1
sc qc "%service_name%" | find "START_TYPE" | find "2" >nul
if %errorlevel%==0 (
    sc config %service_name% start= demand
    if %errorlevel%==0 (
        echo �ѹر� %service_name% ����Ŀ���������.
    ) else (
        echo �޷��ر� %service_name% ����Ŀ���������.
    )
) else (
    sc config %service_name% start= auto
    if %errorlevel%==0 (
        echo �ѿ��� %service_name% ����Ŀ���������.
    ) else (
        echo �޷����� %service_name% ����Ŀ���������.
    )
)
goto :eof
