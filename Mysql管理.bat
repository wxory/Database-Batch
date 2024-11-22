@echo off
:menu
cls
echo MySQL ����״̬��
sc query "MySQL" | find "STATE" | find "RUNNING" >nul
if %errorlevel%==0 (
    echo MySQL ������������.
) else (
    echo MySQL ����δ����.
)

echo.
echo MySQL ����������״̬��
sc qc "MySQL" | find "START_TYPE" | find "2" >nul
if %errorlevel%==0 (
    echo MySQL ����������Ϊ����������.
) else (
    echo MySQL ����δ����Ϊ����������.
)
echo.
echo MySQL ��������˿ڣ�
netstat -ano | findstr "3306"
if %errorlevel%==0 (
    echo MySQL �������ڼ��� 3306 �˿�.
) else (
    echo MySQL ����δ���� 3306 �˿�.
)

echo.
echo MySQL �汾��Ϣ��
mysql --version 2>nul
echo.
echo ��ѡ��һ��������
echo 0 - �л� MySQL ����״̬
echo 1 - �л� MySQL ���񿪻�������״̬
echo 2 - �˳�

set /p choice=��������������֣� 

if "%choice%"=="0" (
    net start MySQL 2>nul
    if %errorlevel%==0 (
        echo �����ɹ�.
    ) else (
        net stop MySQL 2>nul
        if %errorlevel%==0 (
            echo ֹͣ�ɹ�.
        ) else (
            echo �޷�������ֹͣ MySQL ����.
        )
    )
    timeout /t 5 >nul
    goto menu
) else if "%choice%"=="1" (
    sc qc "MySQL" | find "START_TYPE" | find "2" >nul
    if %errorlevel%==0 (
        sc config MySQL start= demand
        if %errorlevel%==0 (
            echo �ѹر� MySQL ����Ŀ���������.
        ) else (
            echo �޷��ر� MySQL ����Ŀ���������.
        )
    ) else (
        sc config MySQL start= auto
        if %errorlevel%==0 (
            echo �ѿ��� MySQL ����Ŀ���������.
        ) else (
            echo �޷����� MySQL ����Ŀ���������.
        )
    )
    timeout /t 3 >nul
    goto menu
) else if "%choice%"=="2" (
    exit
) else (
    echo ��Ч��ѡ�������ѡ��.
    timeout /t 2 >nul
    goto menu
)
