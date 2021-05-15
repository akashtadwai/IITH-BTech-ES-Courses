Author(s) : Akash Tadwai - ES18BTECH11019
            Vinta Reethu - ES18BTECH11028

Instructions to run:
    1) Go to the directory containing all the files.

    2) By default our code runs all the test cases present in "test_Q3/" directory.

    3) Sample testcases given in Google Classroom are provided 
       in test_Q3 directory. To add new test files add them in the 
       test_Q3 directory as a txt file with the following format :

       m n  Here m is number of constraint equations; n is number of variables
       m lines of A with values in row as space separated
       1 line of B with values in array as space separated
       1 line of C with values in array as space separated

       Example : 
                4 2
                1 4
                1 2
                -1 0 
                0 -1
                8 4 0 0
                3 9

        Here m : 4
             n : 2
             A : [[ 1.  4.]
                  [ 1.  2.]
                  [-1.  0.]
                  [ 0. -1.]] 
             B : [8. 4. 0. 0.] 
             C : [3. 9.] 

             
    4) These assumptions were made as given in the assignment description :
        1. Rank of matrix is equal to the number of columns

    5) To run - $ python3 assignment3.py