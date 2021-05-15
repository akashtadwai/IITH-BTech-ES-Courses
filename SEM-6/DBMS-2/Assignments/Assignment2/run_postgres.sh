#! /usr/bin/env bash
echo "You are in $(pwd)"
if [[ ! -f 'title.basics.tsv' || ! -f 'name.basics.tsv' || ! -f 'title.akas.tsv' || ! -f 'title.crew.tsv' || ! -f 'title.episode.tsv' || ! -f 'title.principals.tsv' || ! -f 'title.ratings.tsv' || ! -f 'imdb_top_1000.csv' ]]  
then 
printf "Go to the directory Containing all the extracted tsv files! \n"
exit 1
else 
sudo -u postgres /usr/bin/psql -c "create database imdb;" postgres
sudo -u postgres /usr/bin/psql -f './create.sql' imdb
sudo -u postgres /usr/bin/psql -f './populate.sql' imdb
fi
echo "Database is populated and Ready to use!!"