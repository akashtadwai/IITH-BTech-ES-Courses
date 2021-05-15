Instructions:

1) Browse to the directory where all the files are present. There must be a "input.txt" file with n,x,lamda,r,gamma values


2) To Compile the file run:
    $ g++ SrcAssgn4-es18btech11019.cpp -o korean -lpthread -lrt

3) To execute the file run:
    $ ./korean

4) The log is written to a file called <filename>-Log.txt and stats are written to a file called <filename>-Stats.txt. 

For auto Compilation:

    A bash script was written to take the inputs from a file named "now.txt" 
    which appends the inputs line by line to "input.txt" to run multiple tests at once Run,

    $ g++ SrcAssgn4-es18btech11019.cpp -o korean -lpthread -lrt 
    $ bash script.sh

    NOTE: Don't forget to do $ rm -rf Korean-*.txt between successive runs if running the bash script.
    