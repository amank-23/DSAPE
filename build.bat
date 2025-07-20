@echo off
echo ========================================
echo   Secure Token-Based Access System
echo        Build and Run Script
echo ========================================

:: Set project paths
set SRC_DIR=src
set BIN_DIR=bin  
set INCLUDE_DIR=include
set LOGS_DIR=logs
set CONFIG_DIR=config

:: Clean previous builds and logs
echo Cleaning previous build artifacts and logs...
if exist "%BIN_DIR%\*.exe" del "%BIN_DIR%\*.exe"
if exist "%LOGS_DIR%\*.txt" del "%LOGS_DIR%\*.txt"

echo.
echo Compiling Secure Token-Based Access System...
echo.

:: Compile Server
echo [1/3] Compiling Server...
gcc "%SRC_DIR%\server.c" -I"%INCLUDE_DIR%" -o "%BIN_DIR%\server.exe" -lws2_32
if %errorlevel% neq 0 (
    echo [ERROR] Server compilation failed!
    pause
    exit /b 1
)
echo     ✓ Server compiled successfully

:: Compile Client  
echo [2/3] Compiling Client...
gcc "%SRC_DIR%\client.c" -I"%INCLUDE_DIR%" -o "%BIN_DIR%\client.exe" -lws2_32
if %errorlevel% neq 0 (
    echo [ERROR] Client compilation failed!
    pause
    exit /b 1
)
echo     ✓ Client compiled successfully

:: Compile Authenticator
echo [3/3] Compiling Authenticator...
gcc "%SRC_DIR%\authenticator.c" -I"%INCLUDE_DIR%" -o "%BIN_DIR%\authenticator.exe"
if %errorlevel% neq 0 (
    echo [ERROR] Authenticator compilation failed!
    pause
    exit /b 1
)
echo     ✓ Authenticator compiled successfully

echo.
echo ✓ All components compiled successfully!
echo.
echo Starting Secure Token-Based Access System...
echo.

:: Change to bin directory for execution
cd "%BIN_DIR%"

:: Start Server
echo Starting Server...
start "SERVER - Token Access System" cmd /k "echo [SERVER STARTED - Port 8080] && server.exe"

:: Delay to allow server startup
echo Waiting for server to initialize...
timeout /t 2 >nul

:: Start Authenticator
echo Starting Authenticator...
start "AUTHENTICATOR - Token Generator" cmd /k "echo [AUTHENTICATOR - Check current token here] && authenticator.exe"

:: Small delay
timeout /t 1 >nul

:: Start Client
echo Starting Client...
start "CLIENT - Access Tester" cmd /k "echo [CLIENT - Enter token from Authenticator] && client.exe"

:: Return to root directory
cd ..

echo.
echo ========================================
echo   System Status: ALL COMPONENTS RUNNING
echo ========================================
echo.
echo Instructions:
echo 1. Check AUTHENTICATOR window for current valid token
echo 2. Enter that token in CLIENT window to test access
echo 3. Try invalid tokens to test security
echo.
echo Log files location: %LOGS_DIR%\
echo Executables location: %BIN_DIR%\
echo.
echo Press any key to view project structure or close...
pause >nul

:: Show project structure
echo.
echo Current Project Structure:
tree /f /a
echo.
pause
