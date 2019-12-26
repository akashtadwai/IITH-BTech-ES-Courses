#include<stdio.h>
void linear_search_recursive(int arr[],int start,int end, int key){
 if(end<start)//exit condition for recursion
 {
 printf("The element is Not Found");
 return;
 }
 if(arr[start]==key)
 printf("The element is found at index %d",start);//0 based indexing
 if(arr[end]==key)
 printf("The element is found at index %d",end);//0 based indexing
    else linear_search_recursive(arr,start+1,end-1,key);//recursive call
}
int main(void){
  int n,i,key;
  scanf("%d",&n);
  int arr[n];
  for(i=0;i<n;i++)
    scanf("%d",&arr[i]);
    printf("Enter the element you want to Search for\n");
    scanf("%d",&key);
    linear_search_recursive(arr,0,n-1,key);
}
