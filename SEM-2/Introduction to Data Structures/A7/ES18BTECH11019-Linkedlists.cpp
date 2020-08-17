#include<bits/stdc++.h>
using namespace std;
struct Node{
  int data;
  struct Node* next;
};
struct Node* head;
void insert(int data){
  struct Node* temp = (struct Node*)malloc(sizeof(struct Node));//dynamic memory allocation of new node
   struct Node*temp2=head;
   temp->data=data;
    temp->next=NULL;
   if(head==NULL){//when linkedlist is empty
       head=temp;
       return;  
   }
  while((temp2->next) != NULL)//appending the node at last and building links between nodes
  temp2=temp2->next;

 temp2->next=temp;
}
void smallest(){
  struct Node*temp2=head;
  int smallest=temp2->data;
  while(temp2!=NULL){
    if(temp2->next!=NULL){//if last node is not the minimum i.e checking for all nodes except last node
    smallest=min(temp2->data,smallest);//min returns the minimum value b/w two numbers
    temp2=temp2->next;//traversing the list
  }
  else
    smallest=min(smallest,temp2->data);//comparing and finding the minimum
    temp2=temp2->next;//traversing the list
}
cout<<smallest<<endl;

}
void Firstgreatestnum(){
  float mean=0; int count=0;
  struct Node*temp2=head;
  while(temp2!=NULL){
    count++;//counting no. of nodes in linkedlist
    mean+=temp2->data;
    temp2=temp2->next;
  }
  mean/=count;//mean of all values in the linkedlist
  struct Node*temp3=head;
  while(temp3!=NULL){
    if((temp3->data) > mean){//if the value of node is greater than mean we print that value and break
    cout<<temp3->data;
    break;
    }
    temp3=temp3->next;//traversing the list
  }
}

int main(){
head=NULL;
while (1) {
      int data;
      cin>>data;
      if(data>0)
      {
        insert(data);
      }
      else {
        break;
      }
  }
smallest();
Firstgreatestnum();
}
