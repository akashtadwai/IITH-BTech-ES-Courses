#include<stdio.h>

void print(int * arr, int m, int n) {//Function to print a 2-D matrix
    int i, j;
    for (i = 0; i < m; ++i) {
        for (j = 0; j < n; ++j)
            printf("%d ", *((arr + i * n) + j)); /* *((arr + i * n) + j) points to a[i][j]*/
        printf("\n");
    }
}
void cofactor(int n, int A[n][n], int temp[n][n], int p, int q) {
    int i = 0, j = 0;
    for (int row = 0; row < n; ++row) {
        for (int col = 0; col < n; ++col) {
            //  Copying into temporary matrix only those element
            //  which are not in given row and coloumn (defn of cofactor)
            if (row != p && col != q) {
                temp[i][j++] = A[row][col];
                // Row is filled, so increase row index and reset col index
                if (j == n - 1) {
                    j = 0;
                    i++;
                }
            }
        }
    }
}
int determinant(int n, int A[n][n]) {//Recursive function to find det of a matrix
    int D = 0;
    //  Base case : if matrix contains single element
    if (n == 1)
        return A[0][0];
    int temp[n][n]; // To store cofactors
    int flag = 1; // To store sign
    // Iterate for each element of first row (defn of determinant)
    for (int k = 0; k < n; ++k) {
        // Getting Cofactor of A[0][k]
        cofactor(n, A, temp, 0, k);
        D += flag * A[0][k] * determinant(n - 1, temp);
        // terms are to be added with alternate sign
        flag = -flag;
    }
    return D;
}
void adjoint(int N, int A[N][N], int adj[N][N]) {
    if (N == 1) { //Adjoint of a single element matrix is itself
        adj[0][0] = 1;
        return;
    }
    // temp is used to store cofactors of A[][]
    int sign = 1, temp[N][N];
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            // Get cofactor of A[i][j]
            cofactor(N, A, temp, i, j);
            // sign of adj[j][i] positive if sum of row and column indexes is even.
            sign = ((i + j) % 2 == 0) ? 1 : -1;
            // Interchanging rows and columns to get the transpose of the cofactor matrix
            adj[j][i] = (sign) * (determinant(N - 1, temp));
        }
    }
}
void inverse(int N, int A[N][N], float inverse[N][N]) {
    // Find determinant of A[][]
    int det = determinant(N, A);
    if (det == 0) {
        printf("Singular matrix, the inverse of the matrix is not possible \n");
        return;
    }
    // Find adjoint
    int adj[N][N];
    adjoint(N, A, adj);
    // Find Inverse using formula "inverse(A) = adj(A)/det(A)"
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            inverse[i][j] = adj[i][j] / (float)(det);
    printf("Inverse Matrix of C: \n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            printf("%g ", inverse[i][j]);
        printf("\n");
    }
}

void multiply(int * A, int m, int n, int * B, int p, int q) {
    int res[m][q], i, j, k;
    float inv[m][m];
    // Initializing all elements of result matrix to 0
    for (i = 0; i < m; ++i)
        for (j = 0; j < q; ++j)
            res[i][j] = 0;
    // Multiplying matrices a and b and
    // storing result in res matrix
    for (i = 0; i < m; ++i)
        for (j = 0; j < q; ++j)
            for (k = 0; k < n; ++k)
                res[i][j] += ( * ((A + i * n) + k)) * ( * ((B + k * q) + j));//Accessing 2-D matrix by pointers
    printf("Multiplication Matrix C[%d][%d]: \n", m, q);
    print((int * ) res, m, q);
    if (m != q) printf("The inverse is not possible \n");
    else inverse(m, res, inv);
}
int main() {
    int m, n, p, q, i, j, k;
    while (1) {
        printf("Enter the Order of matrix A: \n");
        scanf("%d %d", & m, & n);
        printf("Enter the Order of matrix B: \n");
        scanf("%d %d", & p, & q);
        if (n == p && m>1 && n>1 && p>1 && q>1) break;
        else printf("Error: Enter the orders again: \n");
    }
    int A[m][n], B[p][q];
    printf("Enter elements of matrix A[%d][%d]: \n", m, n);
    for (i = 0; i < m; ++i)
        for (j = 0; j < n; ++j)
            scanf("%d", & A[i][j]);
    printf("Enter elements of matrix B[%d][%d]: \n", p, q);
    for (i = 0; i < p; ++i)
        for (j = 0; j < q; ++j)
            scanf("%d", & B[i][j]);
    multiply((int * ) A, m, n, (int * ) B, p, q);
}