@echo off
cls
setlocal EnableDelayedExpansion
rem Пример скрипта обновления ФР по DFU и записью функциональных лицензий
rem В пути к рабочей директории не должно быть пробелов и других спец символов.
rem Например, можно положить скрипт в C:\shtrih_dfu_update
rem Директория должна быть доступна на запись(будут сохраняться временные файлы)
rem рядом со скриптом необходимо положить dfu-util.exe и console_test_fr_drv_ng.exe, и файл с функциональными лицензиями под именем licenses.slf
title Обновление ККТ через режим dfu
echo Начинаю процесс обновления ККТ через режим dfu
rem если раскомментировать следующую строку - отладка будет в консоли, иначе в файле fr_drv.log в рабочей директории
rem set /A FR_DRV_DEBUG_CONSOLE=1
rem Имя файла резервной копии таблиц
set SAVE_TABLES_PATH=tables_backup

cd /d %~dp0
echo %cd%>tmp
set /P PWD=<tmp
rem путь до исполняемого файла консольного теста, подразумевается что он находится в рабочей директории
set "FULL_EXE_PATH=%PWD%\console_test_fr_drv_ng.exe"

:research1
echo Ищу ККТ...
console_test_fr_drv_ng discover > tmp

for /f %%i in ("tmp") do set TMP_SIZE=%%~zi
if %TMP_SIZE% EQU 0 echo Не удалось обнаружить устройство. Проверьте соединение с ККТ и нажмите Enter для повторного поиска. && pause && goto research1

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
echo [11] -  Повторить поиск
echo [12] -  Выход
echo -------------------------------------------------------------------------------------------------------


Set /p choice=Выберите ККТ, к которой будем подключаться, из списка выше и нажмите Enter: 
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

if "%FR_DRV_NG_CT_URL%"=="" echo Вы выбрали пустое значение! && goto choiseKKT1

rem пароль сист. администратора ККТ, по умолчанию 30
rem если при старте скрипта в окружени нет FR_DRV_NG_CT_PASSWORD используется стандартный, иначе из окружения
if "%FR_DRV_NG_CT_PASSWORD%" == "" set "FR_DRV_NG_CT_PASSWORD=30"
echo.
echo Адрес ККТ: "%FR_DRV_NG_CT_URL%"
echo Пароль ККТ: "%FR_DRV_NG_CT_PASSWORD%"
echo.
echo ---------------------------------------
echo [1]  -  Перейти к выбору прошивки
echo [2]  -  Вернуться к выбору подключения
echo [3]  -  Вернуться к поиску
echo [4]  -  Выход
echo ---------------------------------------
Set /p choice=Выберите соответсвующий пункт меню для продолжения и нажмите Enter: 
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
echo [6]  -  Выход
echo ---------------------------------------
Set /p choice=Выберите прошивку для продолжения и нажмите Enter: 
if "%choice%"=="1" set "FIRM_VERSION=13.02.2020"
if "%choice%"=="2" set "FIRM_VERSION=07.05.2020"
if "%choice%"=="3" set "FIRM_VERSION=22.12.2020"
if "%choice%"=="4" set "FIRM_VERSION=23.04.2021"
if "%choice%"=="5" set "FIRM_VERSION=19.07.2021ffd1.2"
if "%choice%"=="6" goto theEnd

:GoUpd
console_test_fr_drv_ng z-report
echo Таблицы будут сохранены в файл %SAVE_TABLES_PATH%
echo Получаю статус ККТ...
console_test_fr_drv_ng status>NUL
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
echo Ок!
echo Получаю заводской номер...
console_test_fr_drv_ng read 18.1.1>tmp
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
set /P SERIAL=<tmp
echo Заводской номер: %SERIAL%
echo Получаю UIN...
console_test_fr_drv_ng read 23.1.11>tmp
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
set /P UIN=<tmp
echo UIN: %UIN%
set FIRMWARE_FILENAME=firmware\%FIRM_VERSION%\upd_app.bin
IF "%UIN%"=="---" (
   echo UIN отсутствует
   set FIRMWARE_FILENAME=firmware\%FIRM_VERSION%\upd_app_for_old_frs.bin
)
echo Для обновления будет взят: "%FIRMWARE_FILENAME%"
echo Сохраняю таблицы...
console_test_fr_drv_ng save-tables > %SAVE_TABLES_PATH%
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
echo Готово!

echo Перезагружаю ККТ в режим dfu...
console_test_fr_drv_ng reboot-dfu
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
rem перешли в режим DFU, ждём 3 секунды и запускаем dfu-util, она сама найдет устройство и установит прошивку, нужно только передать имя файла
timeout /t 3 /nobreak > NUL
echo|set /p= Запускаю обновление по DFU...
dfu-util -D %FIRMWARE_FILENAME%
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
echo Готово!
echo Подождите 15 секунд... ККТ перезагружается...

rem спим 15 секунд, ждём появления устройства в системе после обновления
timeout /t 15 /nobreak > NUL
rem удаляем наши правила файерволла, этот шаг нужен потому что при изменении пути к исполняемому файлу перестают работать и правила. Поэтому каждый раз удаляем старые правила и добавляем новые.
netsh advfirewall firewall del rule name="console_test_fr_drv_ng_allow"
echo Добавляю правила firewall
netsh advfirewall firewall add rule name="console_test_fr_drv_ng_allow" program="%FULL_EXE_PATH%" protocol=udp dir=in enable=yes action=allow profile=private,public
netsh advfirewall firewall add rule name="console_test_fr_drv_ng_allow" program="%FULL_EXE_PATH%" protocol=tcp dir=in enable=yes action=allow profile=private,public

