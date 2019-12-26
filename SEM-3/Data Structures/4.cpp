#include <bits/stdc++.h>
using namespace std;
typedef struct Graph { // Storing Graph as Array of Lists
  int v;
  int w;
  Graph *nei; // Pointer to Elements in Adjacency list
} Graph;
void BFS(Graph *arr, bool vis[],
         int v) { // BFS over a vertex v to print all connected components
  Graph *temp = NULL;
  list<int> queue; // creating queue for BFS
  vis[v] = true;
  queue.push_back(v); // Marking current as visited and push to queue
  while (!queue.empty()) {
    v = queue.front();
    queue.pop_front();
    temp = &arr[v];
    temp = temp->nei;
    while (temp != NULL) {
      if (!vis[temp->v]) { // If vertices in adjacent list of temp are not
                           // visited then enqueue them to queue
        vis[temp->v] = true;
        queue.push_back(temp->v);
      }
      temp = temp->nei; // Traversing list
    }
  }
}

void add_edge(Graph *adj, int v1, int v2, int wt, bool flag) {
  Graph *temp = NULL;
  Graph *temp1 = new Graph();
  temp = &adj[v1];
  while (temp->nei !=
         NULL) // Go to the respective vertex and add vertex to its list
    temp = temp->nei;
  temp1->w = wt;
  temp1->v = v2;
  temp->nei = temp1;
  if (flag == false) { // Adding only if we want to create a undirected graph
    Graph *temp2 = new Graph();
    temp = &adj[v2];
    while (temp->nei != NULL)
      temp = temp->nei;
    temp2->v = v1;
    temp2->w = wt;
    temp->nei = temp2;
  }
}
void connected_components(Graph *adj, int V) {
  int cnt = 0;
  bool vis[V] = {false};
  bool flag[V];
  for (int v = 0; v < V; v++) {
    if (vis[v] == false) {
      cnt++;
      for (int i = 0; i < V; i++)
        flag[i] = vis[i];
      BFS(adj, vis, v);
      for (int i = 0; i < V; i++) { // Printing the vertices which have now
                                    // visited as these vertices are
        if (vis[i] != flag[i]) // all newly found and form a connected graph
          cout << i << " ";
      }
      cout << endl;
    }
  }
  cout << cnt << " components" << endl;
}

int dist(int dis[], int v, bool short_set[]) {
  int min = INT_MAX, index; // Initialising min value
  for (int i = 0; i < v; i++) {
    if (short_set[i] == false and dis[i] <= min) {
      min = dis[i];
      index = i;
    }
  }
  return index;
}

void Dijkstra(int *g, int v, int src, int reach[]) {
  int dis[v]; // dis[i] will hold shortest distance from src to i
  bool short_path[v];
  for (int i = 0; i < v; i++) {
    dis[i] = INT_MAX;
    short_path[i] = false;
  }
  dis[src] = 0;
  // Find shortest path for all vertices
  for (int cnt = 0; cnt < v - 1; cnt++) {
    int vertex = dist(dis, v, short_path);
    short_path[vertex] = true;    // Mark picked vertex as processed
    for (int i = 0; i < v; i++) { // Relaxing vertices
      if (!short_path[i] and *((g + vertex * v) + i) and
          dis[vertex] != INT_MAX and
          dis[vertex] + *((g + vertex * v) + i) < dis[i])
        dis[i] = dis[vertex] + *((g + vertex * v) + i);
    }
  }
  for (int i = 0; i < v; i++)
    printf("%d %d %d\n", reach[src], reach[i], dis[i]); // printing results
}

void shortest_path(int ver, int src, Graph *directed, int *g) {
  bool vis[ver] = {false};
  int cnt = 0;
  BFS(directed, vis, src);
  for (int i = 0; i < ver; i++)
    if (vis[i] == true)
      cnt++;
  int reach[cnt]; // Reachable vertices from src
  cnt = 0;
  for (int i = 0; i < ver; i++) {
    if (vis[i] == true) {
      reach[cnt++] = i; // Storing all reachable vertices in array
      if (src == i)     // Properly indexing the src
        src = cnt - 1;
    }
  }
  int req_g[cnt][cnt] = {{0}};
  for (int i = 0; i < cnt; i++)
    for (int j = 0; j < cnt; j++)
      req_g[i][j] = *((g + reach[i] * ver) +
                      reach[j]); // adjacency matrix with original weights

  Dijkstra((int *)req_g, cnt, src, reach);
}

int main() {
  int ver;
  cout << "Enter the no. of vertices in the graph: ";
  cin >> ver;
  Graph adj[ver], directed[ver];
  for (int i = 0; i < ver; i++) { // Graph initialisation
    adj[i].v = i;
    adj[i].w = 0;
    adj[i].nei = NULL;
    directed[i].v = i;
    directed[i].w = 0;
    directed[i].nei = NULL;
  }
  cout << "Enter input as provided in question\n";
  char ch;
  int u, v, wt;
  int g[ver][ver] = {{0}};
  cout << "Enter '?' to finish : ";
  while (1) {
    cin >> ch;
    switch (ch) {
    case 'E':
      cin >> u >> v >> wt;
      add_edge(adj, u, v, wt, false);
      add_edge(directed, u, v, wt, true);
      g[u][v] = wt;
      break;
    case 'F':
      connected_components(adj, v);
      break;
    case 'S':
      cin >> ch;
      cin >> u;
      if (u < 0 or u >= ver) {
        cout << "Please provide valid source point\n";
      } else
        shortest_path(ver, u, directed, (int *)g);
      break;
    case '?':
      return 0;
    default:
      break;
    }
  }
  return 0;
}