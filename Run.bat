@echo off
chcp 65001 > nul
if "%1"=="admin" (
    echo Запущено с правами администратора
) else (
    echo Запрос прав администатора...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

setlocal EnableDelayedExpansion

:menu1
chcp 65001 > nul
set "menu_choice=null"
cls
echo Секретная проженька 1.3.0
echo ЖЕНЁК-ФИНАНС ХЕВИ РАБОТАЙ ДИСКОРДЮТУБ ИНДАСТРИЗ
Echo _______________________________________________________________________________________________________________________
Echo                                                        Внимание!
Echo                                Пробуйте разные варианты, пока не подберёте рабочий для вас.
Echo _______________________________________________________________________________________________________________________

Echo                                 Пожалуйста, выберите необходимое действие
Echo             Стратегии:
Echo             1. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 1)
Echo             2. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 2)
Echo             3. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 3)
Echo             4. Установить обход блокировки YouTube+Discord на автозапуск (Вариант 4)
Echo             ------------------------------------------------------------------------
Echo             Сервисные команды:
Echo             5. Проверить состояние служб zapret и WinDivert
Echo             6. Запустить диагностику
Echo             7. Остановить и удалить службы zapret и WinDivert
Echo             8. Выход
Echo             ------------------------------------------------------------------------

set /p menu_choice=Введите нужную цифру и нажмите Enter (1-8):  

if "%menu_choice%"=="1" goto 2
if "%menu_choice%"=="2" goto 2
if "%menu_choice%"=="3" goto 3
if "%menu_choice%"=="4" goto 4
if "%menu_choice%"=="5" goto 5
if "%menu_choice%"=="6" goto 6
if "%menu_choice%"=="7" goto remove
if "%menu_choice%"=="8" goto end

goto :menu1


::Service
:end
cls
echo СПАСИБО ЗА ПОЛЬЗОВАНИЕ СЕРВИСАМИ ЖЕНЁК-ФИНАНС ХЕВИ МАЙНИНГ ИНДАСТРИЗ.
TIMEOUT /T 3 /NOBREAK
exit

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

:6
cls
call "%~dp0bat\check1.bat
pause
goto menu1

:5
cls
call "%~dp0bat\check0.bat
pause
goto menu1


::Strategy
:4
cls
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake --dpi-desync-fake-tls-mod=none --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=fake --dpi-desync-fake-tls-mod=none --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-fake-tls-mod=none --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-fake-tls-mod=none --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=2 

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:3
cls
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\"

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:2
cls
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=multisplit --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=multisplit --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\"

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:1
cls
set ARGS=--wf-tcp=80,443,2053,2083,2087,2096,8443 --wf-udp=443,19294-19344,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list-google.txt\" --ip-id=zero --dpi-desync=multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-tcp=80,443 --hostlist=\"%~dp0list\list.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80,443 --ipset=\"%~dp0list\ipset.txt\" --hostlist-exclude=\"%~dp0list\list-exclude.txt\" --ipset-exclude=\"%~dp0list\ipset-exclude.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=568 --dpi-desync-split-pos=1 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" 

set SRVCNAME=zapret
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1