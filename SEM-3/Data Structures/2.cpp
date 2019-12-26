#include <bits/stdc++.h>
using namespace std;
typedef struct node { //Node to store Left child, Right Child and parent.
  int val;
  struct node *left, *right, *parent;
} node;
node *root = NULL;
node *newNode(int key) { //Building a new node
  node *ptr = new node;
  ptr->val = key;
  ptr->parent = ptr->left = ptr->right = NULL;
  return ptr;
}
node *search(node *root, int key) {//Seafching for a key in  a linkedlist
  if (root == NULL or root->val == key)
    return root;
  if (key > root->val) {
    root = root->right;
    return search(root, key);
  } else {
    root = root->left;
    return search(root, key);
  }
}

node *insert(node *root, int key) { //Inserting a node into a linkedlist
  if (root == NULL)
    return newNode(key);
  if (key < root->val) {
    node *leftchild = insert(root->left, key);
    root->left = leftchild;
    leftchild->parent = root;//Updating Parent pointer
  } else if (key > root->val) {
    node *rightchild = insert(root->right, key);
    root->right = rightchild;
    rightchild->parent = root;//Updating parent pointer
  }
  return root;
}
node *min(node *root) {//Function to find min value in a tree
  node *current = root;
  while (current->left != NULL)
    current = current->left;
  return current;
}
node *max(node *root) {//Function to find max value in a tree
  node *current = root;
  while (current->right != NULL)
    current = current->right;
  return current;
}

node *successor(node *n) {//Function to find successor of a node in a tree
  if (n->right != NULL)
    return min(n->right);
  node *succ = n->parent;
  while (succ != NULL and n == succ->right) {//If right subtree is empty traverse up
    n = succ;
    succ = succ->parent;
  }
  return succ;
}
node *predecessor(node *n) { // Function to find predecessor of a node in a tree
  if (n->left != NULL)
    return max(n->left);
  node *pred = n->parent;
  while (pred != NULL and
         n == pred->left) { // If left subtree is empty traverse up
    n = pred;
    pred = pred->parent;
  }
  return pred;
}
node *lca(node *root, int a, int b) { //LCA for two nodes having values a and b
  while (root != NULL) {
    if (root->val > a and root->val > b)
      root = root->left;
    else if (root->val < a and root->val < b)
      root = root->right;
    else
      break;
  }
  return root;
}
int main() {
  int k, l;
  char c;
  node *temp;
  char sel;
  cout<<"Please Provide input and functionality input as given in the question and '?' to stop the input sequence\n";
  while (scanf("%d%c", &k, &c)) {
    root = insert(root, k);
    if (c == '\n')
      break;
  }
  while (cin >> sel) {
    if(sel=='?') break;
    switch (sel) {
    case 'M':
      cin >> k;
      temp = search(root, k);
      cout << min(temp)->val << " " << max(temp)->val << endl;
      break;
    case 'P':
      cin >> k;
      temp = search(root, k);
      cout << predecessor(temp)->val << endl;
      break;
    case 'S':
      cin >> k;
      temp = search(root, k);
      cout << successor(temp)->val << endl;
      break;
    case 'C':
      cin >> k >> l;
      if (search(root, k) == NULL or search(root, l) == NULL) {
        cout << "Elements Not found" << endl;
        break;
      } else
        cout << lca(root, k, l)->val << endl;
      break;
    }
  }
  return 0;
}