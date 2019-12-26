#include <bits/stdc++.h>
using namespace std;
typedef struct Graph { // Storing Graph as Array of Lists
  int v;
  int w;
  Graph *nei; // Pointer to Elements in Adjacency list
} Graph;
int n;

void add_edge(Graph *adj, int v1, int v2, int wt) {
  Graph *temp = NULL;
  Graph *temp1 = new Graph();
  temp = &adj[v1];//Go to the respective vertex and add vertex to its list
  while (temp->nei != NULL)
    temp = temp->nei;
  temp1->w = wt;
  temp1->v = v2;
  temp->nei = temp1;
    Graph *temp2 = new Graph();//As it's a undirected vertex We should also add v to u's list
    temp = &adj[v2];
    while (temp->nei != NULL)
      temp = temp->nei;
    temp2->v = v1;
    temp2->w = wt;
    temp->nei = temp2;
}

void neighbours(Graph* adj, int p) {
  cout << "Neighbours to vertex " << p << " are : ";
  Graph* temp=&adj[p];
  for (temp=temp->nei;temp!=NULL;temp=temp->nei)
    cout << temp->v
         << " "; // Traversing adjacency list to print neighbours.
  cout << endl;
}
void vertices(int ver) {
  for (int i=0;i<ver;i++)
    cout << i << " "; // Function to print all vertices
  cout << endl;
}
int edgeweight(Graph* adj, int u, int v) {
  cout << "The edgeweight is: ";
  Graph* temp=NULL;
  for(temp=&adj[u];temp!=NULL;temp=temp->nei){//Check the adjacency list of u if v is present
      if(temp->v==v)    return temp->w;//If present return its weight
  }
  return -1;
}
bool containsvertex(int u,int ver) {
  cout << "contains vertex: ";
  if(u>=ver or u<=0)  return false;
   return true;
}
bool containsedge(Graph* adj, int v1, int v2) { //Check the adjacency list v1 if its present return true
  cout << "Graph contains edge: ";
  Graph *temp = NULL;
  for (temp = &adj[v1]; temp != NULL; temp = temp->nei)
    if (temp->v == v2) // Checking adjacency list of v1 if v2 is present
      return true;
  return false;
}
int main() {
  int ver,wt;
  cout << "Enter no. of vertices of the graph\n";
  cin >> ver;
  Graph* adj=new Graph[ver];
  int u, v, w, edges;
  cout << "Enter 'a' and a vertex to find Neighbours of that vertex\n";
  cout << "Enter 'b' to print all vertices\n";
  cout << "Enter 'E' and enter two vertices and weight to add edge to "
          "the graph\n";
  cout << "Enter 'c' and enter two vertices to find edge weight between "
          "them\n";
  cout << "Enter 'd' and enter a vertex to find whether that vertex "
          "exists in the graph\n";
  cout << "Enter 'e' and enter two vertices to find whether an edge "
          "exists between "
          "them\n";
  cout << "Enter '?' to stop the input sequence\n";

  char choice;
  while (cin >> choice) {
    if (choice == '?')
      break;
    switch (choice) {
    case 'E':
      cin >> u >> v >> w;
      add_edge(adj, u, v, w);
      break;
    case 'a': // neighbours
      cin >> u;
      neighbours(adj, u);
      break;
    case 'b':
      cout << "The vertices present in the graph are: ";
      vertices(ver);
      break;
    case 'c':
      cin >> u >> v;
       wt=edgeweight(adj, u, v);
      wt!=-1?cout<<wt<<endl:cout<<"There is no edge\n";
      break;
    case 'd':
      cin >> v;
      containsvertex(ver, v) == true
          ? cout << "The vertex " << v << " is present \n"
          : cout << "The vertex " << v << " is not present \n";
      break;
    case 'e':
      cin >> u >> v;
      containsedge(adj, u, v) == true
          ? cout << "There is an edge between " << u << " and " << v << "\n"
          : cout << "There is no edge between " << u << " and " << v << "\n";
      break;
    }
  }
  return 0;
}