#include <bits/stdc++.h>
using namespace std;

class Linkedlist {
private:
  typedef struct node {
    char val;
    node *next, *prev; // Node contains pointers to next node and previous node
                       // hence a doubly linkedlist
  } node;
  node *head = nullptr, *tail = nullptr;
  void Delete() {//Function to clear whole linkedlist
    node *temp = head;
    while (head) {
      head = head->next;
      delete temp;
      temp = head;
    }
    head=tail=NULL;
  }

public:
  Linkedlist() {}              // constructor
  ~Linkedlist() { Delete(); }  // Destructor
  void insert_at_end(char x) { // Inserting new value at tail of linkedlist
    node *p = new node;
    p->val = x;
    if (tail == NULL) {
      p->prev = p->next = NULL;
      head = tail = p;
    } else {//traversing and inserting at end
      tail->next = p;
      p->next = NULL;
      p->prev = tail;
      tail = p;
      tail->next = NULL;
    }
  }
  void Store() { // Function to print Head and Tail of linkedlist
  if(head==NULL){
    cout<<"The string is empty!\n";
    return;
  }
    cout << head->val << " " << tail->val << endl;
  }
  void Print() {
    if (head == NULL) {
      cout << "The string is empty!\n";
      return;
    }
    node *p;
    int cnt[26] = {0};//Counting freq of each character in input string
    for (p = head; p != NULL; p = p->next) {
      if (p->val >= 97) {
        cnt[p->val - 97]++;
      } else
        cnt[p->val - 65]++;
    }

    for (int i = 0; i < 26; i++) {
      if (cnt[i] != 0) { //Printing each valid character's frequency
        printf("%c %d ", i + 65, cnt[i]);
      }
    }
    cout << endl;
  }

  void Remove(int T) { // Function to remove nodes from a linkedlist if it is
                       // present more than 'T' times
    if (head == NULL) {
      cout << "The string is empty!\n";
      return;
    }
    if(T==0){
      Delete();
      cout<<"The string is empty!\n";
      return;
    }
    node *curr = head;
    int cnt;
    while (curr != tail) {
      if (curr == head)
        cnt = 1;
      else if (curr->val != curr->prev->val)
        cnt = 1;
      else {
        cnt++;
        if (cnt > T) { // If cnt is greater than 'T' then Remove that node
          node *p = curr;
          p->prev->next = p->next;
          p->next->prev = p->prev;
          free(p);
        }
      }
      curr = curr->next;
    }
    node *q = tail;
    if (q->val == q->prev->val) { // Corner case of last node, if it is same as
                                  // last second node then delete last node
      q->prev->next = NULL;
      tail = q->prev;
      free(q);
    }
    printlist(); // Function to print a linkedlist
  }
  void Sort() { // Sorts characters in linkedlist based on no. of duplicates
    if (head == NULL) {
      cout << "The string is empty!\n";
      return;
    }
    node *p = head;
    map<char, int> mp;
    vector<pair<int, char> > v;
    for (p = head; p != NULL; p = p->next)
      mp[p->val]++; // Finding frequency of each character by using a 'map'
                    // container
    for (auto it = mp.begin(); it != mp.end(); ++it)
      v.push_back({it->second, it->first}); //
    sort(v.begin(), v.end()); // sorting based on frequency of each character
    reverse(v.begin(),
            v.end()); // Reversing so that Frequency is in descending order
    for (auto it = v.begin(); it != v.end(); ++it) {
      cout << it->second; // Printing characters.
    }
    cout << endl;
  }
  void printlist() { // Function to print whole list
    node *p = head;
    for (p = head; p != NULL; p = p->next)
      cout << p->val;
    cout << endl;
  }
};
int main() {
  Linkedlist l; // Creating an Object
  int i = 0;
  string s;
  cout << "Please enter the string:";
  cin >> s;
  for (int i = 0; i < s.size(); i++)
    l.insert_at_end(s[i]); // Inserting each character into a linkedlist.
  string q;
  cout << "Please Enter 'Store' or Remove' or 'Print' or 'Ascend' to do the "
          "respective operation\n";
  cout << "Please enter '?' to terminate the input \n";
  while (cin>>q) {
     if (q[0] == '?') break;
    switch (q[0]) {
    case 'S':
    if(q=="Store"){
      if (s.size() == 0)
        cout << "Empyty string!\n";
      else
        l.Store();
    }
    else cout<<"Enter a Valid Functionality input!\n";
     
      break;
    case 'P':
    if(q=="Print")
      l.Print();
    else
      cout << "Enter a Valid Functionality input!\n";
    break;
    case 'A':
    if(q=="Ascend")
      l.Sort();
    else cout << "Enter a Valid Functionality input!\n";
    break;
    case 'R':
      int a;
      cin >> a;
      l.Remove(a);
      break;
    }
  }
  return 0;
}