#include <iostream>
#include <iomanip>
#include <vector>
#include <set>
#include <algorithm>
#include <list>
#include <chrono>
#include <random>
#include <pthread.h>
#include <time.h>
#include <unistd.h>
#include <random>
using namespace std;
#define endl "\n"
#define all(x) x.begin(), x.end()
#define IOS                           \
    std::ios::sync_with_stdio(false); \
    cin.tie(NULL);

#define COARSE 1 // uncomment this for coarse grained locking
// #define FINE 1 // uncomment this for fine grained locking

#ifdef COARSE
pthread_mutex_t mutex_lock;
#endif

int numThreads, vertices;
typedef struct node
{
    int id;
    node *next;
} node;

typedef struct vertex
{
#ifdef FINE
    pthread_mutex_t lock;
#endif
    int vertexId;
    int partitionId;
    node *next;
    int color;
    bool boundaryVertex;
} vertex;

vector<vertex> g;
void printList()
{
    for (int v = 1; v <= vertices; v++)
    {
        if (g[v].next == NULL)
            continue;
        cout << g[v].vertexId << " ";
        for (auto ptr = g[v].next; ptr != NULL; ptr = ptr->next)
        {
            cout << ptr->id << " ";
        }
        cout << endl;
    }
}
void addEdge(node *&ptr, int vertex, int id) //adding edge in the graph
{
    if (g[vertex].next == NULL)
    {
        g[vertex].next = new node;
        ptr = g[vertex].next;
        ptr->id = id;
        ptr->next = NULL;
    }
    else
    {
        ptr = g[vertex].next;
        while (ptr->next)
        {
            if (ptr->id == id)
                break;
            ptr = ptr->next;
        }
        if (ptr->next == NULL and ptr->id != id)
        {
            ptr->next = new node;
            ptr = ptr->next;
            ptr->id = id;
            ptr->next = NULL;
        }
    }
}
void takeInput()
{
    node *ptr;
    for (int i = 1; i <= vertices; i++)
    {
        for (int j = 1; j <= vertices; j++)
        {
            int edge;
            cin >> edge;
            if (edge == 0)
                continue;
            addEdge(ptr, i, j);
            addEdge(ptr, j, i);
        }
    }
}

void greedyGraphColoring() // naive greedy graph coloring algorithm
{
    auto start = chrono::high_resolution_clock::now();
    vector<bool> colorsAvailable(vertices + 1, true);
    vector<int> result(vertices + 1, -1);
    result[1] = 1;
    for (int u = 2; u <= vertices; u++)
    {
        for (auto v = g[u].next; v != NULL; v = v->next)
        {
            if (result[v->id] != -1)
                colorsAvailable[result[v->id]] = false;
        }
        int firstAvailable;
        for (firstAvailable = 1; firstAvailable <= vertices; firstAvailable++)
            if (colorsAvailable[firstAvailable] == true)
                break;

        result[u] = firstAvailable;
        for (auto v = g[u].next; v != NULL; v = v->next)
        {
            if (result[v->id] != -1)
                colorsAvailable[result[v->id]] = true;
        }
    }
    auto end = chrono::high_resolution_clock::now();
    double time_taken =
        chrono::duration_cast<chrono::microseconds>(end - start).count();
    cout << "Greedy Graph Coloring without locks\n";
    for (int i = 1; i <= vertices; i++)
    {
        cout << "v" << i << " - " << result[i] << ((i != vertices) ? ", " : " ");
    }
    cout << endl;
    int colorsUsed = *max_element(all(result));
    cout << "Number of Colors Used: " << colorsUsed << endl;
    cout << "Time taken by program is : " << fixed << time_taken
         << setprecision(9) << " musec" << endl;
}

