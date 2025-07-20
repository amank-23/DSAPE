#include <stdio.h>
#include <windows.h>
#include "shared_secret.h"
#define sleep(x) Sleep((x) * 1000) // Pauses the program before next iteration

int main()
{
    char secret[SECRET_LEN + 1];
    get_shared_secret(secret);

    while (1) // Runs an infinite loop
    {
        int token = generate_token(secret); // Generates the token from custom library
        time_t t = time(NULL);
        int remaining = 30 - (t % 30);

        printf("\rToken: %d | Refreshes in: %d sec ", token, remaining);
        fflush(stdout);
        sleep(1);
    }
    return 0;
}
