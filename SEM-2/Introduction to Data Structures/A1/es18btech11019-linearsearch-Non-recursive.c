#include<stdio.h>
void linear_search(int arr[], int n, int key){
  int i,count=0;
  for(i=0;i<n;i++){
    if(arr[i]==key){//searching element one by one and scanning the whole array
      printf("The element is Found at index %d",i);//0 based indexing
      count=1;
      break;//if element is found we can break out of the loop and end the searching process
    }
  }
  if(count==0)
  printf("The element is Not Found");
}
int main(void){
  int n,i,key;
  scanf("%d",&n);
  int arr[n];
  for(i=0;i<n;i++)
  scanf("%d",&arr[i]);
  printf("What is the element to search for?\n");
  scanf("%d",&key);
  linear_search(arr,n,key);
}
