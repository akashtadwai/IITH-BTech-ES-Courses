"""
To run: python3 trustRank.py
"""

import numpy as np

__AUTHORS__ = [
    ("Vinta Reethu", "ES18BTECH11028"),
    ("Akash Tadwai", "ES18BTECH11019"),
    ("Chaitanya Janakie", "CS18BTECH11036"),
]


class TrustRank:
    def __init__(self, alpha, max_iters, maxer, L, nodes, nodes_dict, nodes_dict1):
        self.alpha = alpha
        self.max_iters = max_iters
        self.maxer = maxer
        self.L = L
        self.nodes = nodes
        self.outlinks = nodes_dict
        self.inlinks = nodes_dict1

    def getTrustedPages(self, sorted_pr_scores):
        trusted_pages = []
        num_trusted_pages = 0

        for i, j in sorted_pr_scores.items():
            if num_trusted_pages < self.L:
                trusted_pages.append(i)
                num_trusted_pages += 1
            else:
                break

        return trusted_pages

    def inversePageRank(self, U, dMatrix):
        # INVERSE PAGERANK ALGORITHM

        a = (1 - self.alpha) * dMatrix
        b = self.alpha * U
        count = 0
        s = dMatrix
        while count < self.max_iters:
            s = np.dot(b, s) + a
            count += 1

        # Generating corresponding ordering
        pr_score = {}
        for i in range(len(s)):
            pr_score[i] = s[i]

        sorted_pr_scores = {
            k: v
            for k, v in sorted(pr_score.items(), key=lambda item: item[1], reverse=True)
        }
        return sorted_pr_scores

    def trustRank(self):
        # Computing Transition Matrix
        T = np.zeros((self.maxer, self.maxer))
        for fromNode, lst_toNodes in self.outlinks.items():
            num_outlinks = len(lst_toNodes)
            frac = 1 / num_outlinks
            for toNode in lst_toNodes:
                T[toNode][fromNode] = frac

        # Computing Inverse Transition Matrix
        U = np.zeros((self.maxer, self.maxer))
        for toNode, lst_fromNodes in self.inlinks.items():
            num_inlinks = len(lst_fromNodes)
            frac = 1 / num_inlinks
            for fromNode in lst_fromNodes:
                U[fromNode][toNode] = frac

        # Computing static score distribution vector
        dMatrix = np.zeros(self.maxer)
        num_nodes = len(self.nodes)
        frac = 1 / num_nodes
        for i in range(1, self.maxer):
            if i in self.nodes:
                dMatrix[i] = frac

        # finding inverse pageRank scores
        sorted_pr_scores = self.inversePageRank(U, dMatrix)

        # Fetching trusted pages from sorted page rank scores
        trusted_pages = self.getTrustedPages(sorted_pr_scores)

        # Computing static score distribution vector
        dMatrix = np.zeros(self.maxer)
        c = 0
        for i in range(1, self.maxer):
            if i in trusted_pages and i in good_nodes:
                dMatrix[i] = 1
                c += 1

        # Normalising the d matrix
        if c != 0:
            frac = 1 / c
            for i in range(1, self.maxer):
                if dMatrix[i] == 1:
                    dMatrix[i] = frac

        # Computing TrustRank Scores
        a = (1 - self.alpha) * dMatrix
        b = self.alpha * T
        count = 0
        res = dMatrix
        while count < self.max_iters:
            res = np.dot(b, res) + a
            count += 1

        return res


if __name__ == "__main__":
    # Defining variables
    nodes = []  # list to store all the nodes
    nodes_dict = {}  # a dictionary where key is a node, and value is a list of outlinks
    nodes_dict1 = {}  # a dictionary where key is a node, and value is a list of inlinks
    maxer = 0
    max_iters = 20  # Number of biased PageRank iterations
    L = 3  # Size of Seed set/Limit of oracle invocations

    num_good_nodes = int(input("Enter number of good nodes: "))
    good_nodes = []
    for i in range(0, num_good_nodes):
        ele = int(input())
        good_nodes.append(ele)

    num_bad_nodes = int(input("Enter number of bad nodes: "))
    bad_nodes = []
    for i in range(0, num_bad_nodes):
        ele = int(input())
        bad_nodes.append(ele)

    alpha = float(input("Enter damping factor: "))  # decay factor

    # Reading the file and storing data to lists and dictionaries
    with open("sample_graph.txt", "r") as dataSet:
        for line in dataSet:
            line_values = line.split(" ")
            p = int(line_values[0])
            q = int(line_values[1])
            if maxer < p:
                maxer = p
            if maxer < q:
                maxer = q
            if p not in nodes_dict:  # outlinks
                nodes_dict[p] = [q]
            else:
                nodes_dict[p].append(q)
            if q not in nodes_dict1:  # inlinks
                nodes_dict1[q] = [p]
            else:
                nodes_dict1[q].append(p)
            if p not in nodes:
                nodes.append(p)
            if q not in nodes:
                nodes.append(q)

    maxer = maxer + 1

    tr = TrustRank(alpha, max_iters, maxer, L, nodes, nodes_dict, nodes_dict1)
    trust_scores = tr.trustRank()

    print("\nTrust scores of all the nodes are as follows: ")
    for i in trust_scores:
        print(i, end=" ")
    print("\n\n")
