#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include<unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include<sys/wait.h>
#include<assert.h>

int main(char argc, char* argv[]) {
    if(argv[1]==NULL) {
        if(argv[1]==NULL) {
            printf("Enter a Valid Argument!\n"); // Invalid argument
        }
        exit(1);
    }

    const int SIZE = 512; // Reserving size for shared memory object
    const char *name = "Assignment_1_OS";
    int shm_fd;
    char *ptr;

    shm_fd = shm_open(name, O_CREAT | O_RDWR, 0666);

    /* configure the size of the shared memory segment */
    ftruncate(shm_fd,SIZE);

    /* now map the shared memory segment in the address space of the process */
    ptr = mmap(0,SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
    if (ptr == MAP_FAILED) {
        printf("Map failed\n");
        exit(1);
    }

    struct timeval st,end;
    pid_t pid;

    /* fork a child process */
    pid = fork();

    if (pid < 0) { /* error occurred */
        fprintf(stderr, "Fork Failed\n");
        return 1;
    }
    else if (pid == 0) { /* child process */
        gettimeofday(&st,NULL);
        sprintf(ptr,"%ld %ld",st.tv_sec,st.tv_usec);
        if(execvp(argv[1],argv+1)<0) {
            printf("exec Failed!! Not an executble command\n");
            exit(EXIT_FAILURE);
        }
        assert(0);
    }
    else { /* parent process */
        /* parent will wait for the child to complete */
        wait(NULL);
        gettimeofday(&end,NULL);
        long st_first,st_micro_first;
        sscanf(ptr,"%ld %ld",&st_first,&st_micro_first);
        double elapsed_time = (end.tv_sec-st_first)+(end.tv_usec-st_micro_first)*1e-6;
        printf("Elapsed time: %lf sec\n",elapsed_time);
        shm_unlink(name);
    }

    return 0;
}