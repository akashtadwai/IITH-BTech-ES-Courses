Instructions:

1) Create a file "inp-params.txt". Give the processes data in the file named inp-params.txt
    Format to be followed is :

    n(number of processes)
    then n lines follow where ith line is :
    pid[i] t[i] p[i] k[i]

    Example:
    2
    1 25 50 3
    2 35 80 4


2)
    a) Compile the RMS file by executing following command:
    $ g++ Assgn2-RMS-ES18BTECH11019.cpp -o rms

    b) Compile the EDF file by executing following commands:
    $ g++ Assgn2-EDF-ES18BTECH11019.cpp -o edf

    c) Compile the RMS-context_switch file by executing the following command:
    $ g++ Assgn2-RMS-cs-ES18BTECH11019.cpp -o rms_cs

    d) Compile the EDF-context_switch file by executing the following command:
    $ g++ Assgn2-EDF-cs-ES18BTECH11019.cpp -o edf_cs

3)
    a) Run the RMS file by executing :
    ./rms

    b) Run the EDF file by executing :
    ./edf

    c) Run the RMS-cs file by executing:
    ./rms_cs

    d) Run the EDF-cs file by executing:
    ./edf_cs

4) Check RMS-Log.txt file for logs of RMS while check EDF-Log.txt file for logs of EDF.


5) Deadline miss stats, Avg waiting time stats are present in RMS-Stats.txt and EDF-Stats.txt for rms and edf respectively.

6) For the context_switch case the codes are present in the context_switch/ directory.
