@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

set "APP_NAME=Secret prozhenka 1.5.1"
title %APP_NAME%

:: Проверка прав администратора
if "%1"=="admin" (
    echo Запущено с правами администратора
) else (
    echo Запрос прав администратора...
    powershell -Command "Start-Process '%~f0' -ArgumentList 'admin' -Verb RunAs"
    exit
)

cd /d "%~dp0"

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "M_GREEN=!ESC![32m"
set "M_RED=!ESC![31m"
set "M_RESET=!ESC![0m"

:menu1
cls
set "menu_choice="
set "CURRENT_STRATEGY=!M_RED!Отключена!M_RESET!"

:: Проверка службы и процесса
sc query "zapret" 2>nul | findstr /i "RUNNING" >nul
if !errorlevel!==0 (
    tasklist /FI "IMAGENAME eq winws.exe" 2>nul | find /I "winws.exe" >nul
    if !errorlevel!==0 (
        set "CURRENT_STRATEGY=!M_GREEN!Включена!M_RESET!"
        
        if not "!ZAPRET_ACTIVE_VAR!"=="" (
            set "CURRENT_STRATEGY=!M_GREEN!Вариант №!ZAPRET_ACTIVE_VAR!!M_RESET!"
        )
    )
)

echo.
echo   %APP_NAME%
echo   Выбранная стратегия: !CURRENT_STRATEGY!
echo ---------------------------------------------------------------------------------------------------------------
echo           Помните, что ни один способ не вечен — провайдеры меняют настройки, и рабочая стратегия может сломаться.
echo     Кроме того, та или иная стратегия может запускать Discord или Youtube, но блокировать другие сайты или приложения.
echo                        Экспериментируйте с вариантами, пока не найдёте тот, который стабилен у вас.
echo ---------------------------------------------------------------------------------------------------------------
echo.
echo             ::СТРАТЕГИИ
echo             1. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 1)
echo             2. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 2)
echo             3. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 3)
echo             4. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 4)
echo             5. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 5)
echo.
echo             ::СЕРВИСНЫЕ КОМАНДЫ
echo             6. Очистить кэш Discord (Может помочь при проблемах)
echo             7. Проверить состояние служб zapret и WinDivert
echo             8. Запустить диагностику
echo             9. Остановить и удалить службы zapret и WinDivert
echo             ------------------------------------------------------------------------
echo             0. Выход
echo.

set /p "menu_choice=Введите нужную цифру и нажмите Enter (0-9): "

if "!menu_choice!"=="1" goto 1
if "!menu_choice!"=="2" goto 2
if "!menu_choice!"=="3" goto 3
if "!menu_choice!"=="4" goto 4
if "!menu_choice!"=="5" goto 5
if "!menu_choice!"=="6" goto clear_discord
if "!menu_choice!"=="7" goto check_services
if "!menu_choice!"=="8" goto diagnostics
if "!menu_choice!"=="9" goto remove
if "!menu_choice!"=="0" exit /b

goto :menu1

