#include<stdio.h>
void merge(int arr[],int low,int mid,int high)/*A function that merges two sorted sub arrays*/
{
    int i,j,k;
    int n1=mid-low+1;
    int n2=high-mid;
    int L[n1],R[n2];/*Creating two temporary arrays*/
    for(i=0;i<n1;i++)
    L[i]=arr[low+i];/*copying data to temporary arrays*/
    for(j=0;j<n2;j++)
    R[j]=arr[mid+j+1];
    i=0;/*Initial index of the first subarray*/
    j=0;/*Initial index of the second subarray*/
    k=low;/*Initial index of the merged array*/
    while(i<n1&&j<n2)/*Merging temporary arrays back into original array*/
    {
        if(L[i]<=R[j])
        {
            arr[k]=L[i];
            i++;
        }
        else
        {
            arr[k]=R[j];
            j++;
        }
        k++;
    }
    while(i<n1)/*copying the remaining elements of left array if there are any.*/
    {
        arr[k]=L[i];
        i++;
        k++;
    }
    while(j<n2)/*copying the remaining elements of right array if there are any.*/
    {
        arr[k]=R[j];
        j++;
        k++;
    }

}
void mergesort(int arr[],int low,int high)/*low is the left index and high is the right index of the array*/
{/*Divide and conquer paradigm*/
    if(low<high)/*Exit call for recursion*/
    {
        int mid=low+(high-low)/2;//to avoid overflow of adding two numbers we are writing like this
        mergesort(arr,low,mid);/*sorting up to mid*/
        mergesort(arr,mid+1,high);/*sorting after mid element of array*/
        merge(arr,low,mid,high);/*merging the sorted halfs*/

    }
}
int main()
{
    int n,i;
    scanf("%d",&n);/*Taking the input of user that how many numbers should be sorted*/
    int arr[n];
    for(i=0;i<n;i++)
    scanf("%d",&arr[i]);/*scanning all the elements to an array of integers*/
    mergesort(arr,0,n-1);/* Making a call for mergesort function*/
    for(i=0;i<n;i++)
    printf("%d\n",arr[i]);/*printing the sorted list of numbers*/
}
