from assignment1 import SimplexAlgorithm as a1
from assignment2 import SimplexAlgorithm as a2
import os
import numpy as np
from pathlib import Path


def run(que, num):
    for file in Path(os.path.join(base, que)).iterdir():
        if(not file.is_file()):
            continue
        test = open(file)
        m, n = map(int, test.readline().split())
        A = np.empty([m, n])
        for i in range(m):
            line = test.readline().split()
            for j in range(len(line)):
                A[i, j] = float(line[j])
        cur_line = test.readline()
        B = np.asarray(list(map(float, cur_line.split())))
        cur_line = test.readline()
        C = np.asarray(list(map(float, cur_line.split())))
        cur_line = test.readline()
        X = np.asarray(list(map(float, cur_line.split())))
        print(f'========={file}========')
        print(f" A is : {A} \n B is : {B} \n C is : {C} \n X is : {X}")
        _ = (a1 if num == 1 else a2)(m, n, A, B, C)


if __name__ == '__main__':
    base = './tests'
    questions = ['Q1', 'Q2']
    for que in range(len(questions)):
        run(questions[que], que+1)