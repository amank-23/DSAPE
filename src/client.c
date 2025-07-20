#include <stdio.h>
#include <winsock2.h>
#include <time.h>
#pragma comment(lib, "ws2_32.lib")

#define SERVER_IP "127.0.0.1"
#define PORT 8080
#define LOG_FILE "client_log.txt"

void log_event(const char *event) // Logging function
{
    FILE *log_file = fopen(LOG_FILE, "a"); // opens log file in append mode
    if (log_file != NULL)
    {
        time_t now = time(NULL);
        fprintf(log_file, "[%s] %s\n", ctime(&now), event);
        fclose(log_file);
    }
}

int main()
{
    WSADATA wsa;
    SOCKET s;
    struct sockaddr_in server; // Stores server address
    char server_reply[2000];
    int token;

    printf("Enter access token: ");
    scanf("%d", &token);

    char log_msg[50];
    snprintf(log_msg, sizeof(log_msg), "Entered Token: %d", token);
    log_event(log_msg); // Log the entered token

    WSAStartup(MAKEWORD(2, 2), &wsa);    // winsock version 2.2 is initialised
    s = socket(AF_INET, SOCK_STREAM, 0); // AF_INET = IPv4 Addressing , Sock Stream = TCP communication, 0= Default protocol

    server.sin_addr.s_addr = inet_addr(SERVER_IP); // IP string -> Binary
    server.sin_family = AF_INET;                   // IPv4
    server.sin_port = htons(PORT);                 // Convert to big endian format

    connect(s, (struct sockaddr *)&server, sizeof(server)); // Connection request to server
    send(s, (char *)&token, sizeof(token), 0);              // Token to server

    int recv_size = recv(s, server_reply, sizeof(server_reply), 0); // Server Response
    server_reply[recv_size] = '\0';
    printf("Server: %s", server_reply);

    snprintf(log_msg, sizeof(log_msg), "Server Response: %s", server_reply); // Server Response in log file
    log_event(log_msg);

    closesocket(s);
    WSACleanup();
    return 0;
}
