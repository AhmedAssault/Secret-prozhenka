@echo off
chcp 65001 > nul
if "%1"=="admin" (
    echo Запущено с правами администратора
) else (
    echo Запрос прав администатора...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

:menu1
setlocal EnableDelayedExpansion
chcp 65001 > nul
set "menu_choice=null"
cls
Echo.
Echo Secret prozhenka 1.4.0
Echo.
Echo ---------------------------------------------------------------------------------------------------------------
Echo           Определенная стратегия может работать какое-то время, но со временем она может переставать работать.
Echo                С разными стратегиями могут переставать корректно работать те или иные сайты или приложения.
Echo                            Пробуйте разные варианты, пока не подберёте оптимальный.
Echo ---------------------------------------------------------------------------------------------------------------
Echo.
Echo             ::СТРАТЕГИИ
Echo             1. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 1)
Echo             2. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 2)
Echo             3. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 3)
Echo             4. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 4)
Echo             5. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 5)
Echo.
Echo             ::СЕРВИСНЫЕ КОМАНДЫ
Echo             6. Проверить состояние служб zapret и WinDivert
Echo             7. Запустить диагностику
Echo             8. Остановить и удалить службы zapret и WinDivert
Echo             ------------------------------------------------------------------------
Echo             0. Выход
Echo.
set /p menu_choice=Введите нужную цифру и нажмите Enter (0-8):  

if "%menu_choice%"=="1" goto 1
if "%menu_choice%"=="2" goto 2
if "%menu_choice%"=="3" goto 3
if "%menu_choice%"=="4" goto 4
if "%menu_choice%"=="5" goto 5
if "%menu_choice%"=="6" goto 6
if "%menu_choice%"=="7" goto 7
if "%menu_choice%"=="8" goto remove
if "%menu_choice%"=="0" exit /b

goto :menu1

::Service
:tcp_enable
netsh interface tcp show global | findstr /i "timestamps" | findstr /i "enabled" > nul || netsh interface tcp set global timestamps=enabled > nul 2>&1
exit /b

:remove
cls
set SRVCNAME=zapret
sc query "!SRVCNAME!" >nul 2>&1
if !errorlevel!==0 (
    net stop %SRVCNAME%
    sc delete %SRVCNAME%
) else (
    echo Service "%SRVCNAME%" не установлен.
)

tasklist /FI "IMAGENAME eq winws.exe" | find /I "winws.exe" > nul
if !errorlevel!==0 (
    taskkill /IM winws.exe /F > nul
)

sc query "WinDivert" >nul 2>&1
if !errorlevel!==0 (
    net stop "WinDivert"

    sc query "WinDivert" >nul 2>&1
    if !errorlevel!==0 (
        sc delete "WinDivert"
    )
)
net stop "WinDivert" >nul 2>&1
sc delete "WinDivert" >nul 2>&1

pause
goto menu1

:7
cls
call "%~dp0bat\check1.bat
pause
goto menu1

:6
cls
call "%~dp0bat\check0.bat
pause
goto menu1

::Strategy
:5
cls
call :tcp_enable
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-fake-stun=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443,8443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\"

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
net stop "WinDivert" >nul 2>&1
sc delete "WinDivert" >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:4
cls
call :tcp_enable
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-fake-stun=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=664 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_max_ru.bin\" --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_max_ru.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443,8443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=664 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_max_ru.bin\" --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_max_ru.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\"

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
net stop "WinDivert" >nul 2>&1
sc delete "WinDivert" >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:3
cls
call :tcp_enable
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-fake-stun=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-tls-mod=none --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_4pda_to.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443,8443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_4pda_to.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\"

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
net stop "WinDivert" >nul 2>&1
sc delete "WinDivert" >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:2
cls
call :tcp_enable
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-fake-stun=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443,8443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\"

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
net stop "WinDivert" >nul 2>&1
sc delete "WinDivert" >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:1
cls
call :tcp_enable
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-fake-stun=\"%~dp0bin\quic_initial_dbankcloud_ru.bin\" --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443,8443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake,fakedsplit --dpi-desync-repeats=6 --dpi-desync-fooling=ts --dpi-desync-fakedsplit-pattern=0x00 --dpi-desync-fake-tls=\"%~dp0bin\stun.bin\" --dpi-desync-fake-tls=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --dpi-desync-fake-http=\"%~dp0bin\tls_clienthello_max_ru.bin\"

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
net stop "WinDivert" >nul 2>&1
sc delete "WinDivert" >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1
