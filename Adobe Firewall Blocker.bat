@echo off
SETLOCAL EnableDelayedExpansion
Title Adobe Firewall Blocker
color 0A

:: ============================================
:: Adobe Firewall Blocker 
:: GitHub: https://github.com/WKVDewantha
:: ============================================

:: Check for administrator privileges
NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo ===============================================
    echo  ADMINISTRATOR PRIVILEGES REQUIRED
    echo ===============================================
    echo.
    echo This script must be run as Administrator.
    echo.
    echo Right-click this file and select:
    echo "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Create log file
set "LOGFILE=%~dp0firewall_block_%DATE:~-4%%DATE:~-10,2%%DATE:~-7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log"
set "LOGFILE=%LOGFILE: =0%"

echo ============================================== > "%LOGFILE%"
echo Adobe Firewall Blocker Log >> "%LOGFILE%"
echo Started: %DATE% %TIME% >> "%LOGFILE%"
echo ============================================== >> "%LOGFILE%"
echo. >> "%LOGFILE%"

:: Display menu
:MENU
cls
echo.
echo ============================================================
echo           Adobe Firewall Blocker - Enhanced Version
echo           GitHub: https://github.com/WKVDewantha
echo ============================================================
echo.
echo  Select an option:
echo.
echo  [1] Block all Adobe applications (Recommended)
echo  [2] Remove existing Adobe firewall rules
echo  [3] Block Adobe (exclude helpers/updaters)
echo  [4] Custom directory scan
echo  [5] Block critical Adobe services (Desktop/CEF/AGM/GC)
echo  [6] Clear Adobe application data (Reset to fresh install)
echo  [7] View log file
echo  [8] Exit
echo.
echo ============================================================
echo.

set /p "choice=Enter your choice (1-8): "

if "%choice%"=="1" goto BLOCK_ALL
if "%choice%"=="2" goto REMOVE_RULES
if "%choice%"=="3" goto BLOCK_EXCLUDE
if "%choice%"=="4" goto CUSTOM_SCAN
if "%choice%"=="5" goto BLOCK_CRITICAL
if "%choice%"=="6" goto CLEAR_DATA
if "%choice%"=="7" goto VIEW_LOG
if "%choice%"=="8" goto EXIT
goto MENU

:: ============================================
:: BLOCK ALL ADOBE APPLICATIONS
:: ============================================
:BLOCK_ALL
cls
echo.
echo ============================================================
echo  Blocking All Adobe Applications
echo ============================================================
echo.
echo Starting scan... Please wait...
echo.

set "BLOCKED_COUNT=0"
set "SKIPPED_COUNT=0"

call :LOG "Starting firewall rule automation for all Adobe applications..."

:: Scan Program Files
if exist "%ProgramFiles%\Adobe" (
    call :SCAN_DIRECTORY "%ProgramFiles%\Adobe" "BLOCK_ALL"
)

:: Scan Program Files (x86)
if exist "%ProgramFiles(x86)%\Adobe" (
    call :SCAN_DIRECTORY "%ProgramFiles(x86)%\Adobe" "BLOCK_ALL"
)

:: Scan Common Files
if exist "%CommonProgramFiles%\Adobe" (
    call :SCAN_DIRECTORY "%CommonProgramFiles%\Adobe" "BLOCK_ALL"
)

if exist "%CommonProgramFiles(x86)%\Adobe" (
    call :SCAN_DIRECTORY "%CommonProgramFiles(x86)%\Adobe" "BLOCK_ALL"
)

:: Scan AppData
if exist "%APPDATA%\Adobe" (
    call :SCAN_DIRECTORY "%APPDATA%\Adobe" "BLOCK_ALL"
)

:: Scan LocalAppData
if exist "%LOCALAPPDATA%\Adobe" (
    call :SCAN_DIRECTORY "%LOCALAPPDATA%\Adobe" "BLOCK_ALL"
)

