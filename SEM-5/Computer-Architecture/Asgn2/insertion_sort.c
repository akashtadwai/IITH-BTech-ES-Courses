#include<stdio.h>
#include<stdlib.h>
#include<time.h>

void swap (int *a, int *b) { // Function to swap two elements
    int temp = *a;
    *a = *b;
    *b = temp;
}

void print_arr(int arr[], int n) { // Driver function to print the array.
    for(int i=0; i<n; i++) printf("%d ",arr[i]);
    printf("\n");
}

void randomise(int arr[], int n) { // Implementation of Fisher-Yates Algorithm
    srand (time(NULL));
    for (int i = n - 1; i > 0; i--)  {
        // Pick a random index from 0 to i
        int j = rand() % (i + 1);
        // Swap arr[i] with the element
        // at random index
        swap(&arr[i], &arr[j]);
    }
}



int insertion_sort(int arr[],int n) { // Implementation of Insertion sort 
    int cnt=0;
    for(int i=1; i<n; i++) {
        int value=arr[i],key=i; // arr[0:i] is a sorted permutation of elements.
        while(key>0 && ++cnt && arr[key-1]>value) { // At each iteration shift elements so that a[0:i] becomes sorted
            arr[key]=arr[key-1];
            key=key-1;
        }
        arr[key]=value; // putting key in its correct position
    }
    return cnt;
}


int main() {
    int n,a,r;
    printf("Please enter n, a , r \n");
    scanf("%d%d%d",&n,&a,&r);
    int arr[n],b[n];
    arr[0]=a;
    for(int i=1; i<n; i++) arr[i]=arr[i-1]*r;
    for(int i=0; i<n; i++) b[i]=arr[n-i-1];
    printf("Array Sorted in Ascending order is...\n");
    print_arr(arr,n);
    printf("No. of comparisions to sort the array is : %d \n",insertion_sort(arr,n));
    printf("Array Sorted in Descending order is ...\n");
    print_arr(b,n);
    printf("No. of comparisions to sort the array is : %d \n",insertion_sort(b,n));
    randomise(arr,n);
    printf("Array after randomising is: \n");
    print_arr(arr,n);
    printf("No. of comparisions after Randomising to sort array is: %d \n",insertion_sort(arr,n));
    return 0;

}