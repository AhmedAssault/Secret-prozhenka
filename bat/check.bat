if "%~1"=="" (
    call :test_service zapret
    call :test_service WinDivert
) else (
    call :test_service "%~1" "soft"
)

exit /b

:test_service
set "ServiceName=%~1"
set "ServiceStatus="

for /f "tokens=3 delims=: " %%A in ('sc query "%ServiceName%" ^| findstr /i "STATE"') do set "ServiceStatus=%%A"

set "ServiceStatus=%ServiceStatus: =%"

if "%ServiceStatus%"=="RUNNING" (
    if "%~2"=="soft" (
        echo "%ServiceName%" is ALREADY RUNNING as service!
        pause
    ) else (
        echo "%ServiceName%" Служба запущена.
    )
) else if not "%~2"=="soft" (
    echo "%ServiceName%" Служба не запущена.
)
exit /b2
