@echo off
echo ========================================
echo    Project Structure Verification
echo ========================================

echo Checking project structure...
echo.

:: Check if all directories exist
echo [✓] Checking directories...
if exist "src\" (echo     ✓ src/ - Source code) else (echo     ✗ src/ - MISSING)
if exist "bin\" (echo     ✓ bin/ - Executables) else (echo     ✗ bin/ - MISSING)  
if exist "include\" (echo     ✓ include/ - Headers) else (echo     ✗ include/ - MISSING)
if exist "config\" (echo     ✓ config/ - Configuration) else (echo     ✗ config/ - MISSING)
if exist "logs\" (echo     ✓ logs/ - Log files) else (echo     ✗ logs/ - MISSING)
if exist "docs\" (echo     ✓ docs/ - Documentation) else (echo     ✗ docs/ - MISSING)

echo.
echo [✓] Checking source files...
if exist "src\server.c" (echo     ✓ server.c) else (echo     ✗ server.c - MISSING)
if exist "src\client.c" (echo     ✓ client.c) else (echo     ✗ client.c - MISSING)
if exist "src\authenticator.c" (echo     ✓ authenticator.c) else (echo     ✗ authenticator.c - MISSING)

echo.
echo [✓] Checking executables...
if exist "bin\server.exe" (echo     ✓ server.exe) else (echo     ✗ server.exe - MISSING)
if exist "bin\client.exe" (echo     ✓ client.exe) else (echo     ✗ client.exe - MISSING)
if exist "bin\authenticator.exe" (echo     ✓ authenticator.exe) else (echo     ✗ authenticator.exe - MISSING)

echo.
echo [✓] Checking configuration...
if exist "include\shared_secret.h" (echo     ✓ shared_secret.h) else (echo     ✗ shared_secret.h - MISSING)
if exist "config\shared_secret.txt" (echo     ✓ shared_secret.txt) else (echo     ✗ shared_secret.txt - MISSING)

echo.
echo ========================================
echo           AVAILABLE COMMANDS
echo ========================================
echo.
echo To build and run:     .\build.bat
echo To run tests:         .\test.bat
echo To use make:          make all
echo                       make run
echo                       make test
echo.
echo Individual components:
echo   Server:             .\bin\server.exe
echo   Authenticator:      .\bin\authenticator.exe  
echo   Client:             .\bin\client.exe
echo.
echo Quick multi-test:
echo   Start server:       .\bin\server.exe
echo   Start auth:         .\bin\authenticator.exe
echo   Multiple clients:   .\bin\client.exe (run multiple times)
echo.
echo ========================================

echo Current Project Structure:
echo.
tree /f /a

echo.
echo Project restructured successfully! ✓
echo Ready for development and testing.
pause
