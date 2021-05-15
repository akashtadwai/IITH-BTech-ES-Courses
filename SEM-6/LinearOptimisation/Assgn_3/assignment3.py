"""
 Date: 01-05-2021
 Assignment - 3
 Author(s): Akash Tadwai - ES18BTECH11019
            Vinta Reethu - ES18BTECH11028
"""

# Assumptions
# 1. Rank of matrix is equal to the number of columns

import numpy as np
import sys
import traceback
from typing import Union, Tuple
import numpy.linalg as la
import os
from pathlib import Path


class ClassError(Exception):  # Class to handle exceptions
    def __init__(self):
        super().__init__()


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

        self.B = self.get_non_degenerate()  # Making LP non degenerate
        if self.B is not None:
            try:
                # Trying to obtain initial feasible point
                self.X = self.feasible_point(self.A, self.B, self.C)
                print('Init feasible',self.X)
            except BaseException:
                print("LP might be infeasible try running again :( ")
                return
            self.run()  # start execution of SimplexAlgorithm

    def get_non_degenerate(self) -> np.ndarray:
        """ Converts polytope to non degenerate

        :return: Modified version of B
        """
        itr = 0
        while True:
            i = self.m - self.n
            B_ = self.B
            if (itr < 1000):
                # Perturbing B by adding noise
                B_[:i] = self.B[:i] + np.random.uniform(1e-6, 1e-5, size=i)
                itr += 1

            else:
                # Checking for a larger range
                B_[:i] = self.B[:i] + np.random.uniform(0.1, 10, size=i)

            try:
                X = self.feasible_point(self.A, B_, self.C)
            except ClassError:
                print("LP might be infeasible try running again :( ")
                return None

            Z = np.dot(self.A, X) - B_
            inds = np.where(np.abs(Z) < self.eps)[0]
            if len(inds) == self.n:  # Converted to non degenerate
                break
        return B_

    def feasible_point(self, A, B, C) -> np.ndarray:
        """ Calculate feasible point

        :param A: matrix of size mxn.

        :param B: matrix of size n.

        :param C: Cost vector.

        :return: Feasible point for the given LP
        """
        inds = np.where(B < 0)[0]
        if len(inds) == 0:
            # Start at the origin, when LP has inequalities with positive
            # right-hand sides
            return np.zeros(C.shape)
        else:
            for _ in range(
                    1000):  # Calculate X such that all constraints are satisfied
                rand_rows = np.random.choice(self.m, self.n)
                A_rand = A[rand_rows]
                B_rand = B[rand_rows]
                try:
                    A_inv = la.inv(A_rand)
                    X_ = np.dot(A_inv, B_rand)
                    X_inds = np.where(np.abs(X_) < self.eps)[0]
                    Z = np.dot(A, X_) - B

                    pos_rows = np.where(Z > 0)[0]
                    if ((len(X_inds) == A_rand.shape[1]) and (
                            len(pos_rows) <= 0)):   # Infeasible
                        raise ClassError
                    elif (len(pos_rows) > 0):
                        continue
                    else:
                        return X_
                except la.LinAlgError:
                    continue
            raise ClassError  # Infeasible

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
            print('V is',v)
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
    """ Taking inputs from the files present in './test_Q3' directory """

    base = './test_Q3'
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
        print(f" A : {A} \n B : {B} \n C : {C} \n")
        # Calling SimplexAlgorithm Class
        simplex = SimplexAlgorithm(m, n, A, B, C)