void *colorVertices(void *id)
{
    int tid = *((int *)id);
    list<vertex *> internal, boundary; // internal and boundary vertices
    int partition_id, temp_id;

    for (int i = 1; i <= vertices; i++)
    {
        partition_id = g[i].partitionId;
        if (partition_id == tid)
        {
            if (g[i].boundaryVertex == 0)
                internal.push_back(&g[i]);
            else
                boundary.push_back(&g[i]);
        }
    }
    list<int> temp, temp1;
    node *ptr;
    int thId, k;
    for (auto itr = internal.begin(); itr != internal.end(); itr++)
    {
        temp.clear();
        ptr = (*itr)->next;

        while (ptr) //Check the colors of adjacent vertices and assign a least possible color different from the adjacent vertices.
        {
            thId = ptr->id;
            if (g[thId].boundaryVertex == false)
            {
                if (g[thId].color != -1)
                    temp.push_back(g[thId].color);
            }
            ptr = ptr->next;
        }
        k = 1;
        for (auto t = temp.begin(); t != temp.end(); t++) //allocating color greedily
        {
            if (*t == k)
            {
                k++;
                t = temp.begin();
                continue;
            }
        }
        (*itr)->color = k;
    }

    // cout << "Colored Internal Vertices \n";

    for (auto itr = boundary.begin(); itr != boundary.end(); itr++)
    {
        temp.clear();

#ifdef COARSE
        pthread_mutex_lock(&mutex_lock);
#endif

#ifdef FINE
        temp1.clear();
        temp1.push_back((*itr)->vertexId);
        ptr = (*itr)->next;
        while (ptr)
        {
            temp_id = ptr->id;
            if (g[temp_id].boundaryVertex == true)
                temp1.push_back(temp_id); //to lock all adjacent boundary vertices
            ptr = ptr->next;
        }
        temp1.sort();

        for (auto t = temp1.begin(); t != temp1.end(); t++)
            pthread_mutex_lock(&g[*t].lock);
#endif

        ptr = (*itr)->next;

        //Check the colors of adjacent vertices and assign a least possible color different from the adjacent vertices.
        while (ptr)
        {
            temp_id = ptr->id;
            if (g[temp_id].color != -1)
                temp.push_back(g[temp_id].color);
            ptr = ptr->next;
        }
        k = 1;
        for (auto t = temp.begin(); t != temp.end(); t++) //coloring greedily
        {
            if (*t == k)
            {
                k++;
                t = temp.begin();
                continue;
            }
        }
        (*itr)->color = k;
        // cout << "DEBUG " << (*itr)->vertexId << " " << (*itr)->color << endl;

#ifdef COARSE
        pthread_mutex_unlock(&mutex_lock);
#endif

#ifdef FINE
        for (auto t = temp1.begin(); t != temp1.end(); t++)
            pthread_mutex_unlock(&g[*t].lock);
#endif
    }

    // cout<<"Boundary Coloring completed!!!\n";

    return NULL;
}

int main(int argc, char *argv[])
{
    IOS;
    freopen("input_params.txt", "r", stdin);
    freopen("Coloring-Log.txt", "w", stdout);
    cin >> numThreads >> vertices;
    g.resize(vertices + 1);
    for (int i = 1; i <= vertices; i++)
    {
        g[i].boundaryVertex = false;
        g[i].color = -1;
        g[i].next = NULL;
        g[i].vertexId = i;
        g[i].partitionId = -1;
    }

    takeInput();
    // printList();
#ifdef COARSE
    pthread_mutex_init(&mutex_lock, NULL);
#elif FINE
    for (int i = 1; i <= vertices; i++)
        pthread_mutex_init(&g[i].lock, NULL);
#endif

    for (int i = 1; i <= vertices; i++)
    {
        g[i].color = -1;
        g[i].partitionId = -1;
        g[i].boundaryVertex = false;
    }

    if (numThreads == 1)
    {
        for (int i = 1; i <= vertices; i++)
        {
            g[i].partitionId = 0;
            g[i].boundaryVertex = false;
        }
    }
    if (numThreads > 1)
    {
        int pId = 0;
        double vertexPartition = (1.0 * vertices) / numThreads;
        int numVerticesinPartition = floor(vertexPartition); // no of vertices in 1 partition
        srand(unsigned(std::time(0)));
        vector<int> perm;
        for (int i = 1; i <= vertices; i++)
            perm.push_back(i);
        random_shuffle(all(perm));
        auto idx = perm.begin();
        for (int i = 1; i < vertices; i += numVerticesinPartition)
        {
            for (int j = i; j < (i + numVerticesinPartition) and j <= vertices; j++)
            {
                g[*idx].partitionId = pId; // assign partitionIds for vertices
                ++idx;
            }
            pId++;
        }
        for (int i = 1; i <= vertices; i++)
            if (g[i].partitionId == -1)
                g[i].partitionId = rand() % numThreads; // assign remaining partitionIds

        for (int i = 1; i <= vertices; i++)
        {
            node *ptr = g[i].next;
            while (ptr != NULL)
            {
                int j = ptr->id;
                if (g[j].partitionId != g[i].partitionId)
                {
                    g[i].boundaryVertex = true; // boundary vertices
                    break;
                }
                ptr = ptr->next;
            }
        }
    }

#ifdef COARSE
    cout << "Coarse Locking" << endl;
#elif FINE
    cout << "Fine Locking" << endl;
#else
    greedyGraphColoring();
    return 0;
#endif

    pthread_t thr[numThreads];

    auto start = chrono::high_resolution_clock::now();
    for (int i = 0; i < numThreads; i++)
    {
        int *th_id = (int *)malloc(sizeof(int));
        *th_id = i;
        pthread_create(&thr[i], NULL, colorVertices, (void *)th_id);
    }

    for (int i = 0; i < numThreads; i++)
        pthread_join(thr[i], NULL);

    auto end = chrono::high_resolution_clock::now();
    double time_taken =
        chrono::duration_cast<chrono::microseconds>(end - start).count();
    cout << "Time taken by program is : " << fixed << time_taken
         << setprecision(9) << " musec" << endl;
    int numColors = -1;
    for (int i = 1; i <= vertices; i++)
    {
        if (g[i].color > numColors)
            numColors = g[i].color;
    }
    cout << "Number of Colors used: "
         << numColors << endl;
    cout << "Colors: \n";
    for (int i = 1; i <= vertices; i++)
    {
        cout << "v" << i << " - " << g[i].color << ((i == vertices) ? " " : ", ");
    }
    return 0;
}