"""
To run: python3 spectralClustering.py
"""


import matplotlib.pyplot as plt  # imports
import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.preprocessing import normalize

__AUTHORS__ = [
    ("Vinta Reethu", "ES18BTECH11028"),
    ("Akash Tadwai", "ES18BTECH11019"),
    ("Chaitanya Janakie", "CS18BTECH11036"),
]


class SpecturalClustering:
    """Constructor for SpecturalClustering

    :param sigma: value of sigma.

    :param K: number of clusters.
    """

    def __init__(self, sigma, K):
        self.sigma = sigma
        self.K = K

    def normal_distribution(self, x, y):
        """return the normal value for given inputs"""
        return np.exp(-1 * (np.linalg.norm(x - y) ** 2)) / (
            2 * (self.sigma ** 2)
        )  # e^-(x-y)^2/2*sigma^2

    def make_undirected_graph(self, adj_matrix):
        """given a graph in form of adjacency matrix it returns undirected graph in adjacency matrix format"""

        for i in range(len(adj_matrix)):
            for j in range(len(adj_matrix[0])):
                if adj_matrix[i][j]:
                    adj_matrix[j][i] = adj_matrix[i][j]  # Undirected

        return adj_matrix

    def gaussian_similarity(self, X):
        """From the given dataset graph is built"""
        length = len(X)
        adj_matrix = np.zeros((length, length))  # Creating adjacency matrix

        for i, x in enumerate(X):
            for j, y in enumerate(X):
                if i == j:
                    adj_matrix[i][j] = 0
                else:
                    adj_matrix[i][j] = self.normal_distribution(
                        x, y
                    )  # Node value computation

        for i in range(length):
            index = np.argsort(-adj_matrix[i])

            for j in range(length):
                if index[j] > self.K:
                    adj_matrix[i][j] = 0

        # Returning the undirected graph
        return self.make_undirected_graph(adj_matrix)

    def laplacian(self, adj_matrix):
        """for the given matrix, laplacian of it is returned"""
        D = np.diag(adj_matrix.sum(axis=1))
        D_sqrt_inverse = np.sqrt(np.linalg.inv(D))  # sqrt(D^-1)
        laplacian = (
            D_sqrt_inverse @ (D - adj_matrix)
        ) @ D_sqrt_inverse  # sqrt(D^-1) * (D - matrix) * sqrt(D^-1)

        return laplacian

    def eigen_values_and_vectors(self, adj_matrix):
        """computes eigen values, eigen vectors for the given adjacency matrix"""
        laplacian = self.laplacian(adj_matrix)

        eigenvals, eigenvecs = np.linalg.eig(laplacian)

        eigenvecs = eigenvecs[:, np.argsort(eigenvals)]
        eigenvals = eigenvals[np.argsort(eigenvals)]
        print(f"Eigen Values are {eigenvals}")

        # Plotting the obtained eigen values with K
        self.plot_eigen_values(eigenvals)
        return eigenvals, eigenvecs

    def plot_eigen_values(self, eigenvals):
        """plots the graph for the given eigen values"""
        plt.ylabel("Eigen Values")
        plt.xlabel("K Values")
        plt.plot(eigenvals.tolist(), linestyle="--", marker="x", color="r")
        plt.show()

    def KMeans(self, clusters, eigenvecs):
        """fits KMeans model for the given K, eigen vector values"""
        kmeans = KMeans(n_clusters=clusters)
        kmeans.fit(eigenvecs[:, 1:clusters])

        return kmeans.labels_  # returns the k labels for the fitted model

    def clustering(self, eigenvals, eigenvecs):
        """fits the eigen values, eigen vectors to find the number of clusters"""
        clusters = -1
        maximum_difference = 0

        for i in range(1, len(eigenvals) - 1):
            if (
                eigenvals[i + 1] - eigenvals[i] > maximum_difference
            ):  # Update if maximum difference is less than the current difference
                maximum_difference = eigenvals[i + 1] - eigenvals[i]
                clusters = i + 1

        print(f"Number of clusters are {clusters}")

        colors = self.KMeans(clusters, eigenvecs)  # Fitting the KMeans model

        classes = [0 for i in range(clusters)]

        for i in colors:
            classes[i] += 1

        print(f"Number of samples in {clusters} clusters are:")
        # Here the class with least number of points in the cluster is most probably
        # the fraudlent cluster

        for i in range(len(classes) - 1, -1, -1):
            print(f"Cluster {i}: {classes[i]}")


if __name__ == "__main__":
    dataset = pd.read_csv("spec.csv")  # Loading dataset
    X = normalize(dataset.to_numpy())  # Normalising the input
    sigma = 1
    K = 8
    specturalClustering = SpecturalClustering(sigma, K)  # Declaring the function
    adj_matrix = specturalClustering.gaussian_similarity(
        X
    )  # Finding the graph for the given input
    eigenvals, eigenvecs = specturalClustering.eigen_values_and_vectors(
        adj_matrix
    )  # Computing eigen values, vectors for the graph
    specturalClustering.clustering(
        eigenvals, eigenvecs
    )  # Fitting the clustering algorithm for the matrix
