#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

void printCollatz(int n)
{
    while (n != 1)
    {
        printf("%d ", n);
        if (n & 1) // if n is odd just do n = 3n + 1
            n = 3 * n + 1;
        else // else divide by 2
            n /= 2;
    }
    printf("1\n\n");
}
int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("Please check the command line arguments\n");
        exit(1);
    }
    int n = atoi(argv[1]);
    if (n < 0)
    {
        printf("Please enter a positive integer\n");
        exit(1); // exit with error code 1
    }
    pid_t pid = fork();
    if (pid == 0)
    {
        printf("Child process is starting to work on collatz sequence\n\n");
        printCollatz(n);
        printf("Child process completed\n");
    }
    else
    {
        printf("Parent is now waiting for the child process to complete\n");
        wait(NULL); // parent waiting for child to complete
        printf("Parent Process is completed\n");
    }
    return 0;
}