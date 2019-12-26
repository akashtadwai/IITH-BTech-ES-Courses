#include <stdio.h>
int recursive_binary_search(int arr[], int start, int end, int key)
{
    if ( start<=end) {//exit condition for recursion
        int mid = start + (end - start) / 2; ;// By writing like this we can avoid overflow bcoz, if we write (end+start) it may exceed the storage value of int data type
        // If the element is present at the middle itself
        if (arr[mid] == key)
            return mid;
        // If element is smaller than mid, then it can only be present in left subarray
        if (arr[mid] > key)
        return recursive_binary_search(arr, start, mid - 1, key);
        // else the element can only be present in right subarray
        return recursive_binary_search(arr, mid + 1, end, key);
    }
 //when the element is not present in the array we return -1
    return -1;
}

int main(void)
{
    int n,i,key;
  scanf("%d",&n);
  int arr[n];
  for(i=0;i<n;i++)
    scanf("%d",&arr[i]);//all the elements should be entered in ascending order
    printf("Enter the element you want to Search for\n");
    scanf("%d",&key);
    int result = recursive_binary_search(arr, 0, n - 1, key);
    if(result==-1)
    printf("Element is not present in array");
    else printf("Element is present at index %d",result);//its 0-index based search

}
