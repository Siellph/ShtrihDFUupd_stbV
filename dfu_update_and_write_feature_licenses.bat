@echo off
cls
setlocal EnableDelayedExpansion
rem �ਬ�� �ਯ� ���������� �� �� DFU � ������� �㭪樮������ ��業���
rem � ��� � ࠡ�祩 ��४�ਨ �� ������ ���� �஡���� � ��㣨� ᯥ� ᨬ�����.
rem ���ਬ��, ����� �������� �ਯ� � C:\shtrih_dfu_update
rem ��४��� ������ ���� ����㯭� �� ������(���� ��࠭����� �६���� 䠩��)
rem �冷� � �ਯ⮬ ����室��� �������� dfu-util.exe � console_test_fr_drv_ng.exe, � 䠩� � �㭪樮����묨 ��業��ﬨ ��� ������ licenses.slf
title ���������� ��� �१ ०�� dfu
echo ��稭�� ����� ���������� ��� �१ ०�� dfu
rem �᫨ �᪮�����஢��� ᫥������ ��ப� - �⫠��� �㤥� � ���᮫�, ���� � 䠩�� fr_drv.log � ࠡ�祩 ��४�ਨ
rem set /A FR_DRV_DEBUG_CONSOLE=1
rem ��� 䠩�� १�ࢭ�� ����� ⠡���
set SAVE_TABLES_PATH=tables_backup

cd /d %~dp0
echo %cd%>tmp
set /P PWD=<tmp
rem ���� �� �ᯮ��塞��� 䠩�� ���᮫쭮�� ���, ���ࠧ㬥������ �� �� ��室���� � ࠡ�祩 ��४�ਨ
set "FULL_EXE_PATH=%PWD%\console_test_fr_drv_ng.exe"

:research1
echo ��� ���...
console_test_fr_drv_ng discover > tmp

for /f %%i in ("tmp") do set TMP_SIZE=%%~zi
if %TMP_SIZE% EQU 0 echo �� 㤠���� �����㦨�� ���ன�⢮. �஢���� ᮥ������� � ��� � ������ Enter ��� ����୮�� ���᪠. && pause && goto research1

<tmp (for /f "tokens=1* delims=[]" %%a in ('find /n /v ""') do set "s%%a=%%b")
:choiseKKT1
echo -------------------------------------------------------------------------------------------------------
echo [1]  -  "%s1%"
echo [2]  -  "%s2%"
echo [3]  -  "%s3%"
echo [4]  -  "%s4%"
echo [5]  -  "%s5%"
echo [6]  -  "%s6%"
echo [7]  -  "%s7%"
echo [8]  -  "%s8%"
echo [9]  -  "%s9%"
echo [10] -  "%s10%"
echo [11] -  ������� ����
echo [12] -  ��室
echo -------------------------------------------------------------------------------------------------------


Set /p choice=�롥�� ���, � ���ன �㤥� �����������, �� ᯨ᪠ ��� � ������ Enter: 
if "%choice%"=="1" set "FR_DRV_NG_CT_URL=%s1%"
if "%choice%"=="2" set "FR_DRV_NG_CT_URL=%s2%"
if "%choice%"=="3" set "FR_DRV_NG_CT_URL=%s3%"
if "%choice%"=="4" set "FR_DRV_NG_CT_URL=%s4%"
if "%choice%"=="5" set "FR_DRV_NG_CT_URL=%s5%"
if "%choice%"=="6" set "FR_DRV_NG_CT_URL=%s6%"
if "%choice%"=="7" set "FR_DRV_NG_CT_URL=%s7%"
if "%choice%"=="8" set "FR_DRV_NG_CT_URL=%s8%"
if "%choice%"=="9" set "FR_DRV_NG_CT_URL=%s9%"
if "%choice%"=="10" set "FR_DRV_NG_CT_URL=%s10%"
if "%choice%"=="11" goto research1
if "%choice%"=="12" goto theEnd

