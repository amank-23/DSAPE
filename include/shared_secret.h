#ifndef SHARED_SECRET_H
#define SHARED_SECRET_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define SECRET_FILE "shared_secret.txt" // File where it is saved
#define SECRET_LEN 16                   // Length ofthe string

// Read or generate the shared secret
void get_shared_secret(char *secret)
{
    FILE *file = fopen(SECRET_FILE, "r"); // opens the file in read mode

    if (file && fgets(secret, SECRET_LEN + 1, file)) // if the string already exists it closes the file
    {
        fclose(file);
        // Trim newline if present
        secret[strcspn(secret, "\n")] = '\0';
        return;
    }

    // Generate a new random secret
    const char charset[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"; // If it doesnt exist then its generated from the character set
    srand((unsigned)time(NULL));

    for (int i = 0; i < SECRET_LEN; i++) // Randomly picks 16 characters
        secret[i] = charset[rand() % (sizeof(charset) - 1)];

    secret[SECRET_LEN] = '\0'; // Null Terminator

    // Save the new secret to file
    file = fopen(SECRET_FILE, "w"); // Opens the file this time in write mode
    if (file)
    {
        fputs(secret, file); // Inputs the secret into the file and closes
        fclose(file);
    }
}

// Simple custom hash function
int simple_hash(const char *str) // Hash functon to generate number from the secret/token
{
    int hash = 0;
    for (int i = 0; str[i]; i++)  // Takes every character and multiplies its position with its ascii value
        hash += str[i] * (i + 1); // sums up each value
    return hash;
}

// Generate a time-based token using the shared secret
int generate_token(const char *secret)
{
    time_t t = time(NULL);                 // Current time in seconds
    return (t / 30) ^ simple_hash(secret); // Every thirty seconds the current time is xored with the number
}

#endif