:research2
echo Ищу обновленную ККТ в сети и на COM портах...
console_test_fr_drv_ng discover > tmp
for /f %%i in ("tmp") do set TMP_SIZE=%%~zi
if %TMP_SIZE% EQU 0 echo Не удалось обнаружить устройство после обновления. Убедитесь, что касса загрузилась и нажмите Enter для повтора поиска. && pause && goto research2

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
Set /p choice="Выберите ККТ, к которой будем подключаться, из списка выше и нажмите Enter: "
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

if "%FR_DRV_NG_CT_URL%"=="" echo Вы выбрали пустое значение! && goto choiseKKT2

rem for /F "usebackq tokens=*" %%A in ("tmp") do (
rem set "FR_DRV_NG_CT_URL=%%A"
rem call :nextkkt
rem )
rem goto continue
rem echo Найдена ККТ после обновления: "%FR_DRV_NG_CT_URL%"

rem :nextkkt
echo Пытаюсь соединиться с "%FR_DRV_NG_CT_URL%"
console_test_fr_drv_ng model>NUL
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo Устройство обнаружено!

echo Выполняю техобнуление...
console_test_fr_drv_ng tech-reset
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo Готово!

echo Устанавливаю текущие дату-время...
console_test_fr_drv_ng setcurrentdatetime
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo Готово!

echo Получаю заводской номер обнаруженного устройства...
console_test_fr_drv_ng read 18.1.1>tmp
IF %ERRORLEVEL% NEQ 0 GOTO:EOF
set /P NEW_SERIAL=<tmp
echo %SERIAL%
echo %NEW_SERIAL%
if not "%SERIAL%" == "%NEW_SERIAL%" echo Заводской номер не совпадает с ожидаемым && goto :warning
if "%FR_DRV_NG_CT_PASSWORD%" == "" set "FR_DRV_NG_CT_PASSWORD=30"
echo Восстанавливаю таблицы...
type %SAVE_TABLES_PATH% | console_test_fr_drv_ng restore-tables
rem IF %ERRORLEVEL% NEQ 0 GOTO:EOF
echo Готово! Таблицы восстановлены...

echo Ищу файл лицензии...
if not exist licenses.slf echo Файл лицензий licenses.slf не найден && echo Перезагружаю ККТ... && console_test_fr_drv_ng reboot && goto warningFileLIC_NO
findstr /B %SERIAL% licenses.slf > tmp
for /f %%i in ("tmp") do set TMP_SIZE=%%~zi
if %TMP_SIZE% EQU 0 echo Лицензия для %NEW_SERIAL% не обнаружена && echo Перезагружаю ККТ... && console_test_fr_drv_ng reboot && goto warningLIC_FOR_KKT_NO
set /P LICENSE_STRING=<tmp
set LICENSE=
set CRYPTO_SIGNATURE=
for /F "tokens=1,2,3" %%A in ("%LICENSE_STRING%") DO (
	echo %%B>tmp
	set /P LICENSE=<tmp
	echo %%C>tmp
	set /P CRYPTO_SIGNATURE=<tmp
)
echo Устанавливаю функциональные лицензии...
console_test_fr_drv_ng write-feature-licenses %LICENSE% %CRYPTO_SIGNATURE%
IF %ERRORLEVEL% NEQ 0 echo Перезагружаю ККТ... && console_test_fr_drv_ng reboot && goto theEnd
echo Готово! Функциональные лицензии установлены...

rem Если необходимо записать новые параметры, то нужно прописать их в таблице newparam и раскомментировать две строки ниже
rem echo Записываем новые параметры ККТ...
rem type C:\shtrih_dfu_update\regional17 | console_test_fr_drv_ng restore-tables

echo Перезагружаю ККТ...
console_test_fr_drv_ng reboot
IF %ERRORLEVEL% NEQ 0 exit /b 1
:theEnd
echo Готово! Обновление завершено!
del /f tmp
del /f tables_backup
del /f fr_drv.log
PAUSE
EXIT

:warningFileLIC_NO
echo Функциональные линцензии не установлены! По какой-то причине файл лицензии отсутствовует! Установите лицензии вручную!
echo Готово! Обновление завершено!
del /f tmp
del /f tables_backup
del /f fr_drv.log
PAUSE
EXIT

:warningLIC_FOR_KKT_NO
echo Функциональные линцензии не установлены! По какой-то причине лицензия для данной ККТ отсутствует в предоставленном файле! Установите лицензии вручную!
echo Готово! Обновление завершено!
del /f tmp
del /f tables_backup
del /f fr_drv.log
PAUSE
EXIT

:warning
echo Что-то пошло не так!
echo Таблицы не восстановлены! Можно просмотреть их содержимое в файле tables_backup.
echo Восстановите таблицы вручную!
echo Лицензии не установлены! Установите вручную!
del /f tmp
del /f fr_drv.log
PAUSE
EXIT