if "%FR_DRV_NG_CT_URL%"=="" echo �� ��ࠫ� ���⮥ ���祭��! && goto choiseKKT1

rem ��஫� ���. ����������� ���, �� 㬮�砭�� 30
rem �᫨ �� ���� �ਯ� � ���㦥�� ��� FR_DRV_NG_CT_PASSWORD �ᯮ������ �⠭�����, ���� �� ���㦥���
if "%FR_DRV_NG_CT_PASSWORD%" == "" set "FR_DRV_NG_CT_PASSWORD=30"
echo.
echo ���� ���: "%FR_DRV_NG_CT_URL%"
echo ��஫� ���: "%FR_DRV_NG_CT_PASSWORD%"
echo.
echo ---------------------------------------
echo [1]  -  ��३� � �롮�� ��訢��
echo [2]  -  �������� � �롮�� ������祭��
echo [3]  -  �������� � �����
echo [4]  -  ��室
echo ---------------------------------------
Set /p choice=�롥�� ᮮ⢥����騩 �㭪� ���� ��� �த������� � ������ Enter: 
if "%choice%"=="1" goto choiseFIRMWARE
if "%choice%"=="2" goto choiseKKT1
if "%choice%"=="3" goto research1
if "%choice%"=="4" goto theEnd

:choiseFIRMWARE
echo ---------------------------------------
echo [1]  -  13.02.2020
echo [2]  -  07.05.2020
echo [3]  -  22.12.2020
echo [4]  -  23.04.2021
echo [5]  -  19.07.2021ffd1.2
echo [6]  -  ��室
echo ---------------------------------------
Set /p choice=�롥�� ��訢�� ��� �த������� � ������ Enter: 
if "%choice%"=="1" set "FIRM_VERSION=13.02.2020"
if "%choice%"=="2" set "FIRM_VERSION=07.05.2020"
if "%choice%"=="3" set "FIRM_VERSION=22.12.2020"
if "%choice%"=="4" set "FIRM_VERSION=23.04.2021"
if "%choice%"=="5" set "FIRM_VERSION=19.07.2021ffd1.2"
if "%choice%"=="6" goto theEnd

:GoUpd
console_test_fr_drv_ng z-report
echo ������� ���� ��࠭��� � 䠩� %SAVE_TABLES_PATH%
echo ������ ����� ���...
console_test_fr_drv_ng status>NUL
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
echo ��!
echo ������ �����᪮� �����...
console_test_fr_drv_ng read 18.1.1>tmp
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
set /P SERIAL=<tmp
echo �����᪮� �����: %SERIAL%
echo ������ UIN...
console_test_fr_drv_ng read 23.1.11>tmp
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
set /P UIN=<tmp
echo UIN: %UIN%
set FIRMWARE_FILENAME=firmware\%FIRM_VERSION%\upd_app.bin
IF "%UIN%"=="---" (
   echo UIN ���������
   set FIRMWARE_FILENAME=firmware\%FIRM_VERSION%\upd_app_for_old_frs.bin
)
echo ��� ���������� �㤥� ����: "%FIRMWARE_FILENAME%"
echo ���࠭�� ⠡����...
console_test_fr_drv_ng save-tables > %SAVE_TABLES_PATH%
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
echo ��⮢�!

echo ��१���㦠� ��� � ०�� dfu...
console_test_fr_drv_ng reboot-dfu
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
rem ���諨 � ०�� DFU, ��� 3 ᥪ㭤� � ����᪠�� dfu-util, ��� ᠬ� ������ ���ன�⢮ � ��⠭���� ��訢��, �㦭� ⮫쪮 ��।��� ��� 䠩��
timeout /t 3 /nobreak > NUL
echo|set /p= ����᪠� ���������� �� DFU...
dfu-util -D %FIRMWARE_FILENAME%
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
echo ��⮢�!
echo �������� 15 ᥪ㭤... ��� ��१���㦠����...

