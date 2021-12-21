Author(s) : Vinta Reethu      - ES18BTECH11028
            Chaitanya Janakie - CS18BTECH11036
            Akash Tadwai      - ES18BTECH11019
            

Instructions to run:

    1) Go to the directory containing all the files.

    2) The notebook contains all the code implementing both the SharedNN and MutualAvgNN algorithms

    3) NOTE: It is advised to run the file on Google Colab by uploading all the required csv files,
       as all dependencies are present by default.

    4) We have written a test graph (which originally is given in paper) to check if both the algorithms
        we implemented are correct and their outputs are present in the notebook which are matching with
        the results obtained in paper. 

    5) To run the tests on the cluster.csv file, change the variable `df=process_dataset(test_dataset)`
        to `df = process_dataset(PATH)`