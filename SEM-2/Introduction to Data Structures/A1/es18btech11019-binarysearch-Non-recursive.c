#include<stdio.h>
void Binary_search(int arr[],int n, int key){
  int start=0,end=n-1,i,count=0;
  while(start<=end){//exit condition for recursion
    int mid=start+(end-start)/2;// By writing like this we can avoid overflow bcoz, if we write (end+start) it may exceed the storage value of int data type.
    if(arr[mid]==key){
    printf("Found the element at index %d",mid);//0 based indexing
    count=1;
    break;//if element is found we can break out of the loop and end the searching process
  }
    else if(key<arr[mid])
    end=mid-1;
    else //only condition left is key>mid
     start=mid+1;
  }
  if(count==0)
  printf("The element is not found");
}
int main(void){
  int n,i,key;
  scanf("%d",&n);
  int arr[n];
  for(i=0;i<n;i++)
    scanf("%d",&arr[i]);//all the elements should be entered in ascending order
    printf("Enter the element you want to Search for\n");
    scanf("%d",&key);
    Binary_search(arr,n,key);
}
