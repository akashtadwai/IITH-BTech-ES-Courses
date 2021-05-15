"""
 Date: 01-05-2021
 Assignment - 2
 Author(s): Akash Tadwai - ES18BTECH11019
            Vinta Reethu - ES18BTECH11028
"""
#  Assumptions
#  1. Non-degenerate
#  2. Rank of matrix is equal to the number of columns
#  3. Initial feasible point is given

import numpy as np
import sys
import traceback
from typing import Union, Tuple
import numpy.linalg as la
import os
from pathlib import Path


class SimplexAlgorithm:
    def __init__(self, m, n, A, B, C) -> None:
        """ Constructor for SimplexAlgorithm

        :param m: number of constraints.

        :param n: number of variables.

        :param A: matrix of size mxn.

        :param B: matrix of size n.

        :param C: Cost vector.
        """
        self.m = m
        self.n = n
        self.A = A
        self.B = B
        self.C = C
        self.X = np.empty([n])
        self.eps = 1e-8
        self._check_inputs()

    def _check_inputs(self) -> None:
        """ Private function to validate input dimensions"""
        try:
            assert(self.B.shape == (self.m,))
            assert(self.C.shape == (self.n,))
            assert(self.X.shape == (self.n,))

        except AssertionError:
            self._return_error()
            return

        self.run()  # start execution of SimplexAlgorithm

    def _linearly_independent(self, A, B, X) -> Tuple[np.ndarray, np.ndarray]:
        """Finds linearly_independent rows

        :param A: matrix of size mxn

        :param B: matrix of size n

        :param X: matrix of size n

        :return: indices of linearly independent rows in matrix A
        """
        Z = np.dot(A, X) - B
        inds = np.where(np.abs(Z) < self.eps)[0]
        return A[inds], inds

    def get_direction_vector(self) -> Union[None, np.ndarray]:
        """ Get the direction vector for X to navigate to `nearest` neighbour

        :return: direction vector for X
        """
        A_lid, inds = self._linearly_independent(
            self.A, self.B, self.X)  # Obtaining the linearly independent rows
        A_lid_inv = la.inv(np.transpose(A_lid))
        alphas = np.dot(A_lid_inv, self.C)  # C.T = alphas * A_lid
        negs = np.where(alphas < 0)[0]  # Taking alphas < 0
        if len(negs) != 0:
            negs = negs[0]
            v = -A_lid_inv[negs]  # v is the direction vector
            if len(np.where(np.dot(self.A, v) > 0)[
                   0]) == 0:  # Checking the boundedness of polytope
                return np.array(["Unbounded"])
            # rows of A which do not belong to A_lid
            A_s = self.A[~np.isin(np.arange(len(self.A)), inds)]
            # rows of B which do not belong to B_lid
            B_s = self.B[~np.isin(np.arange(len(self.B)), inds)]
            # t = min((b_s - A_s x x0) / (A_s x v_i))
            t = (B_s - np.dot(A_s, self.X)) / (np.dot(A_s, v) + 1e-12)
            t = t[t >= 0]
            # Taking the minumum t and moving in that direction
            min_t = np.min(t)
            return min_t * v
        else:
            return None

    def run(self) -> None:
        """ Runs the Main Part of SimplexAlgorithm """
        while True:
            v = self.get_direction_vector()  # Calling the get_direction_vector() function
            if v is None:  # It cannot be optimised further
                break
            # Checking the boundedness of polytope
            elif np.array_equal(v, np.array(['Unbounded'])):
                print("LP is Unbounded")
                return
            else:
                self.X = self.X + v  # Going towards the direction vector
        if v is None:
            print(f"Optimal value is obtained at (X) :{self.X} \n"
                  f"Optimal Value is (C.X) :{np.dot(self.C,self.X)}")

    def _return_error(self, msg=None) -> None:
        """ A helper function to print traceback """
        if msg is not None:
            print(msg)
            return
        _, _, tb = sys.exc_info()
        traceback.print_tb(tb)
        tb_info = traceback.extract_tb(tb)
        _, line, _, text = tb_info[-1]
        print(f'An error occurred on line {line} in statement {text}')


if __name__ == '__main__':
    """ Taking inputs from the files present in './test_Q2' directory """

    base = './test_Q2'
    for file in Path(base).iterdir():
        if(not file.is_file()):
            continue
        test = open(file)
        m, n = map(int, test.readline().split())
        A = np.empty([m, n])
        for i in range(m):
            line = test.readline().split()
            for j in range(len(line)):
                A[i, j] = float(line[j])
        B = np.asarray(list(map(float, test.readline().split())))
        C = np.asarray(list(map(float, test.readline().split())))
        X = np.asarray(list(map(float, test.readline().split())))
        print(f"\n========={file}========\n")
        print(f" A : {A} \n B : {B} \n C : {C} \n X : {X}")
        # Calling SimplexAlgorithm Class
        simplex = SimplexAlgorithm(m, n, A, B, C)
