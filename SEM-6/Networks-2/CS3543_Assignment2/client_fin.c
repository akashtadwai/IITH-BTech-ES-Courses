#include <stdio.h>                      // Importing Libraries
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/stat.h>
#include <pthread.h>
#include <time.h>
#include <math.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>

#define PAYLOAD 4088
int portno = 4444;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
long long int totalPackets = 0;

int filesize = 0;
int errno = -1;
char *data;

struct sockaddr_in serv_addr;
struct stat fileStat;


struct timespec start_time, stop_time;        // To measure time
double totaltime;                   // Total time taken 

typedef struct dgram                // Datagram
{              
    uint32_t seqNum;                // Store sequence 
    uint32_t dataSize;              // Datasize
    char buf[PAYLOAD];              // Data buffer 
} dgram;

pthread_t missedPktThrd;
int sockfd;

/**
 * This method throws the perror and exits the program
 * @param msg           Character array that is the error message
 **/
void reportError(const char *msg)
{
    perror(msg);
    exit(0);
}

/**
 * This method returns returns a pointer to the mapped area
 * @param str           Character array that specifies the filename to be opened 
 **/
char *openFILE(char *str)
{
    int fp;
    char *virtfp;
    
    fp = open(str, O_RDONLY);
    if(fp < 0)
    {
        reportError("open failed!\n");
    }
    
    // get the status of the file 
    if(fstat(fp,&fileStat) < 0)
    {
        reportError("fstat failed!\n");
    }
    
    /*  mmap() creates a new mapping in the virtual address space of the calling process
        mmap it, data is a pointer which is mapping the whole file*/
    virtfp = mmap((caddr_t)0, fileStat.st_size , PROT_READ , MAP_SHARED , fp , 0) ;
    
    if(virtfp == MAP_FAILED)
    {
        reportError("mmap failed!\n");
    }
    
    return virtfp;
}

/**
 * This method returns the missed packet indices to the client   
 **/
void *thrdFunc(void* arg)
{
    int totalseq, lefbyte, size_p, n=0;
    dgram sendDG ;
    int missedPktSeqNum;
    socklen_t servlen;
    servlen = sizeof(serv_addr);
    
    while (1) 
    {
        n = recvfrom(sockfd,&missedPktSeqNum,sizeof(int),0,(struct sockaddr *)&serv_addr,&servlen);
        if(n<0){
            reportError("recvfrom failed!\n");
        }
        if( missedPktSeqNum < 0){
            printf("data recv fully");
            pthread_exit(0);
        }
        totalseq =  filesize / PAYLOAD;
        lefbyte = filesize % PAYLOAD;

        size_p = PAYLOAD;
        if(lefbyte != 0 && totalseq ==  missedPktSeqNum)
        {
        	size_p = lefbyte;
        }
        pthread_mutex_lock(&lock);
        
        memcpy( sendDG.buf , &data[missedPktSeqNum*PAYLOAD] , size_p);
        pthread_mutex_unlock(&lock);
        
        sendDG.seqNum = missedPktSeqNum;
        sendDG.dataSize = size_p;
        
        n = sendto(sockfd,&sendDG,sizeof(dgram), 0,(struct sockaddr *) &serv_addr,servlen);
        __atomic_fetch_add(&totalPackets, 1, __ATOMIC_SEQ_CST);

        if (n < 0)
            reportError("sendto failed!\n");

    }
}


int main(int argc, char *argv[])
{
	struct stat st;
    int seq = 0, datasize =0 ;
    int ack = -1;
       
    int n;
    char* filename;
    struct hostent *server;
    int i , j;
    
    if (argc == 3) 
    {
        printf("Port number is not specified...Switching to default port %d!\n", portno);
    }
    else if(argc == 4)
    {
        portno = atoi(argv[3]);
    }
    else if(argc < 3)
    {
        fprintf(stderr,"ERROR!\nUsage %s <filename> <ip address> <port>\n", argv[0]);
        exit(1);
    }
    filename = argv[1];

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
        reportError("failed to open socket!\n");

    server = gethostbyname(argv[2]);
    if (server == NULL) 
        reportError("gethostbyname failed! No such host!\n");

    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr,server->h_length);
    serv_addr.sin_port = htons(portno);
    
	
	if(stat(filename,&st)==0)
	{
        filesize=st.st_size;
        printf("The size of this file is %d\n", filesize);
	}

    for(i=0 ; i<10 ; i++){
        n = sendto(sockfd,&filesize,sizeof(filesize), 0,(struct sockaddr *) &serv_addr,sizeof(serv_addr));
        if (n < 0)
            reportError("sendto failed!\n");
    }
    pthread_mutex_lock(&lock);
    
    data = openFILE(filename);
    datasize = fileStat.st_size;
    
    pthread_mutex_unlock(&lock);
    
    if((errno = pthread_create(&missedPktThrd, 0, thrdFunc , (void*)0))){
        fprintf(stderr, "pthread_create[0] %s\n",strerror(errno));
        pthread_exit(0);
    }
    
    if(clock_gettime(CLOCK_REALTIME , &start_time) == -1){
        reportError("clock_gettime failed!\n");
    }

    while (datasize > 0) 
    {
        int chunk, share;
        dgram sendDG;
        memset(&sendDG , 0 , sizeof(dgram));
        
        share = datasize;
        chunk = PAYLOAD;
        
        if(share - chunk < 0)
        {
            chunk = share;
        } 
        else 
        {
            share = share - chunk;
        }
        pthread_mutex_lock(&lock);
        
        memcpy(sendDG.buf , &data[seq*PAYLOAD] , chunk);
        
        pthread_mutex_unlock(&lock);
        
        sendDG.seqNum = seq;
        sendDG.dataSize = chunk;
        usleep(300);
        printf("Sending Sequence Number %d \n",sendDG.seqNum);
        sendto(sockfd , &sendDG , sizeof(sendDG) , 0 , (struct sockaddr *) &serv_addr,sizeof(serv_addr));
        __atomic_fetch_add(&totalPackets, 1, __ATOMIC_SEQ_CST);
        seq++;
        datasize -= chunk;
    }
    
    pthread_join(missedPktThrd, 0);
    
    munmap(data, fileStat.st_size);
    
    if(clock_gettime(CLOCK_REALTIME,&stop_time) == -1)
    {
        reportError("clock_gettime failed!\n");
    }
    totaltime = (stop_time.tv_sec - start_time.tv_sec)+(double)(stop_time.tv_nsec - start_time.tv_nsec)/1e9;
    
    printf("Time taken to complete : %f sec\n",totaltime);
    printf("Throughput is : %lf MBytes/sec\n", (double)filesize/(1e6*totaltime));
    // printf("Total number of packets sent %lld \n",totalPackets);
    munmap(data, fileStat.st_size);
    
    close(sockfd);
    return 0;
}
