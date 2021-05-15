#include <fcntl.h>                  // Importing Libraries
#include <math.h>
#include <netinet/in.h>
#include <net/if.h>
#include <pthread.h>
#include <stdio.h>                  
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define MAXBUFSIZE 4088             // Packet size
#define MAXSEND 10

char* filepath = "recvdFile";       // Default recieving file name
int portno = 4444;                  // Default port number
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
int negAcks = 0;


typedef struct dgram                // Datagram
{              
    uint32_t seqNum;                // Store sequence 
    uint32_t dataSize;              // Datasize
    char buf[MAXBUFSIZE];           // Data buffer 
} dgram;

char *pktStatusArr;
int indexPtr = 0;

struct timespec start, stop;        // To measure time
double totaltime;                   // Total time taken 

pthread_t negAckThrd;               // Thread
int fileSize;
int sockfd;
struct sockaddr_in serv_addr;

int totalPacketsArrived = 0;        // int denoting number of packets arrived till now
int totalSeq = 0;                   // int denoting total number of sequenc numbers 

/**
 * This method throws the perror and exits the program
 * @param msg           Character array that is the error message
 **/
void reportError(const char *msg)
{
    perror(msg);
    exit(1);
}

/**
 * This method iterates through all packets status array and finds index of packet that is not returned yet
 **/
int findMissingPacket()       
{
	int i = 0;
	if( pktStatusArr == NULL)
    {
		return -1;
	}
	for ( i = indexPtr; i <= totalSeq ; i++)
	{
		if (pktStatusArr[i] == 0)
		{
			if (i == totalSeq)
				indexPtr = 0;
			else
				indexPtr = i+1;
            return i;
		}
	}
	indexPtr = 0;
	return -1; 
}

/**
 * This method returns the missed packet indices to the client   
 **/
void* thrdFunc(void* arg)
{
    int n = 0;
    int missingPktIndex;

    while(1)
    {
        if(totalPacketsArrived == totalSeq+1) 
        {
            printf("Entire data recieved!! \n");
            pthread_exit(0);
        }
        usleep(900);
        pthread_mutex_lock(&lock);
        missingPktIndex = findMissingPacket();      // Find missing packet
        pthread_mutex_unlock(&lock);
        if(missingPktIndex>=0 && missingPktIndex<=totalSeq)
        {
            n = sendto(sockfd, &missingPktIndex ,sizeof(int),0,(struct sockaddr *)&serv_addr,sizeof(serv_addr));
            __atomic_fetch_add(&negAcks, 1, __ATOMIC_SEQ_CST);
            
            if (n < 0)
                reportError("sendto\n");
        }
    }
}

/**
 * This method    
 * @param pktSeqNum     Sequence number of the packet
 **/
int markPktAsRcvd(int pktSeqNum)
{
	if( pktSeqNum >=0 && pktSeqNum <=totalSeq)
    {
        if( pktStatusArr[pktSeqNum] == 0)
        {
			pktStatusArr[pktSeqNum] = 1;
			return 1;
		}
        else 
			return 0;
	}
    return 0;
}


int main(int argc, char *argv[])
{
    int i = 0;
    socklen_t clientLen;
    int n;
    FILE *fp;
    int errno = 0 ;
    
    dgram recvDG;
    int ack = -1;
    
    if (argc < 2) 
    {
        printf("Port number is not specified...Switching to default port %d!\n", portno);
    }
    else 
    {
        portno = atoi(argv[1]);
    }

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);              // Creating socket

    if (sockfd < 0)
    {
        reportError("ERROR opening socket");
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(portno);
    
    //struct ifreq ifr;
    //memset(&ifr, 0, sizeof(ifr)); 
    //snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "lo"); 
    //if (setsockopt(sockfd, SOL_SOCKET, SO_BINDTODEVICE, (void *)&ifr, sizeof(ifr)) < 0) 
    //{ 
      //  reportError("setsockopt error");        
    //}
    
    if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0)    // Binding the socket
        reportError("ERROR on binding");
    
	clientLen = sizeof(struct sockaddr_in);


    // Recieving file size from the client
    n = recvfrom(sockfd,&fileSize,sizeof(fileSize),0,(struct sockaddr *)&serv_addr,&clientLen);
    
    totalSeq = ceil(fileSize / MAXBUFSIZE);
	printf("Total Packets to be received : %d\n",totalSeq);
    
    printf("Deafult file name is : %s", filepath);
    
    fp = fopen(filepath , "w+");
    
    pktStatusArr = calloc(totalSeq , sizeof(char));         // Array that marks if packet with that SequenceNum has been recived or not
    
    if(clock_gettime(CLOCK_REALTIME , &start) == -1){
        reportError("Clock get time");
    }
    
    int threadCreated = 0;
    while (1)
    {
		fflush(stdout);

        n = recvfrom(sockfd,&recvDG,sizeof(dgram),0,(struct sockaddr *)&serv_addr,&clientLen);
        
        if( n == sizeof(int))
        {
            continue;
		}
        if (n < 0)
        {
            reportError("recvfrom");
        }

        if(threadCreated == 0 && recvDG.seqNum > 0)
        {
            threadCreated = 1;
            if((errno = pthread_create(&negAckThrd, 0, thrdFunc , (void*)0)))
            {
                fprintf(stderr, "pthread_create %s\n",strerror(errno));
                pthread_exit(0);
            }
        }

        pthread_mutex_lock(&lock);
        if(markPktAsRcvd(recvDG.seqNum))
        {
            printf("Sequence number of received packet : %d\n",recvDG.seqNum);
            fseek(fp, MAXBUFSIZE*recvDG.seqNum, SEEK_SET);
            fwrite(&recvDG.buf, recvDG.dataSize, 1, fp);
            fflush(fp);
            totalPacketsArrived++;
        }
        pthread_mutex_unlock(&lock);
        
        if(totalPacketsArrived == totalSeq+1)
        {
            printf("Recieved the whole file!!\n");
            for(i=0 ; i<MAXSEND ; i++)
            {
                n = sendto(sockfd,&ack,sizeof(int), 0,(struct sockaddr *) &serv_addr,sizeof(serv_addr));
                if (n < 0)
                    reportError("Sendto");
            }
            break;
        }
    }

    pthread_join(negAckThrd, 0);      // Joining the child thread

    fclose(fp);

    if(clock_gettime(CLOCK_REALTIME,&stop) == -1)
    {
        reportError("clock get time stop");
    }
    totaltime = (stop.tv_sec - start.tv_sec)+(double)(stop.tv_nsec - start.tv_nsec)/1e9;

    printf("Time taken to complete : %f sec",totaltime);
    // printf("Negative acks sent : %d \n",negAcks);

    close(sockfd);
    return 0;
}
