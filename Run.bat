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
cls
echo Секретная проженька 1.1
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
Echo             4. Установить обход блокировки только Discord
Echo             ------------------------------------------------------------------------
Echo             Сервисные команды:
Echo             5. Проверить состояние служб zapret и WinDivert
Echo             6. Запустить диагностику
Echo             7. Остановить и удалить службы zapret и WinDivert
Echo             8. Выход
Echo             ------------------------------------------------------------------------

choice /C 12345678 /M "Введите цифру"

If errorlevel 8 goto :end
If errorlevel 7 goto :7
If errorlevel 6 goto :6
If errorlevel 5 goto :5
If errorlevel 4 goto :4
If errorlevel 3 goto :3 
If errorlevel 2 goto :2
If errorlevel 1 goto :1

goto :eof

:7
cls
call "%~dp0bat\remove.bat
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

:4
cls
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8

call "%~dp0bat\remove.bat

set SRVCNAME=zapret

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:3
cls
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8 --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8

call "%~dp0bat\remove.bat

set SRVCNAME=zapret

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:2
cls
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=\"%~dp0bin\tls_clienthello_www_google_com.bin\" --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=multisplit --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin"

call "%~dp0bat\remove.bat

set SRVCNAME=zapret

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:1
cls
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=8 --dpi-desync-fooling=md5sig,badseq --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --ipset=\"%~dp0list\ipset.txt\" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=6 --dpi-desync-fooling=md5sig,badseq

call "%~dp0bat\remove.bat

set SRVCNAME=zapret

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

pause
goto menu1

:end
echo СПАСИБО ЗА ПОЛЬЗОВАНИЕ СЕРВИСАМИ ЖЕНЁК-ФИНАНС ХЕВИ МАЙНИНГ ИНДАСТРИЗ.
TIMEOUT /T 3 /NOBREAK
Exit