:: Scan ProgramData
if exist "%ProgramData%\Adobe" (
    call :SCAN_DIRECTORY "%ProgramData%\Adobe" "BLOCK_ALL"
)

:: Block critical Adobe services
call :BLOCK_CRITICAL_SERVICES

call :SHOW_SUMMARY
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:: ============================================
:: BLOCK WITH EXCLUSIONS
:: ============================================
:BLOCK_EXCLUDE
cls
echo.
echo ============================================================
echo  Blocking Adobe (Excluding Helpers/Updaters)
echo ============================================================
echo.
echo Starting scan... Please wait...
echo.

set "BLOCKED_COUNT=0"
set "SKIPPED_COUNT=0"

call :LOG "Blocking Adobe applications (excluding helpers)..."

:: Scan Program Files
if exist "%ProgramFiles%\Adobe" (
    call :SCAN_DIRECTORY "%ProgramFiles%\Adobe" "BLOCK_EXCLUDE"
)

:: Scan Program Files (x86)
if exist "%ProgramFiles(x86)%\Adobe" (
    call :SCAN_DIRECTORY "%ProgramFiles(x86)%\Adobe" "BLOCK_EXCLUDE"
)

:: Scan Common Files
if exist "%CommonProgramFiles%\Adobe" (
    call :SCAN_DIRECTORY "%CommonProgramFiles%\Adobe" "BLOCK_EXCLUDE"
)

if exist "%CommonProgramFiles(x86)%\Adobe" (
    call :SCAN_DIRECTORY "%CommonProgramFiles(x86)%\Adobe" "BLOCK_EXCLUDE"
)

:: Scan AppData
if exist "%APPDATA%\Adobe" (
    call :SCAN_DIRECTORY "%APPDATA%\Adobe" "BLOCK_EXCLUDE"
)

:: Scan LocalAppData
if exist "%LOCALAPPDATA%\Adobe" (
    call :SCAN_DIRECTORY "%LOCALAPPDATA%\Adobe" "BLOCK_EXCLUDE"
)

:: Scan ProgramData
if exist "%ProgramData%\Adobe" (
    call :SCAN_DIRECTORY "%ProgramData%\Adobe" "BLOCK_EXCLUDE"
)

call :SHOW_SUMMARY
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:: ============================================
:: BLOCK CRITICAL ADOBE SERVICES
:: ============================================
:BLOCK_CRITICAL
cls
echo.
echo ============================================================
echo  Blocking Critical Adobe Services
echo ============================================================
echo.
echo This will block known Adobe background services:
echo  - Adobe Desktop Service
echo  - Adobe CEF HTML Engine
echo  - Adobe Genuine Software Monitor (AGM)
echo  - Adobe Genuine Launcher
echo  - Adobe GC Invoker Utility
echo  - CCXProcess
echo  - Creative Cloud Helper
echo.

set "BLOCKED_COUNT=0"
set "SKIPPED_COUNT=0"

call :LOG "Blocking critical Adobe services..."
call :BLOCK_CRITICAL_SERVICES

echo.
echo ============================================================
echo  Critical Services Blocking Complete
echo ============================================================
echo  Total applications blocked: %BLOCKED_COUNT%
echo  Applications skipped:       %SKIPPED_COUNT%
echo ============================================================
echo.
call :LOG "Critical services blocking complete"
call :LOG "Total blocked: %BLOCKED_COUNT%, Skipped: %SKIPPED_COUNT%"
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:: ============================================
:: BLOCK CRITICAL SERVICES FUNCTION
:: ============================================
:BLOCK_CRITICAL_SERVICES
echo.
echo Blocking critical Adobe services...
call :LOG "Blocking critical Adobe services..."

