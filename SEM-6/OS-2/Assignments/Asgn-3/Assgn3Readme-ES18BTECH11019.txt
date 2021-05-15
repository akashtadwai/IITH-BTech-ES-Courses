Instructions:

1) Browse to the directory where all the files are present. There must be a "inp-params.txt" file with n,k,lamda1,lamda2 values
    if Compiling the files individually.

2) To run all files at once by varying the number of threads on all methods, run:
    $ bash script.sh 
   Then the respective Log and Stats files will be created with number of threads varying from 10 to 100.
   You can tweak the parameters in the file "now.txt" where all the inputs are given.


2) To Compile each of the file one by one  
    a. TAS :            $ g++ SrcAssgn3-tas-es18btech11019.cpp -lpthread -o tas
    b. CAS :            $ g++ SrcAssgn3-cas-es18btech11019.cpp -lpthread -o cas
    c. CAS-Bounded :    $ g++ SrcAssgn3-cas-bounded-es18btech11019.cpp -lpthread -o cas_bounded

3) To execute each of the following run:
    a. TAS          : ./tas
    b. CAS          : ./cas
    c. CAS-Bounded  : ./cas_bounded

4) The log is written to a file called <filename>-Log.txt and stats are written to a file called <filename>-Stats.txt


