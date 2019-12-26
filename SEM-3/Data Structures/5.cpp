#include <bits/stdc++.h>
using namespace std;
#define ss second
#define ff first
#define int long long
#define ipair pair<int, int>
#define ip pair<int, ipair>
int ver;
int edges = 0;
typedef struct subset {
  int parent;
  int rank;
}subset;
class Disjoint_set { // Disjoint set class
public:
  int n;
  Disjoint_set(int n) { // constructor
    this->n = n;
  }
  int find(subset subsets[], int i) {
    // find root and make root as parent of i (path compression)
    if (subsets[i].parent != i)
      subsets[i].parent = find(subsets, subsets[i].parent);
    return subsets[i].parent;
  }
  void Union(subset subsets[], int x, int y) {
    int xroot = find(subsets, x);
    int yroot = find(subsets, y);
    // Attach smaller rank tree under root of high rank tree
    // (Union by Rank)
    if (subsets[xroot].rank < subsets[yroot].rank)
      subsets[xroot].parent = yroot;
    else if (subsets[xroot].rank > subsets[yroot].rank)
      subsets[yroot].parent = xroot;
    // If ranks are same, then make one as root and increment
    // its rank by one
    else {
      subsets[yroot].parent = xroot;
      subsets[xroot].rank++;
    }
  }
};

void kruskal(vector<ip> g, int ver) {
  subset *subsets = new subset[ver];//Make-set
  for (int v = 0; v < ver; ++v) {
    subsets[v].parent = v;
    subsets[v].rank = 0;
  }
  vector<ipair> v;//Using Vector<pair<int,pair<int,int>>> to store weighted graph
  int mst_wt = 0;
  int edgecnt = 0;
  sort(g.begin(), g.end());//Sort based on edge weights
  Disjoint_set DS(ver); // Make set
  int x, y;
  for (int i = 0; i < edges; i++) {
    x = g[i].ss.ff;
    y = g[i].ss.ss;
    if (DS.find(subsets, x) !=
        DS.find(subsets, y)) { // If both are not in same set then Union them
      edgecnt++;               // No. of edges in MST
      DS.Union(subsets, x, y);
      v.push_back({x, y});
      mst_wt += g[i].ff;
    }
  }
  if (edgecnt + 1 != ver) { // If no. of Edges in MST+1 != Total no. of vertices
                            // then Spanning tree is not possible
    cout << "MST is not possible !";
  } else { // Printing Spanning tree
    cout << "Weight of mst is " << mst_wt << endl;
    cout << "Elements Present in the MST are: ";
    for (auto i = v.begin(); i != v.end(); i++) {
      cout << "(" << i->first << "," << i->second << "), ";
    }
  }
  cout << endl;
}

int32_t main() {
  int u, v, w, i = 0;
  char S;
  cout << "Enter the no. of Vertices: ";
  cin >> ver;
  vector<ip> g;
  cout << "Enter the edges as given in the question\n";
  cout << "Press Character other than 'E' to stop input \n";
  while (1) {
    cin >> S;
    if (S != 'E')
      break;
    cin >> u >> v >> w;
    edges++;
    g.push_back({w, {u, v}});
  }
  kruskal(g, ver);
  return 0;
}

/*17
E 0 2 5
E 0 1 11
E 2 1 3
E 2 3 7
E 1 4 1
E 4 3 2
E 4 5 7
E 3 5 3
E 6 7 7
E 6 8 11
E 7 8 5
E 7 9 5
E 8 9 3
E 8 10 5
E 16 11 5
E 16 14 3
E 11 12 11
E 11 15 7
E 12 13 5
*/
