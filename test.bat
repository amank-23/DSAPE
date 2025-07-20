@echo off
echo ========================================
echo     Quick Multi-Client Test Runner
echo ========================================

:: Set directories
set BIN_DIR=bin
set LOGS_DIR=logs

:: Clean logs for fresh test
if exist "%LOGS_DIR%\*.txt" del "%LOGS_DIR%\*.txt"

echo Starting multi-client test scenario...
echo.

:: Change to bin directory
cd "%BIN_DIR%"

:: Start Server
echo [1] Starting Server...
start "SERVER" cmd /k "echo === SERVER WINDOW === && echo Listening on port 8080... && server.exe"

:: Wait for server
timeout /t 2 >nul

:: Start Authenticator
echo [2] Starting Authenticator (Token Generator)...
start "AUTHENTICATOR" cmd /k "echo === AUTHENTICATOR WINDOW === && echo Check this window for valid token && authenticator.exe"

:: Wait a moment
timeout /t 1 >nul

:: Start Multiple Clients for testing
echo [3] Starting Multiple Test Clients...
start "CLIENT-1" cmd /k "echo === CLIENT TEST 1 === && echo Try VALID token from Authenticator && client.exe"

timeout /t 0.5 >nul
start "CLIENT-2" cmd /k "echo === CLIENT TEST 2 === && echo Try INVALID token (e.g., 12345) && client.exe"

timeout /t 0.5 >nul  
start "CLIENT-3" cmd /k "echo === CLIENT TEST 3 === && echo Try RANDOM token && client.exe"

:: Return to root
cd ..

echo.
echo ✓ All test windows opened!
echo.
echo TEST SCENARIOS:
echo ────────────────────────────────────────
echo CLIENT-1: Use valid token (should succeed)
echo CLIENT-2: Use invalid token (should fail)  
echo CLIENT-3: Use random number (should fail)
echo.
echo Check AUTHENTICATOR window for current valid token!
echo.
echo Press any key to view logs after testing...
pause >nul

:: Display logs
echo.
echo ========================================
echo               TEST RESULTS
echo ========================================

if exist "%LOGS_DIR%\log.txt" (
    echo.
    echo SERVER LOG:
    echo ───────────
    type "%LOGS_DIR%\log.txt"
)

if exist "%LOGS_DIR%\client_log.txt" (
    echo.
    echo CLIENT LOG:  
    echo ────────────
    type "%LOGS_DIR%\client_log.txt"
)

echo.
echo Testing complete! Check the terminal windows for real-time results.
pause
