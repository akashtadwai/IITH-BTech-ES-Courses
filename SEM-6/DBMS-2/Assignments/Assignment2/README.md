# Instructions to run SQL files:

- Navigate to the directory where all the tsv files are downloaded and also download the csv dataset from this [Kaggle dataset](https://www.kaggle.com/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows)  into the same directory (We have crawled some data using this dataset).
- There are two sql files
    - create.sql - This creates the schemas for the database.
    - populate.sql - This will fill the tables with data from tsv, csv files.
- To run using bash script run the following command

    ```$ bash run_postgres.sh ```
    - This creates and populates all the tables into the database “imdb” as user ```postgres```.
    - Enter the sudo password whenever required.
- You can also run the *.sql files as a different user and different database name.