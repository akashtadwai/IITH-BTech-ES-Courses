import random
import argparse


def random_adjacency_matrix(n):
    matrix = [[random.uniform(0, 1) for _ in range(n)] for _ in range(n)]

    for i in range(n):
        for j in range(n):
            if matrix[i][j] >= 0.5:
                matrix[i][j] = 1
            else:
                matrix[i][j] = 0
    # No vertex connects to itself
    for i in range(n):
        matrix[i][i] = 0

    # If i is connected to j, j is connected to i
    for i in range(n):
        for j in range(n):
            matrix[j][i] = matrix[i][j]

    return matrix


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('--threads', type=int,
                        help='No. of Threads',default=2)  # no. of threads
    parser.add_argument('--vertices', type=int,
                        help='No. of vertices for graph',default=5)  # vertices
    args = parser.parse_args()
    file1 = open("input_params.txt", "w+")
    graph = random_adjacency_matrix(args.vertices)

    file1.write("%d %d\n" % (args.threads, args.vertices))
    for line in graph:
        file1.writelines(["%s " % item for item in line])
        file1.write("\n")
