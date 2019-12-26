#include<stdio.h>
int i=0;
int arr[100];
void insertion_sort( int n)/* In this we are inserting all the elements into sorted subset one by one*/
{
    int hole,value,j;
    for(j=1;j<n;j++)
    {
        value=arr[j];/*For each iteration we are storing the element at that iteration in a variable
        and making a hole there.*/
        hole=j;
        while(hole>0&&arr[hole-1]>value)/*If the elements to the left of hole are greater than that of the element
        at hole we are moving the place of elements and continuing this process till hole>0 */
        {
            arr[hole]=arr[hole-1];

            hole=hole-1;
        }
        arr[hole]=value;/*Finally we are keeping the element at its correct position*/
    }
}
void storeNextVehicleID(int ID,int n){
  arr[i]=ID;
  insertion_sort(i+1);//we are sorting the array so that at any time we can check the element easily
  for(int j=0;j<=i;j++)
    printf("%d ",arr[j]);
  i++;
}
int main(){
  int t=100,n=100,key;
  while(t--){
    int id;
    scanf("%d",&id);
    if(id<0){
      printf("\n The day has ended!");
    break;//as if the id is negative the day has come to end
    }
    else
    storeNextVehicleID(id,n);
  }
  return 0;
}