:: Define critical Adobe executables
set "CRITICAL_EXES=AdobeDesktopService.exe CEPHtmlEngine.exe cephtmlengine.exe AGMService.exe AdobeGenuineLauncher.exe AGCInvokerUtility.exe CCXProcess.exe AdobeIPCBroker.exe Creative Cloud.exe CCLibrary.exe AdobeNotificationClient.exe node.exe AdobeGCClient.exe AdobeCollabSync.exe CoreSync.exe"

for %%e in (%CRITICAL_EXES%) do (
    call :FIND_AND_BLOCK_EXE "%%e"
)

goto :EOF

:: ============================================
:: FIND AND BLOCK EXECUTABLE
:: ============================================
:FIND_AND_BLOCK_EXE
set "TARGET_EXE=%~1"
set "FOUND=0"

:: Search in all Adobe directories
for %%d in ("%ProgramFiles%\Adobe" "%ProgramFiles(x86)%\Adobe" "%CommonProgramFiles%\Adobe" "%CommonProgramFiles(x86)%\Adobe" "%ProgramData%\Adobe" "%LOCALAPPDATA%\Adobe" "%APPDATA%\Adobe") do (
    if exist "%%~d" (
        for /r "%%~d" %%f in (%TARGET_EXE%) do (
            if exist "%%f" (
                set "FOUND=1"
                call :ADD_FIREWALL_RULE "%%f" "%TARGET_EXE%"
            )
        )
    )
)

if !FOUND! equ 0 (
    echo [INFO] %TARGET_EXE% not found on system
    call :LOG "[INFO] %TARGET_EXE% not found on system"
)

goto :EOF

:: ============================================
:: CUSTOM DIRECTORY SCAN
:: ============================================
:CUSTOM_SCAN
cls
echo.
echo ============================================================
echo  Custom Directory Scan
echo ============================================================
echo.
set /p "CUSTOM_DIR=Enter the full path to scan: "

if not exist "%CUSTOM_DIR%" (
    echo.
    echo ERROR: Directory not found: %CUSTOM_DIR%
    call :LOG "ERROR: Directory not found: %CUSTOM_DIR%"
    echo.
    echo Press any key to return to menu...
    pause >nul
    goto MENU
)

set "BLOCKED_COUNT=0"
set "SKIPPED_COUNT=0"

call :SCAN_DIRECTORY "%CUSTOM_DIR%" "BLOCK_ALL"
call :SHOW_SUMMARY
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:: ============================================
:: CLEAR ADOBE APPLICATION DATA
:: ============================================
:CLEAR_DATA
cls
echo.
echo ============================================================
echo  Clear Adobe Application Data
echo ============================================================
echo.
echo WARNING: This will delete ALL Adobe user data including:
echo  - Preferences and settings
echo  - Cache files
echo  - Recent files history
echo  - Workspaces and custom configurations
echo  - License activation data
echo.
echo Adobe applications will run as if newly installed.
echo You may need to re-activate your products.
echo.
echo ============================================================
echo.
set /p "CONFIRM=Type YES to confirm deletion: "

if /i not "%CONFIRM%"=="YES" (
    echo.
    echo Operation cancelled.
    call :LOG "Data clearing cancelled by user"
    echo.
    echo Press any key to return to menu...
    pause >nul
    goto MENU
)

echo.
echo Stopping Adobe processes...
call :LOG "Starting Adobe data clearing operation..."

:: Stop Adobe processes
call :STOP_ADOBE_PROCESSES

echo.
echo Clearing Adobe application data...
echo.

set "DELETED_COUNT=0"
set "ERROR_COUNT=0"

:: Clear AppData\Roaming\Adobe
if exist "%APPDATA%\Adobe" (
    echo Clearing: %APPDATA%\Adobe
    call :LOG "Clearing: %APPDATA%\Adobe"
    rd /s /q "%APPDATA%\Adobe" 2>nul
    if !errorlevel! equ 0 (
        set /a DELETED_COUNT+=1
        echo [SUCCESS] Cleared AppData\Roaming\Adobe
        call :LOG "[SUCCESS] Cleared AppData\Roaming\Adobe"
    ) else (
        set /a ERROR_COUNT+=1
        echo [ERROR] Failed to clear AppData\Roaming\Adobe
        call :LOG "[ERROR] Failed to clear AppData\Roaming\Adobe"
    )
)

