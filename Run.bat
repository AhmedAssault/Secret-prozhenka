@echo off
chcp 65001 > nul
if "%1"=="admin" (
    echo Запущено с правами администратора
) else (
    echo Запрос прав администатора...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

cls
color B0

echo Секретная проженька 1.0.4
echo ЖЕНЁК-ФИНАНС ХЕВИ РАБОТАЙ ДИСКОРДЮТУБ ИНДАСТРИЗ ©
Echo ____________________________________________________________________________________________________________  
Echo             Внимание! Перед установкой новой стратегии или обновлении, не забудьте выполнить удаление!
Echo ____________________________________________________________________________________________________________  

:menu1        
Echo                                 Пожалуйста, выберите необходимое действие
Echo             1. Установить обход блокировки YouTube + Discord на автозапуск (Основоной вариант)
Echo             2. Установить обход блокировки YouTube + Discord на автозапуск (Альтернативный вариант)
Echo             3. Установить обход блокировки Discord
Echo             4. Проверить состояние служб zapret и WinDivert
Echo             5. Остановить и удалить службы zapret и WinDivert
Echo             6. Выход

choice /C 123456 /M "Введите цифру"

If errorlevel 6 goto :end
If errorlevel 5 goto :5
If errorlevel 4 goto :4
If errorlevel 3 goto :3 
If errorlevel 2 goto :2
If errorlevel 1 goto :1

goto :eof

:5
call "%~dp0bat\remove.bat
choice /C YN /M "Завершить работу с программой?"
If errorlevel 2 goto :menu1
If errorlevel 1 goto :end

:4
call "%~dp0bat\check.bat
choice /C YN /M "Завершить работу с программой?"
If errorlevel 2 goto :menu1
If errorlevel 1 goto :end

:3
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-50100 --ipset=\"%~dp0list\ipset-discord.txt\" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8

set SRVCNAME=zapret

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

choice /C YN /M "Завершить работу с программой?"
If errorlevel 2 goto :menu1
If errorlevel 1 goto :end

:2
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-50100 --ipset=\"%~dp0list\ipset-discord.txt\" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8 --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset-cloudflare.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80 --ipset=\"%~dp0list\ipset-cloudflare.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --ipset=\"%~dp0list\ipset-cloudflare.txt\" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8

set SRVCNAME=zapret

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

choice /C YN /M "Завершить работу с программой?"
If errorlevel 2 goto :menu1
If errorlevel 1 goto :end

:1
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-udp=50000-50100 --ipset=\"%~dp0list\ipset-discord.txt\" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0list\list.txt\" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=8 --dpi-desync-fooling=md5sig,badseq --new ^
--filter-udp=443 --ipset=\"%~dp0list\ipset-cloudflare.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%~dp0bin\quic_initial_www_google_com.bin\" --new ^
--filter-tcp=80 --ipset=\"%~dp0list\ipset-cloudflare.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --ipset=\"%~dp0list\ipset-cloudflare.txt\" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=6 --dpi-desync-fooling=md5sig,badseq

set SRVCNAME=zapret

sc create "%SRVCNAME%" binPath= "%~dp0bin\winws.exe %ARGS%" DisplayName= "zapret DPI bypass : winws1" start= auto
sc description "%SRVCNAME%" "zapret DPI bypass software"
sc start "%SRVCNAME%"

choice /C YN /M "Завершить работу с программой?"
If errorlevel 2 goto :menu1
If errorlevel 1 goto :end

:end
echo СПАСИБО ЗА ПОЛЬЗОВАНИЕ СЕРВИСАМИ ЖЕНЁК-ФИНАНС ХЕВИ МАЙНИНГ ИНДАСТРИЗ.
TIMEOUT /T 3 /NOBREAK
Exit

