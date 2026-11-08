@echo off
setlocal enabledelayedexpansion
set "DIR=%~dp0"
pushd "%DIR%"
set "AUTOIT_DIR=%DIR%AutoIt"
set "ERROR_COUNT=0"
set "TOTAL_FILES=5"
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "RESET=[0m"

taskkill /F /IM adb.exe >nul 2>&1
taskkill /F /IM hd-adb.exe >nul 2>&1

echo !YELLOW!========================================!RESET!
echo !YELLOW! MyBot.run Build Tool!RESET!
echo !YELLOW! Started at %DATE% %TIME%!RESET!
echo !YELLOW!========================================!RESET!
echo.

echo !YELLOW![PHASE 1] Cleanup!RESET!
echo.

echo Force closing running MyBot processes...
call :KillProcess "MyBot.run.Watchdog.exe"
call :KillProcess "MultiBot.exe"
call :KillProcess "MyBot.run.exe"
call :KillProcess "MyBot.run.MiniGui.exe"
call :KillProcess "MyBot.run.Wmi.exe"

rem Give Windows time to release executable handles.
timeout /t 2 /nobreak >nul

rem Second sweep prevents Watchdog or MultiBot from restarting a process during cleanup.
taskkill /F /T /IM "MyBot.run.Watchdog.exe" >nul 2>&1
taskkill /F /T /IM "MultiBot.exe" >nul 2>&1
taskkill /F /T /IM "MyBot.run.exe" >nul 2>&1
taskkill /F /T /IM "MyBot.run.MiniGui.exe" >nul 2>&1
taskkill /F /T /IM "MyBot.run.Wmi.exe" >nul 2>&1
timeout /t 1 /nobreak >nul

echo.
echo Deleting old executables...
call :DeleteExecutable "MyBot.run.exe"
call :DeleteExecutable "MyBot.run.Watchdog.exe"
call :DeleteExecutable "MyBot.run.Wmi.exe"
call :DeleteExecutable "MyBot.run.MiniGui.exe"
call :DeleteExecutable "MultiBot.exe"

echo.
echo !YELLOW![PHASE 2] Syntax Check!RESET!
echo.

echo [1/%TOTAL_FILES%] Checking MyBot.run.au3...
"%AUTOIT_DIR%\Au3Check.exe" "MyBot.run.au3"
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Syntax errors found in MyBot.run.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! No syntax errors in MyBot.run.au3.
)

echo.
echo [2/%TOTAL_FILES%] Checking MyBot.run.Watchdog.au3...
"%AUTOIT_DIR%\Au3Check.exe" "MyBot.run.Watchdog.au3"
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Syntax errors found in MyBot.run.Watchdog.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! No syntax errors in MyBot.run.Watchdog.au3.
)

echo.
echo [3/%TOTAL_FILES%] Checking MyBot.run.Wmi.au3...
"%AUTOIT_DIR%\Au3Check.exe" "MyBot.run.Wmi.au3"
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Syntax errors found in MyBot.run.Wmi.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! No syntax errors in MyBot.run.Wmi.au3.
)

echo.
echo [4/%TOTAL_FILES%] Checking MyBot.run.MiniGui.au3...
"%AUTOIT_DIR%\Au3Check.exe" "MyBot.run.MiniGui.au3"
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Syntax errors found in MyBot.run.MiniGui.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! No syntax errors in MyBot.run.MiniGui.au3.
)

echo.
echo [5/%TOTAL_FILES%] Checking MultiBot.au3...
"%AUTOIT_DIR%\Au3Check.exe" "MultiBot.au3"
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Syntax errors found in MultiBot.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! No syntax errors in MultiBot.au3.
)

echo.
if !ERROR_COUNT! neq 0 (
    echo !RED![FAILURE]!RESET! Syntax check failed. Compilation aborted.
    goto :end
)

