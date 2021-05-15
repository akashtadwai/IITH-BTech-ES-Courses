#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
#include<math.h>
#include <sys/time.h>

int arr[(int)1e6],arr2[(int)1e6];
int n,p,h;

void merge(int arr1[], int n1, int arr2[], int n2) // standard merge procedure for two sorted arrays.
{
    int i = 0, j = 0, k = 0;
    while (i<n1 && j <n2) {
        if (arr1[i] <= arr2[j])
            arr[k++] = arr1[i++];
        else
            arr[k++] = arr2[j++];
    }
    while (j < n2)
        arr[k++] = arr2[j++];
    while (i < n1)
        arr[k++] = arr1[i++];
}

int cmp(const void *a, const void *b) { // Compare function for quicksort
    return (*(int *)a - *(int *)b);
}

void* sort_workers(void* arg) { // sorting worker threads 
    int th_part= *((int*)arg);
    int val = pow(2,n-p);
    int l= th_part*val,h=(th_part+1)*val-1; // start and end part of segment for each thread
    qsort((void*)(arr+l),h-l+1,sizeof(int),cmp); // Applying quicksort on the respective segment
}

int main() {
    freopen("inp.txt","r",stdin); // Used for I/O from *.txt files
    freopen("output.txt","w+",stdout);
        scanf("%d%d",&n,&p);
        struct timeval st,end,s2,e2;
        for(int i=0; i<(int)pow(2,n); i++) arr[i]=arr2[i]=rand()%1000; // Generating random array of numbers
        printf("Original Array is: \n");
        for(int i=0; i<pow(2,n); i++) printf("%d ",arr[i]);
        printf("\n");
        int num_workers=pow(2,p); // Total number of threads
        gettimeofday(&st,NULL);
        pthread_t workers[num_workers]; // creating worker threads
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        for (int i = 0; i < num_workers ; i++) {
            int* th_num =malloc(sizeof(int));
            *th_num = i;
            pthread_create(&workers[i], &attr, sort_workers,
                           (void*)th_num); // calling runner function
        }
        for (int i = 0; i < num_workers; i++)
            pthread_join(workers[i], NULL); // waiting till all the worker threads are sorted.

        h=pow(2,n-p);
        for(int var=1; var<(int)pow(2,p); var++) { // Merging all the threads with main thread.
            int *l=(int*)malloc((var*h)*sizeof(int));
            int *r=(int*)malloc(h*sizeof(int));
            for(int i=0; i<var*h; i++)l[i]=arr[i];
            for(int i=var*h,j=0; i<(var+1)*h,j<h; i++,j++) r[j]=arr[i];
            merge(l,var*h,r,h);
            free (l);
            free (r);
        }
        gettimeofday(&end,NULL);
        double elapsedTime; // calculating elapsedTime
        elapsedTime = (end.tv_sec - st.tv_sec) *1e6;     // sec to ms
        elapsedTime += (end.tv_usec - st.tv_usec);   // us to ms
        printf("Array after sorting: \n");
        for(int i=0; i<pow(2,n); i++) printf("%d ",arr[i]);
        printf("\n");
        printf("Time taken in Method-I: %lf Microseconds\n",elapsedTime);
        elapsedTime=0;
        gettimeofday(&s2,NULL);
        qsort((void*)arr2,pow(2,n),sizeof(int),cmp); // Normal quicksort time
        gettimeofday(&e2,NULL);
        elapsedTime = (e2.tv_sec - s2.tv_sec) *1e6;     // sec to ms
        elapsedTime += (e2.tv_usec - s2.tv_usec);   // us to ms
        printf("Time taken using sequential method: %d Microseconds\n",(int)elapsedTime);
    return 0;
}