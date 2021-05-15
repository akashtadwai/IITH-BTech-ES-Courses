#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
#include<math.h>
#include<sys/time.h>

int arr[(int)1e6];
int n,p,h;

struct args {
    int index;
    int merge_size;
};
typedef struct args args;

void merge(int l, int m, int r) { // standard merging procedure of merge sort
    int n1 = m - l + 1,n2 = r - m;
    int left[n1], right[n2];
    for (int i = 0; i < n1; i++)
        left[i] = arr[l + i];
    for (int j = 0; j < n2; j++)
        right[j] = arr[m + 1 + j];
    int i=0,j=0,k=l;
    while (i < n1 && j < n2) {
        if (left[i] <= right[j])
            arr[k++] = left[i++];
        else
            arr[k++] = right[j++];
    }
    while (i < n1)
        arr[k++] = left[i++];
    while (j < n2)
        arr[k++] = right[j++];
}


int cmp(const void *a, const void *b) { // compare function for quick sort
    return (*(int *)a - *(int *)b);
}

void* sort_workers(void* arg) { // Function to sort initial segments
    int th_part= *((int*)arg);
    int val = pow(2,n-p);
    int l= th_part*val,h=(th_part+1)*val-1;
    qsort((void*)(arr+l),h-l+1,sizeof(int),cmp);
}

void* merge_workers(void* arg) { // Function to merge segments 2 at a time
    int index = ((args*)arg)->index; // get index of threads
    int merge_size = ((args*)arg)->merge_size;
    int l = index*merge_size, r = l + merge_size - 1; // range of indices to be merged
    int mid = (l + r - 1)/2;
    merge(l, mid, r);
}

int main() {
    freopen("inp.txt","r",stdin); // Read from "inp.txt" and write to "output.txt"
    freopen("output.txt","w+",stdout);
        scanf("%d%d",&n,&p);
        struct timeval st,end;
        for(int i=0; i<(int)pow(2,n); i++) arr[i]=rand()%1000; // Initialising random array
        printf("Original Array is: \n");
        for(int i=0; i<pow(2,n); i++) printf("%d ",arr[i]);
        printf("\n");
        int num_workers=pow(2,p);
        gettimeofday(&st, NULL);
        pthread_t workers[num_workers];
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        for (int i = 0; i < num_workers ; i++) {
            int*th_num = malloc(sizeof(*th_num));
            *th_num=i;
            pthread_create(&workers[i], &attr, sort_workers, (void*)th_num); // creating threads
        }
        for (int i = 0; i < num_workers; i++)
            pthread_join(workers[i], NULL); // waiting for all threads to complete sorting their respective segments
        num_workers /= 2;
        int merge_size = 2*pow(2, n-p);
        while(num_workers) { // while no. of segments>1 merge segments
            for (int i = 0; i < num_workers ; i++) {
                args* th_num = malloc(sizeof(*th_num));
                th_num->index = i;
                th_num->merge_size = merge_size;
                pthread_create(&workers[i], &attr, merge_workers, (void*)th_num); // create new threads for merging
            }
            for (int i = 0; i < num_workers; i++)
                pthread_join(workers[i], NULL); // waiting for threads to merge
            num_workers /= 2;
            merge_size *= 2;
        }
        gettimeofday(&end, NULL);
        double elapsedTime; // elapsedTime for the whole process.
        elapsedTime = (end.tv_sec - st.tv_sec) *1e6;     // sec to ms
        elapsedTime += (end.tv_usec - st.tv_usec);   // us to ms
        printf("Array after sorting: \n");
        for(int i=0; i<pow(2,n); i++) printf("%d ",arr[i]);
        printf("\n");
        printf("Time taken in Method-II: %lf Microseconds",(double)(end.tv_sec-st.tv_sec)*1e6 + (end.tv_usec - st.tv_usec));
    return 0;
}