echo !GREEN![SUCCESS]!RESET! All files passed syntax check. Proceeding to compilation.
echo.
echo !YELLOW![PHASE 3] Compilation!RESET!
echo.

echo [1/%TOTAL_FILES%] Compiling MyBot.run.au3...
"%AUTOIT_DIR%\Aut2Exe\Aut2exe.exe" /in "MyBot.run.au3" /out "MyBot.run.exe" /comp 4 /pack
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Failed to compile MyBot.run.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! MyBot.run.au3 compiled successfully.
)

echo.
echo [2/%TOTAL_FILES%] Compiling MyBot.run.Watchdog.au3...
"%AUTOIT_DIR%\Aut2Exe\Aut2exe.exe" /in "MyBot.run.Watchdog.au3" /out "MyBot.run.Watchdog.exe" /comp 4 /pack
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Failed to compile MyBot.run.Watchdog.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! MyBot.run.Watchdog.au3 compiled successfully.
)

echo.
echo [3/%TOTAL_FILES%] Compiling MyBot.run.Wmi.au3...
"%AUTOIT_DIR%\Aut2Exe\Aut2exe.exe" /in "MyBot.run.Wmi.au3" /out "MyBot.run.Wmi.exe" /comp 4 /pack
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Failed to compile MyBot.run.Wmi.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! MyBot.run.Wmi.au3 compiled successfully.
)

echo.
echo [4/%TOTAL_FILES%] Compiling MyBot.run.MiniGui.au3...
"%AUTOIT_DIR%\Aut2Exe\Aut2exe.exe" /in "MyBot.run.MiniGui.au3" /out "MyBot.run.MiniGui.exe" /comp 4 /pack
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Failed to compile MyBot.run.MiniGui.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! MyBot.run.MiniGui.au3 compiled successfully.
)

echo.
echo [5/%TOTAL_FILES%] Compiling MultiBot.au3...
"%AUTOIT_DIR%\Aut2Exe\Aut2exe.exe" /in "MultiBot.au3" /out "MultiBot.exe" /comp 4 /pack
if %errorlevel% neq 0 (
    echo !RED![ERROR]!RESET! Failed to compile MultiBot.au3.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! MultiBot.au3 compiled successfully.
)

echo.
echo !YELLOW!========================================!RESET!
if !ERROR_COUNT! equ 0 (
    echo !GREEN![SUCCESS]!RESET! All files compiled successfully
) else (
    echo !RED![FAILURE]!RESET! !ERROR_COUNT! files failed to compile
)
echo !YELLOW! Completed at %DATE% %TIME%!RESET!
echo !YELLOW!========================================!RESET!
goto :end


:KillProcess
set "PROCESS_NAME=%~1"
tasklist /FI "IMAGENAME eq %PROCESS_NAME%" 2>nul | find /I "%PROCESS_NAME%" >nul
if errorlevel 1 (
    echo !YELLOW![INFO]!RESET! %PROCESS_NAME% is not running.
) else (
    taskkill /F /T /IM "%PROCESS_NAME%" >nul 2>&1
    if errorlevel 1 (
        echo !RED![ERROR]!RESET! Could not terminate %PROCESS_NAME%.
        set /a ERROR_COUNT+=1
    ) else (
        echo !GREEN![OK]!RESET! Terminated %PROCESS_NAME%.
    )
)
exit /b

:DeleteExecutable
set "EXECUTABLE=%~1"
if not exist "%EXECUTABLE%" (
    echo !YELLOW![INFO]!RESET! %EXECUTABLE% not found.
    exit /b
)

del /F /Q "%EXECUTABLE%" >nul 2>&1
if exist "%EXECUTABLE%" (
    echo !RED![ERROR]!RESET! Could not delete %EXECUTABLE%. The file is still in use or access was denied.
    set /a ERROR_COUNT+=1
) else (
    echo !GREEN![OK]!RESET! Deleted %EXECUTABLE%.
)
exit /b

:end
pause
