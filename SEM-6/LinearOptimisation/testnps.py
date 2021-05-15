import numpy as np
from scipy.optimize import linprog

m, n = map(int, input().split())
A = []
temp = 0
while (temp<m):
    s = input()
    A.append(np.asarray(list(map(float, s.split()))))
    temp = temp+1
A = np.asarray(A)
B = np.asarray(list(map(float, input().split())))
C = np.asarray(list(map(float, input().split())))
# X = np.asarray(list(map(float, input().split())))
print(f" A is : {A} \n B is : {B} \n C is : {C} \n ")
print(linprog(c=C, A_ub=A, b_ub=B, method='revised simplex'))