:: Clear LocalAppData\Adobe
if exist "%LOCALAPPDATA%\Adobe" (
    echo Clearing: %LOCALAPPDATA%\Adobe
    call :LOG "Clearing: %LOCALAPPDATA%\Adobe"
    rd /s /q "%LOCALAPPDATA%\Adobe" 2>nul
    if !errorlevel! equ 0 (
        set /a DELETED_COUNT+=1
        echo [SUCCESS] Cleared LocalAppData\Adobe
        call :LOG "[SUCCESS] Cleared LocalAppData\Adobe"
    ) else (
        set /a ERROR_COUNT+=1
        echo [ERROR] Failed to clear LocalAppData\Adobe
        call :LOG "[ERROR] Failed to clear LocalAppData\Adobe"
    )
)

:: Clear ProgramData\Adobe (preserving installation files)
if exist "%ProgramData%\Adobe" (
    echo Clearing Adobe cache and temp files in ProgramData...
    call :LOG "Clearing cache/temp in ProgramData\Adobe"
    
    :: Clear specific folders that contain user data
    if exist "%ProgramData%\Adobe\SLCache" (
        rd /s /q "%ProgramData%\Adobe\SLCache" 2>nul
        echo [SUCCESS] Cleared SLCache
        call :LOG "[SUCCESS] Cleared SLCache"
    )
    
    if exist "%ProgramData%\Adobe\SLStore" (
        rd /s /q "%ProgramData%\Adobe\SLStore" 2>nul
        echo [SUCCESS] Cleared SLStore
        call :LOG "[SUCCESS] Cleared SLStore"
    )
)

:: Clear Temp Adobe files
if exist "%TEMP%\Adobe" (
    echo Clearing: %TEMP%\Adobe
    call :LOG "Clearing: %TEMP%\Adobe"
    rd /s /q "%TEMP%\Adobe" 2>nul
    if !errorlevel! equ 0 (
        set /a DELETED_COUNT+=1
        echo [SUCCESS] Cleared Temp\Adobe
        call :LOG "[SUCCESS] Cleared Temp\Adobe"
    )
)

:: Clear Adobe-related registry entries (optional - be careful)
echo.
echo Clearing Adobe registry cache entries...
call :LOG "Clearing Adobe registry cache entries"
reg delete "HKCU\Software\Adobe" /f >nul 2>&1
if !errorlevel! equ 0 (
    echo [SUCCESS] Cleared user registry entries
    call :LOG "[SUCCESS] Cleared user registry entries"
)

echo.
echo ============================================================
echo              Data Clearing Complete
echo ============================================================
echo  Folders cleared: %DELETED_COUNT%
echo  Errors encountered: %ERROR_COUNT%
echo ============================================================
echo.
echo Adobe applications will now run as freshly installed.
echo You may need to sign in and re-activate your products.
echo.
call :LOG "=============================================="
call :LOG "Data clearing complete"
call :LOG "Folders cleared: %DELETED_COUNT%"
call :LOG "Errors: %ERROR_COUNT%"
call :LOG "=============================================="
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:: ============================================
:: STOP ADOBE PROCESSES
:: ============================================
:STOP_ADOBE_PROCESSES
echo Stopping Adobe processes...
call :LOG "Stopping Adobe processes..."

:: List of common Adobe processes
set "ADOBE_PROCESSES=AdobeDesktopService.exe CEPHtmlEngine.exe cephtmlengine.exe AGMService.exe AdobeGenuineLauncher.exe AGCInvokerUtility.exe Adobe CEF Helper.exe AdobeIPCBroker.exe Creative Cloud.exe CCXProcess.exe CCLibrary.exe AdobeNotificationClient.exe node.exe AdobeGCClient.exe AdobeCollabSync.exe CoreSync.exe"