rem ᯨ� 15 ᥪ㭤, ��� ������ ���ன�⢠ � ��⥬� ��᫥ ����������
timeout /t 15 /nobreak > NUL
rem 㤠�塞 ��� �ࠢ��� 䠩�ࢮ���, ��� 蠣 �㦥� ��⮬� �� �� ��������� ��� � �ᯮ��塞��� 䠩�� ������� ࠡ���� � �ࠢ���. ���⮬� ����� ࠧ 㤠�塞 ���� �ࠢ��� � ������塞 ����.
netsh advfirewall firewall del rule name="console_test_fr_drv_ng_allow"
echo �������� �ࠢ��� firewall
netsh advfirewall firewall add rule name="console_test_fr_drv_ng_allow" program="%FULL_EXE_PATH%" protocol=udp dir=in enable=yes action=allow profile=private,public
netsh advfirewall firewall add rule name="console_test_fr_drv_ng_allow" program="%FULL_EXE_PATH%" protocol=tcp dir=in enable=yes action=allow profile=private,public

:research2
echo ��� ����������� ��� � �� � �� COM �����...
console_test_fr_drv_ng discover > tmp
for /f %%i in ("tmp") do set TMP_SIZE=%%~zi
if %TMP_SIZE% EQU 0 echo �� 㤠���� �����㦨�� ���ன�⢮ ��᫥ ����������. ��������, �� ���� ����㧨���� � ������ Enter ��� ����� ���᪠. && pause && goto research2

<tmp (for /f "tokens=1* delims=[]" %%a in ('find /n /v ""') do set "s%%a=%%b")
echo -------------------------------------------------------------------------------------------------------
echo [1]  -  "%s1%"
echo [2]  -  "%s2%"
echo [3]  -  "%s3%"
echo [4]  -  "%s4%"
echo [5]  -  "%s5%"
echo [6]  -  "%s6%"
echo [7]  -  "%s7%"
echo [8]  -  "%s8%"
echo [9]  -  "%s9%"
echo [10] -  "%s10%"
echo -------------------------------------------------------------------------------------------------------

:choiseKKT2
Set /p choice="�롥�� ���, � ���ன �㤥� �����������, �� ᯨ᪠ ��� � ������ Enter: "
if "%choice%"=="1" set "FR_DRV_NG_CT_URL=%s1%"
if "%choice%"=="2" set "FR_DRV_NG_CT_URL=%s2%"
if "%choice%"=="3" set "FR_DRV_NG_CT_URL=%s3%"
if "%choice%"=="4" set "FR_DRV_NG_CT_URL=%s4%"
if "%choice%"=="5" set "FR_DRV_NG_CT_URL=%s5%"
if "%choice%"=="6" set "FR_DRV_NG_CT_URL=%s6%"
if "%choice%"=="7" set "FR_DRV_NG_CT_URL=%s7%"
if "%choice%"=="8" set "FR_DRV_NG_CT_URL=%s8%"
if "%choice%"=="9" set "FR_DRV_NG_CT_URL=%s9%"
if "%choice%"=="10" set "FR_DRV_NG_CT_URL=%s10%"

if "%FR_DRV_NG_CT_URL%"=="" echo �� ��ࠫ� ���⮥ ���祭��! && goto choiseKKT2

rem for /F "usebackq tokens=*" %%A in ("tmp") do (
rem set "FR_DRV_NG_CT_URL=%%A"
rem call :nextkkt
rem )
rem goto continue
rem echo ������� ��� ��᫥ ����������: "%FR_DRV_NG_CT_URL%"

rem :nextkkt
echo ������ ᮥ�������� � "%FR_DRV_NG_CT_URL%"
console_test_fr_drv_ng model>NUL
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo ���ன�⢮ �����㦥��!

echo �믮���� �审�㫥���...
console_test_fr_drv_ng tech-reset
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo ��⮢�!