:: Сервисная команда 9: Удаление служб
:remove
cls
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_GREEN=!ESC![32m"
set "C_RED=!ESC![31m"
set "C_YELLOW=!ESC![33m"
set "C_RESET=!ESC![0m"

set "SRVCNAME=zapret"
echo ===================================================
echo [ПРОЦЕСС] Остановка и удаление компонентов обхода...
echo ===================================================
echo.

set "has_anything=0"
sc query "!SRVCNAME!" >nul 2>&1
if !errorlevel!==0 set "has_anything=1"
sc query "WinDivert" >nul 2>&1
if !errorlevel!==0 set "has_anything=1"
tasklist /FI "IMAGENAME eq winws.exe" 2>nul | find /I "winws.exe" > nul
if !errorlevel!==0 set "has_anything=1"

if !has_anything!==0 (
    echo !C_GREEN!Компоненты обхода отсутствуют в системе, удаление не требуется.!C_RESET!
    goto :remove_end
)

:: 1/3. Остановка службы zapret
sc query "!SRVCNAME!" >nul 2>&1
if !errorlevel!==0 (
    echo !C_YELLOW![1/3] Останавливаем службу !SRVCNAME!...!C_RESET!
    net stop "!SRVCNAME!" >nul 2>&1
    timeout /t 1 >nul 2>&1
    sc delete "!SRVCNAME!" >nul 2>&1
    echo !C_GREEN![УСПЕХ] Служба !SRVCNAME! успешно удалена.!C_RESET!
) else (
    echo [ИНФО] Служба !SRVCNAME! не была установлена.
)
echo.

:: 2/3. Проверка и закрытие процессов winws.exe
tasklist /FI "IMAGENAME eq winws.exe" 2>nul | find /I "winws.exe" > nul
if !errorlevel!==0 (
    echo !C_YELLOW![2/3] Закрываем активные процессы winws.exe...!C_RESET!
    taskkill /IM winws.exe /F > nul 2>&1
    echo !C_GREEN![УСПЕХ] Все процессы winws.exe успешно закрыты.!C_RESET!
) else (
    echo !C_GREEN![2/3] [ИНФО] Процессы winws.exe уже завершены службой.!C_RESET!
)
echo.

:: 3/3. Удаление драйвера WinDivert
sc query "WinDivert" >nul 2>&1
if !errorlevel!==0 (
    echo !C_YELLOW![3/3] Останавливаем драйвер WinDivert...!C_RESET!
    net stop "WinDivert" >nul 2>&1
    timeout /t 1 >nul 2>&1
    sc delete "WinDivert" >nul 2>&1
    echo !C_GREEN![УСПЕХ] Драйвер WinDivert успешно удален.!C_RESET!
) else (
    echo [ИНФО] Драйвер WinDivert не был запущен.
)

echo.
echo !C_GREEN!===================================================!C_RESET!
echo !C_GREEN![УСПЕХ] Все службы и процессы очищены!!C_RESET!
echo !C_GREEN!===================================================!C_RESET!

REG DELETE "HKCU\Environment" /V ZAPRET_ACTIVE_VAR /F >nul 2>&1
set "ZAPRET_ACTIVE_VAR="

:remove_end
echo.
echo Нажмите любую клавишу для возврата в главное меню...
pause > nul
goto menu1

:: Сервисная команда 8: Диагностика
:diagnostics
cls
chcp 65001 >nul

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_GREEN=!ESC![32m"
set "C_RED=!ESC![31m"
set "C_YELLOW=!ESC![33m"
set "C_RESET=!ESC![0m"

echo ===================================================
echo [ПРОЦЕСС] Запуск встроенной диагностики конфликтов...
echo ===================================================
echo.

:: Проверка Adguard
set "RES_ADGUARD=!C_GREEN!Adguard проверка пройдена.!C_RESET!"
tasklist /FI "IMAGENAME eq AdguardSvc.exe" 2>nul | find /I "AdguardSvc.exe" > nul
if !errorlevel!==0 set "RES_ADGUARD=!C_RED![X] Найден процесс Adguard. Adguard может вызывать проблемы с Discord.!C_RESET!"
echo !RES_ADGUARD!
echo:

:: Проверка служб Killer
set "RES_KILLER=!C_GREEN!Killer проверка пройдена.!C_RESET!"
tasklist /FI "IMAGENAME eq KillerService.exe" 2>nul | find /I "KillerService.exe" > nul
if !errorlevel!==0 set "RES_KILLER=!C_RED![X] Найден процесс Killer Network. Он жестко конфликтует с zapret.!C_RESET!"
echo !RES_KILLER!
echo:

:: Проверка Intel Connectivity Network Service
set "RES_INTEL=!C_GREEN!Intel Connectivity проверка пройдена.!C_RESET!"
tasklist /FI "IMAGENAME eq IntelConnectivityNetworkService.exe" 2>nul | find /I "IntelConnectivityNetworkService.exe" > nul
if !errorlevel!==0 set "RES_INTEL=!C_RED![X] Найден процесс Intel Connectivity Network. Конфликтует с zapret.!C_RESET!"
echo !RES_INTEL!
echo:

:: Проверка Check Point
set "RES_CHECKPOINT=!C_GREEN!Check Point проверка пройдена.!C_RESET!"
tasklist /FI "IMAGENAME eq TracSrvWrapper.exe" 2>nul | find /I "TracSrvWrapper.exe" > nul
if !errorlevel!==0 set "RES_CHECKPOINT=!C_RED![X] Найден Check Point VPN. Конфликт с zapret. Рекомендуется удалить.!C_RESET!"
echo !RES_CHECKPOINT!
echo:

:: Проверка SmartByte
set "RES_SMARTBYTE=!C_GREEN!SmartByte проверка пройдена.!C_RESET!"
tasklist /FI "IMAGENAME eq SmartByteNetworkService.exe" 2>nul | find /I "SmartByteNetworkService.exe" > nul
if !errorlevel!==0 set "RES_SMARTBYTE=!C_RED![X] Найдена служба SmartByte. Она блокирует работу zapret. Удалите её.!C_RESET!"
echo !RES_SMARTBYTE!
echo:

:: Проверка VPN служб и программ обхода
set "RES_VPN=!C_GREEN!VPN проверка пройдена.!C_RESET!"

tasklist /FI "IMAGENAME eq goodbye_dpi.exe" 2>nul | find /I "goodbye_dpi.exe" > nul
if !errorlevel!==0 set "RES_VPN=!C_RED![X] Запущен GoodbyeDPI. Он будет полностью блокировать работу zapret! Закройте его.!C_RESET!"

tasklist /FI "IMAGENAME eq AmneziaVPN.exe" 2>nul | find /I "AmneziaVPN.exe" > nul
if !errorlevel!==0 set "RES_VPN=!C_YELLOW![?] Запущена Amnezia VPN. Отключите её перед использованием zapret.!C_RESET!"

tasklist /FI "IMAGENAME eq Outline.exe" 2>nul | find /I "Outline.exe" > nul
if !errorlevel!==0 set "RES_VPN=!C_YELLOW![?] Запущен Outline VPN. Отключите его перед использованием zapret.!C_RESET!"

tasklist /FI "IMAGENAME eq WireGuard.exe" 2>nul | find /I "WireGuard.exe" > nul
if !errorlevel!==0 set "RES_VPN=!C_YELLOW![?] Запущен WireGuard. Он может перехватывать трафик у zapret.!C_RESET!"

tasklist /FI "IMAGENAME eq v2ray.exe" 2>nul | find /I "v2ray.exe" > nul
if !errorlevel!==0 set "RES_VPN=!C_YELLOW![?] Запущен движок V2Ray/Xray (NekoBox/v2rayN). Возможен конфликт.!C_RESET!"

if "!RES_VPN!"=="!C_GREEN!VPN проверка пройдена.!C_RESET!" (
    sc query type= service state= all 2>nul | findstr /I "VPN WireGuard Windscribe NordVPN Proton" > nul
    if !errorlevel!==0 set "RES_VPN=!C_YELLOW![?] Найдены установленные службы VPN. Убедитесь, что ваш VPN полностью отключен.!C_RESET!"
)
echo !RES_VPN!
echo:

:: Проверка DNS / DoH
set "RES_DNS=!C_GREEN!DNS проверка пройдена (Сторонний DNS или DoH active).!C_RESET!"
reg query "HKLM\System\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters" /s 2>nul | findstr /i "DohFlags" >nul
if !errorlevel! NEQ 0 (
    set "RES_DNS=!C_YELLOW![?] DNS-серверы, вероятно, не указаны. Используются DNS провайдера, что может мешать zapret. Рекомендуется настроить сторонние DNS и DoH.!C_RESET!"
)
echo !RES_DNS!

echo.
echo ===================================================
echo Диагностика системы завершена.
echo ===================================================
echo.
echo Нажмите любую клавишу для возврата в главное меню...
pause > nul
goto menu1

:: Сервисная команда 7: Проверка состояния служб
:check_services
cls

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_GREEN=!ESC![32m"
set "C_RED=!ESC![31m"
set "C_RESET=!ESC![0m"

echo ===================================================
echo [ПРОЦЕСС] Проверка состояния служб и процессов...
echo ===================================================
echo.

set "STATUS_ZAPRET=!C_RED!НЕ ЗАПУЩЕНА.!C_RESET!"
set "STATUS_DIVERT=!C_RED!НЕ ЗАПУЩЕНА.!C_RESET!"
set "STATUS_WINWS=!C_RED!НЕ ЗАПУЩЕН.!C_RESET!"

:: Проверка службы zapret
sc query "zapret" 2>nul | findstr /i "RUNNING" >nul
if !errorlevel!==0 set "STATUS_ZAPRET=!C_GREEN!ЗАПУЩЕНА.!C_RESET!"

:: Проверка драйвера WinDivert
sc query "WinDivert" 2>nul | findstr /i "RUNNING" >nul
if !errorlevel!==0 set "STATUS_DIVERT=!C_GREEN!ЗАПУЩЕНА.!C_RESET!"

:: Проверка процесса winws.exe
tasklist /FI "IMAGENAME eq winws.exe" 2>nul | find /I "winws.exe" >nul
if !errorlevel!==0 set "STATUS_WINWS=!C_GREEN!ЗАПУЩЕН.!C_RESET!"

echo Служба "zapret"    -- !STATUS_ZAPRET!
echo Служба "WinDivert" -- !STATUS_DIVERT!
echo.
echo Процесс обхода (winws.exe) -- !STATUS_WINWS!

echo.
echo ===================================================
echo Проверка состояния завершена.
echo ===================================================
echo.
echo Нажмите любую клавишу для возврата в главное меню...
pause > nul

goto menu1

:: Сервисная команда 6: Очистка кэша Discord
:clear_discord
cls
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_GREEN=!ESC![32m"
set "C_RED=!ESC![31m"
set "C_YELLOW=!ESC![33m"
set "C_RESET=!ESC![0m"

echo ===================================================
echo [ПРОЦЕСС] Очистка кэша приложения Discord...
echo ===================================================

tasklist /FI "IMAGENAME eq Discord.exe" | findstr /I "Discord.exe" > nul
if !errorlevel!==0 (
    echo !C_YELLOW!Discord запущен, закрываем процесс...!C_RESET!
    taskkill /IM Discord.exe /F > nul 2>&1
    timeout /t 1 >nul 2>&1
)

set "discordCacheDir=%appdata%\discord"
set "deleted_count=0"

for %%d in ("Cache" "Code Cache" "GPUCache") do (
    set "dirPath=!discordCacheDir!\%%~d"
    if exist "!dirPath!" (
        rd /s /q "!dirPath!" 2>nul
        if not exist "!dirPath!" (
            echo !C_GREEN!Успешно удалено: %%~d!C_RESET!
            set /a deleted_count+=1
        ) else (
            echo !C_RED!Не удалось удалить: %%~d!C_RESET!
        )
    )
)

echo.
if !deleted_count! gtr 0 (
    echo !C_GREEN!===================================================!C_RESET!
    echo !C_GREEN![УСПЕХ] Кэш Discord успешно очищен!!C_RESET!
    echo !C_GREEN!===================================================!C_RESET!
) else (
    echo !C_GREEN!Кэш Discord уже пуст, удаление не требуется.!C_RESET!
)

echo.
echo Нажмите любую клавишу для возврата в главное меню...
pause > nul
goto menu1

:: Блок стратегий
:: Стратегия 5
:5
set "VAR_NUM=5"
set "BIN=%~dp0bin"
set "LISTS=%~dp0list"
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-fake-stun="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%\list-google.txt" --ip-id=zero --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=80,443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin" --new ^
--filter-udp=443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-tcp=80,443,8443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin"
goto run_strategy

:: Стратегия 4
:4
set "VAR_NUM=4"
set "BIN=%~dp0bin"
set "LISTS=%~dp0list"
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-fake-stun="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%\list-google.txt" --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=80,443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=664 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="%BIN%\tls_clienthello_max_ru.bin" --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_max_ru.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin" --new ^
--filter-udp=443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-tcp=80,443,8443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=664 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="%BIN%\tls_clienthello_max_ru.bin" --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_max_ru.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin"
goto run_strategy

:: Стратегия 3
:3
set "VAR_NUM=3"
set "BIN=%~dp0bin"
set "LISTS=%~dp0list"
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-fake-stun="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-tls-mod=none --new ^
--filter-tcp=443 --hostlist="%LISTS%\list-google.txt" --ip-id=zero --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=80,443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_4pda_to.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin" --new ^
--filter-udp=443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-tcp=80,443,8443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_4pda_to.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin"
goto run_strategy

:: Стратегия 2
:2
set "VAR_NUM=2"
set "BIN=%~dp0bin"
set "LISTS=%~dp0list"
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-fake-stun="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%\list-google.txt" --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=80,443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin" --new ^
--filter-udp=443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-tcp=80,443,8443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin"
goto run_strategy

:: Стратегия 1
:1
set "VAR_NUM=1"
set "BIN=%~dp0bin"
set "LISTS=%~dp0list"
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-fake-stun="%BIN%\quic_initial_dbankcloud_ru.bin" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%\list-google.txt" --ip-id=zero --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=80,443 --hostlist="%LISTS%\list.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin" --new ^
--filter-udp=443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%\quic_initial_www_google_com.bin" --new ^
--filter-tcp=80,443,8443 --ipset="%LISTS%\ipset.txt" --hostlist-exclude="%LISTS%\list-exclude.txt" --ipset-exclude="%LISTS%\ipset-exclude.txt" --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls="%BIN%\stun.bin" --dpi-desync-fake-tls="%BIN%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-http="%BIN%\tls_clienthello_max_ru.bin"
goto run_strategy

::Запуск службы
:run_strategy
cls
call :tcp_enable

set "SRVCNAME=zapret"
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=!ESC![32m"
set "RED=!ESC![31m"
set "RESET=!ESC![0m"

echo ===================================================
echo [ПРОЦЕСС] Удаление предыдущей стратегии...
echo ===================================================
net stop "%SRVCNAME%" >nul 2>&1
timeout /t 1 >nul 2>&1
sc delete "%SRVCNAME%" >nul 2>&1
net stop "WinDivert" >nul 2>&1
timeout /t 1 >nul 2>&1
sc delete "WinDivert" >nul 2>&1
timeout /t 1 >nul

cls
echo ===================================================
echo [ПРОЦЕСС] Настройка автозапуска стратегии...
echo ===================================================

set "SC_ARGS=!ARGS:"=\"!"

sc create "%SRVCNAME%" binPath= "\"%BIN%\winws.exe\" !SC_ARGS!" DisplayName= "zapret DPI bypass : winws1" start= auto >nul
sc description "%SRVCNAME%" "zapret DPI bypass software" >nul

reg add "HKCU\Environment" /v ZAPRET_ACTIVE_VAR /t REG_SZ /d "%VAR_NUM%" /f >nul 2>&1
set "ZAPRET_ACTIVE_VAR=%VAR_NUM%"

echo СТАТУС ЗАПУСКА СЛУЖБЫ Windows:
echo ------------------------------------------------===
sc start "%SRVCNAME%"
echo ------------------------------------------------===

timeout /t 2 >nul

sc query "%SRVCNAME%" | findstr /i "RUNNING" >nul
if !errorlevel!==0 (
    echo.
    echo !GREEN!===================================================!RESET!
    echo !GREEN![УСПЕХ] Вариант №%VAR_NUM% успешно добавлен в автозапуск!!RESET!
    echo !GREEN!===================================================!RESET!
) else (
    echo.
    echo !RED!===================================================!RESET!
    echo !RED![ОШИБКА] Не удалось запустить службу автоматической стратегии.!RESET!
    echo !RED!===================================================!RESET!
)

echo.
echo Нажмите любую клавишу для возврата в главное меню...
pause > nul
goto menu1

:: Таймштамп
:tcp_enable
netsh interface tcp show global | findstr /i "timestamps" | findstr /i "enabled" > nul || netsh interface tcp set global timestamps=enabled > nul 2>&1
exit /b
