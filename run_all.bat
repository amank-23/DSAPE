@echo off
echo Compiling Secure Token-Based Access System...

:: Compile Server
gcc src\server.c -Iinclude -o bin\server.exe -lws2_32
if %errorlevel% neq 0 (
    echo [ERROR] Server compilation failed!
    exit /b
)

:: Compile Client
gcc src\client.c -Iinclude -o bin\client.exe -lws2_32
if %errorlevel% neq 0 (
    echo [ERROR] Client compilation failed!
    exit /b
)

:: Compile Authenticator
gcc src\authenticator.c -Iinclude -o bin\authenticator.exe
if %errorlevel% neq 0 (
    echo [ERROR] Authenticator compilation failed!
    exit /b
)

echo Compilation successful!
echo Starting Secure Token-Based Access System...
echo.

:: Start Server
start cmd /k "echo [SERVER STARTED] && bin\server.exe"

:: Delay to allow the server to start
timeout /t 1 >nul

:: Start Authenticator
start cmd /k "echo [AUTHENTICATOR STARTED] && bin\authenticator.exe"

:: Start Client
start cmd /k "echo [CLIENT STARTED] && bin\client.exe"

echo.
echo All processes started successfully.
echo Press any key to exit...
pause >nul