echo ��⠭������� ⥪�騥 ����-�६�...
console_test_fr_drv_ng setcurrentdatetime
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo ��⮢�!

echo ������ �����᪮� ����� �����㦥����� ���ன�⢠...
console_test_fr_drv_ng read 18.1.1>tmp
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
set /P NEW_SERIAL=<tmp
echo %SERIAL%
echo %NEW_SERIAL%
if not "%SERIAL%" == "%NEW_SERIAL%" echo �����᪮� ����� �� ᮢ������ � �������� && goto :warning
if "%FR_DRV_NG_CT_PASSWORD%" == "" set "FR_DRV_NG_CT_PASSWORD=30"
echo ����⠭������� ⠡����...
type %SAVE_TABLES_PATH% | console_test_fr_drv_ng restore-tables
rem IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo ��⮢�! ������� ����⠭������...

echo ��� 䠩� ��業���...
if not exist licenses.slf echo ���� ��業��� licenses.slf �� ������ && echo ��१���㦠� ���... && console_test_fr_drv_ng reboot && goto warningFileLIC_NO
findstr /B %SERIAL% licenses.slf > tmp
for /f %%i in ("tmp") do set TMP_SIZE=%%~zi
if %TMP_SIZE% EQU 0 echo ��業��� ��� %NEW_SERIAL% �� �����㦥�� && echo ��१���㦠� ���... && console_test_fr_drv_ng reboot && goto warningLIC_FOR_KKT_NO
set /P LICENSE_STRING=<tmp
set LICENSE=
set CRYPTO_SIGNATURE=
for /F "tokens=1,2,3" %%A in ("%LICENSE_STRING%") DO (
	echo %%B>tmp
	set /P LICENSE=<tmp
	echo %%C>tmp
	set /P CRYPTO_SIGNATURE=<tmp
)
echo ��⠭������� �㭪樮����� ��業���...
console_test_fr_drv_ng write-feature-licenses %LICENSE% %CRYPTO_SIGNATURE%
IF %ERRORLEVEL% NEQ 0 echo ��१���㦠� ���... && console_test_fr_drv_ng reboot && goto theEnd
echo ��⮢�! �㭪樮����� ��業��� ��⠭������...

rem �᫨ ����室��� ������� ���� ��ࠬ����, � �㦭� �ய���� �� � ⠡��� newparam � �᪮�����஢��� ��� ��ப� ����
rem echo �����뢠�� ���� ��ࠬ���� ���...
rem type C:\shtrih_dfu_update\regional17 | console_test_fr_drv_ng restore-tables

echo ��१���㦠� ���...
console_test_fr_drv_ng reboot
IF %ERRORLEVEL% NEQ 0 exit /b 1
:theEnd
echo ��⮢�! ���������� �����襭�!
del /f tmp
del /f tables_backup
del /f fr_drv.log
PAUSE
EXIT

:warningFileLIC_NO
echo �㭪樮����� ���業��� �� ��⠭������! �� �����-� ��稭� 䠩� ��業��� ������⢮���! ��⠭���� ��業��� ������!
echo ��⮢�! ���������� �����襭�!
del /f tmp
del /f tables_backup
del /f fr_drv.log
PAUSE
EXIT

:warningLIC_FOR_KKT_NO
echo �㭪樮����� ���業��� �� ��⠭������! �� �����-� ��稭� ��業��� ��� ������ ��� ��������� � �।��⠢������ 䠩��! ��⠭���� ��業��� ������!
echo ��⮢�! ���������� �����襭�!
del /f tmp
del /f tables_backup
del /f fr_drv.log
PAUSE
EXIT

:warning
echo ��-� ��諮 �� ⠪!
echo ������� �� ����⠭������! ����� ��ᬮ���� �� ᮤ�ন��� � 䠩�� tables_backup.
echo ����⠭���� ⠡���� ������!
echo ��業��� �� ��⠭������! ��⠭���� ������!
del /f tmp
del /f fr_drv.log
PAUSE
EXIT