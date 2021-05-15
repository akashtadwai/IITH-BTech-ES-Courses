Instructions:

1) Browse to the directory where all the files are present. There must be a "input_params.txt" file with appropriate values.


2) To Compile the file run:
    $ g++ SrcAssgn5-ES18BTECH11019.cpp -o coloring -lpthread -Wall

3) To execute the file run:
    $ ./coloring 

4) The log is written to a file called Coloring-Log.txt.

5) NOTE: For maintaining modularity of the program I have coded all the three
    cases in one file without redefining many terms,
    hence for compiling fine grain locking algorithm comment
    the line number 20 in the Code which says "#define COARSE 1" and compile the program again,
    For comipiling Sequential Algorithm comment both 20,21 lines and compile the program again,
    By default the program exectures coarse grain locking.


6) Regarding generting test cases:
    $ python3 test_gen.py --threads <numThreads> --vertices <numVertices>

For help Regarding test generation,
    type $ python3 test_gen.py --help 