for %%p in (%ADOBE_PROCESSES%) do (
    tasklist /FI "IMAGENAME eq %%p" 2>NUL | find /I /N "%%p">NUL
    if !errorlevel! equ 0 (
        echo Stopping: %%p
        taskkill /F /IM "%%p" >nul 2>&1
        call :LOG "Stopped process: %%p"
    )
)

:: Stop all Adobe*.exe processes
for /f "tokens=1" %%p in ('tasklist /FI "IMAGENAME eq Adobe*" ^| findstr /i "Adobe"') do (
    echo Stopping: %%p
    taskkill /F /IM "%%p" >nul 2>&1
    call :LOG "Stopped process: %%p"
)

:: Wait for processes to close
timeout /t 2 /nobreak >nul
echo All Adobe processes stopped.
call :LOG "All Adobe processes stopped"
goto :EOF

:: ============================================
:: REMOVE EXISTING RULES
:: ============================================
:REMOVE_RULES
cls
echo.
echo ============================================================
echo  Remove Existing Adobe Firewall Rules
echo ============================================================
echo.
echo WARNING: This will remove ALL Adobe firewall rules.
echo.
set /p "CONFIRM=Are you sure? (YES/NO): "

if /i not "%CONFIRM%"=="YES" (
    echo Operation cancelled.
    call :LOG "Rule removal cancelled by user"
    echo.
    echo Press any key to return to menu...
    pause >nul
    goto MENU
)

echo.
echo Removing Adobe firewall rules...
call :LOG "Starting removal of Adobe firewall rules..."

set "REMOVE_COUNT=0"

:: Get all rules and filter for Adobe
for /f "tokens=2 delims=:" %%i in ('netsh advfirewall firewall show rule name^=all ^| findstr /C:"Rule Name"') do (
    set "RULE_NAME=%%i"
    set "RULE_NAME=!RULE_NAME:~1!"
    
    echo !RULE_NAME! | findstr /i /C:"Block_Adobe" >nul
    if !errorlevel! equ 0 (
        netsh advfirewall firewall delete rule name="!RULE_NAME!" >nul 2>&1
        if !errorlevel! equ 0 (
            set /a REMOVE_COUNT+=1
            echo Removed: !RULE_NAME!
            call :LOG "Removed rule: !RULE_NAME!"
        )
    )
)

echo.
echo ============================================================
echo Removed !REMOVE_COUNT! firewall rules
echo ============================================================
call :LOG "Total rules removed: !REMOVE_COUNT!"
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:: ============================================
:: VIEW LOG FILE
:: ============================================
:VIEW_LOG
cls
if exist "%LOGFILE%" (
    type "%LOGFILE%"
) else (
    echo No log file found.
)
echo.
echo Press any key to return to menu...
pause >nul
goto MENU

:: ============================================
:: SCAN DIRECTORY FUNCTION
:: ============================================
:SCAN_DIRECTORY
set "SCAN_PATH=%~1"
set "SCAN_MODE=%~2"

echo Scanning: %SCAN_PATH%
call :LOG "Scanning directory: %SCAN_PATH%"

for /r "%SCAN_PATH%" %%f in (*.exe) do (
    set "EXE_FILE=%%~nxf"
    set "EXE_PATH=%%f"
    
    if "%SCAN_MODE%"=="BLOCK_EXCLUDE" (
        call :CHECK_EXCLUDE "!EXE_FILE!"
        if !errorlevel! equ 1 (
            set /a SKIPPED_COUNT+=1
            echo [SKIP] !EXE_FILE! - excluded by pattern
            call :LOG "[SKIP] !EXE_FILE! - excluded by pattern"
        ) else (
            call :ADD_FIREWALL_RULE "!EXE_PATH!" "!EXE_FILE!"
        )
    ) else (
        call :ADD_FIREWALL_RULE "!EXE_PATH!" "!EXE_FILE!"
    )
)

