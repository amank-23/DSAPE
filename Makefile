# Makefile for Secure Token-Based Access System

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LIBS = -lws2_32

# Directories  
SRC_DIR = src
BIN_DIR = bin
INCLUDE_DIR = include
LOGS_DIR = logs

# Source files
SERVER_SRC = $(SRC_DIR)/server.c
CLIENT_SRC = $(SRC_DIR)/client.c
AUTH_SRC = $(SRC_DIR)/authenticator.c

# Executables
SERVER_EXE = $(BIN_DIR)/server.exe
CLIENT_EXE = $(BIN_DIR)/client.exe
AUTH_EXE = $(BIN_DIR)/authenticator.exe

# Default target
all: clean dirs $(SERVER_EXE) $(CLIENT_EXE) $(AUTH_EXE)
	@echo "✓ Build completed successfully!"

# Create directories
dirs:
	@if not exist "$(BIN_DIR)" mkdir "$(BIN_DIR)"
	@if not exist "$(LOGS_DIR)" mkdir "$(LOGS_DIR)"

# Build server
$(SERVER_EXE): $(SERVER_SRC)
	@echo "Compiling server..."
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) $(SERVER_SRC) -o $(SERVER_EXE) $(LIBS)

# Build client
$(CLIENT_EXE): $(CLIENT_SRC)
	@echo "Compiling client..."  
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) $(CLIENT_SRC) -o $(CLIENT_EXE) $(LIBS)

# Build authenticator
$(AUTH_EXE): $(AUTH_SRC)
	@echo "Compiling authenticator..."
	$(CC) $(CFLAGS) -I$(INCLUDE_DIR) $(AUTH_SRC) -o $(AUTH_EXE)

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@if exist "$(BIN_DIR)\*.exe" del "$(BIN_DIR)\*.exe"
	@if exist "$(LOGS_DIR)\*.txt" del "$(LOGS_DIR)\*.txt"

# Run the system
run: all
	@echo "Starting system..."
	@start "SERVER" cmd /k "cd $(BIN_DIR) && server.exe"
	@timeout /t 2 >nul
	@start "AUTHENTICATOR" cmd /k "cd $(BIN_DIR) && authenticator.exe"  
	@start "CLIENT" cmd /k "cd $(BIN_DIR) && client.exe"

# Run tests
test: all
	@echo "Starting test scenario..."
	@start "SERVER" cmd /k "cd $(BIN_DIR) && server.exe"
	@timeout /t 2 >nul
	@start "AUTHENTICATOR" cmd /k "cd $(BIN_DIR) && authenticator.exe"
	@timeout /t 1 >nul
	@start "CLIENT-1" cmd /k "cd $(BIN_DIR) && client.exe"
	@start "CLIENT-2" cmd /k "cd $(BIN_DIR) && client.exe"
	@start "CLIENT-3" cmd /k "cd $(BIN_DIR) && client.exe"

.PHONY: all clean dirs run test
