#include <stdio.h>                 //
#include <winsock2.h>              // Windows Socket programming library
#include <time.h>                  //  time module
#include "shared_secret.h"         //   custom library defined for generating,retrieving,storing tokens/key
#pragma comment(lib, "ws2_32.lib") // links the winsock library required

#define PORT 8080          // Defines a port
#define LOG_FILE "log.txt" // defines txt file where the result log would bee stored

void log_event(const char *event) // Function used for making the log file
{
    FILE *log_file = fopen(LOG_FILE, "a");
    if (log_file != NULL)
    {
        time_t now = time(NULL);
        fprintf(log_file, "[%s] %s\n", ctime(&now), event); // loop for current (current time and status)
        fclose(log_file);
    }
}

int main()
{
    WSADATA wsa;                       //
    SOCKET s, new_socket;              //
    struct sockaddr_in server, client; //  Initialization of the server. Defines necessary variables
    int c, recv_token, expected_token; //
    char secret[SECRET_LEN + 1];       //

    get_shared_secret(secret); // Retrieves the token/secret from shared_secret.h

    WSAStartup(MAKEWORD(2, 2), &wsa);    // Initialises winsock version 2.2. It sets up winsock
    s = socket(AF_INET, SOCK_STREAM, 0); // Initialises a TCP socket for communication b/w client and server
                                         // AF_INET specifies IPv4 addressing and SOCK_STREAM specifies TCP,0->default protocol

    server.sin_family = AF_INET;         // Specifies address family , here IPv4
    server.sin_addr.s_addr = INADDR_ANY; // server can accept connection from any available network interface
    server.sin_port = htons(PORT);       // defines port from where the server will listen

    bind(s, (struct sockaddr *)&server, sizeof(server)); // binds the socket to a specific IP
    listen(s, 3);                                        // Socket with start listening with a queue limit of 3 previous connections

    printf("Server started. Waiting for client...\n");
    c = sizeof(struct sockaddr_in);
    new_socket = accept(s, (struct sockaddr *)&client, &c);

    recv(new_socket, (char *)&recv_token, sizeof(recv_token), 0); // receives token from client and stores in recv_token

    expected_token = generate_token(secret);
    printf("Expected Token: %d\n", expected_token);
    printf("Received Token: %d\n", recv_token);

    char log_msg[100]; // writes whether the expected token = received or not
    snprintf(log_msg, sizeof(log_msg), "Received Token: %d, Expected: %d, Access: %s",
             recv_token, expected_token, (recv_token == expected_token) ? "Granted" : "Denied");
    log_event(log_msg); // Stores the logged message to log.txt

    const char *msg = (recv_token == expected_token) ? "Access Granted\n" : "Access Denied\n";
    send(new_socket, msg, strlen(msg), 0);

    closesocket(new_socket);
    closesocket(s);
    WSACleanup();
    return 0;
}