goto :EOF

:: ============================================
:: CHECK EXCLUDE PATTERNS
:: ============================================
:CHECK_EXCLUDE
set "FILE_NAME=%~1"
set "EXCLUDE=0"

echo %FILE_NAME% | findstr /i /C:"uninstall" >nul && set "EXCLUDE=1"
echo %FILE_NAME% | findstr /i /C:"helper" >nul && set "EXCLUDE=1"
echo %FILE_NAME% | findstr /i /C:"crash" >nul && set "EXCLUDE=1"
echo %FILE_NAME% | findstr /i /C:"reporter" >nul && set "EXCLUDE=1"
echo %FILE_NAME% | findstr /i /C:"installer" >nul && set "EXCLUDE=1"
echo %FILE_NAME% | findstr /i /C:"update" >nul && set "EXCLUDE=1"

exit /b %EXCLUDE%

:: ============================================
:: ADD FIREWALL RULE
:: ============================================
:ADD_FIREWALL_RULE
set "APP_PATH=%~1"
set "APP_NAME=%~2"

:: Check if rule already exists (check outbound only to save time)
netsh advfirewall firewall show rule name="Block_Adobe_%APP_NAME%_Out" >nul 2>&1
if %errorlevel% equ 0 (
    set /a SKIPPED_COUNT+=1
    echo [SKIP] Rules already exist for: %APP_NAME%
    call :LOG "[SKIP] Rules already exist for: %APP_NAME%"
    goto :EOF
)

:: Add Outbound rule
netsh advfirewall firewall add rule name="Block_Adobe_%APP_NAME%_Out" dir=out action=block program="%APP_PATH%" enable=yes profile=any >nul 2>&1

if %errorlevel% equ 0 (
    :: Add Inbound rule
    netsh advfirewall firewall add rule name="Block_Adobe_%APP_NAME%_In" dir=in action=block program="%APP_PATH%" enable=yes profile=any >nul 2>&1
    
    if %errorlevel% equ 0 (
        set /a BLOCKED_COUNT+=1
        echo [SUCCESS] Blocked INBOUND + OUTBOUND: %APP_NAME%
        call :LOG "[SUCCESS] Blocked INBOUND + OUTBOUND: %APP_NAME% - %APP_PATH%"
    ) else (
        echo [ERROR] Failed to add inbound rule for: %APP_NAME%
        call :LOG "[ERROR] Failed to add inbound rule for: %APP_NAME%"
    )
) else (
    echo [ERROR] Failed to add outbound rule for: %APP_NAME%
    call :LOG "[ERROR] Failed to add outbound rule for: %APP_NAME%"
)

goto :EOF

:: ============================================
:: SHOW SUMMARY
:: ============================================
:SHOW_SUMMARY
echo.
echo ============================================================
echo                    Operation Complete
echo ============================================================
echo  Total applications blocked: %BLOCKED_COUNT%
echo  Applications skipped:       %SKIPPED_COUNT%
echo ============================================================
echo.
echo Log file saved to:
echo %LOGFILE%
echo.
call :LOG "=============================================="
call :LOG "Operation complete"
call :LOG "Total applications blocked: %BLOCKED_COUNT%"
call :LOG "Applications skipped: %SKIPPED_COUNT%"
call :LOG "=============================================="
goto :EOF

:: ============================================
:: LOGGING FUNCTION
:: ============================================
:LOG
echo %DATE% %TIME% - %~1 >> "%LOGFILE%"
goto :EOF

:: ============================================
:: EXIT
:: ============================================
:EXIT
cls
echo.
echo Thank you for using Adobe Firewall Blocker!
echo.
echo Log file saved to:
echo %LOGFILE%
echo.
call :LOG "Script terminated by user"
timeout /t 3 >nul
exit /b 0