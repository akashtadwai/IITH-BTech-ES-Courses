-- Populating main_class table from 'title.basics.tsv' file
CREATE TEMPORARY TABLE titles_temp (
    tconst text NOT NULL,
    titleType text,
    primaryTitle text,
    originalTitle text,
    isAdult int,
    startYear int,
    endYear int,
    runtimeMinutes text,
    genres text
);

-- Copy the tsv file into temporary table titles_temp
\copy titles_temp FROM program 'tail -n +2 title.basics.tsv';
-- Inserting data into main_class from temporary table titles_temp
INSERT INTO main_class (id, original_title, genre)
SELECT
    tconst,
    originalTitle,
    genres
FROM
    titles_temp
WHERE
    titleType IN ('short', 'movie', 'tvMovie', 'tvShort', 'tvSeries', 'tvMiniSeries', 'radioSeries', 'tvEpisode');

-- Populating movie table from 'title.basics.tsv' file
-- Inserting data into main_class from temporary table titles_temp
INSERT INTO movie (id)
SELECT
    tconst
FROM
    titles_temp
WHERE
    titleType IN ('short', 'movie', 'tvMovie', 'tvShort');

-- Test queries
-- SELECT
--     *
-- FROM
--     main_class
--     INNER JOIN movie ON main_class.id = movie.id
-- LIMIT 10;

-- Populating series table from 'title.basics.tsv' file
-- Inserting data into main_class from temporary table titles_temp
INSERT INTO series (id)
SELECT
    tconst
FROM
    titles_temp
WHERE
    titleType IN ('tvSeries', 'tvMiniSeries', 'radioSeries', 'tvMovie', 'tvEpisode');

-- Test queries
-- SELECT
--     *
-- FROM
--     main_class
--     INNER JOIN series ON main_class.id = series.id
-- LIMIT 10;

-- Populating episode table from 'title.episode.tsv' file
CREATE TEMPORARY TABLE episode_temp (
    tconst text NOT NULL,
    parentTconst text,
    seasonNumber int,
    episodeNumber int
);

-- Copy the tsv file into temporary table episode_temp
\copy episode_temp FROM program 'tail -n +2 title.episode.tsv';

-- We add entry into episode only if parentType is present in series table
INSERT INTO episode (episodeid, seriesid, Season_Number, Episode_Number)
SELECT
    episode_temp.tconst,
    episode_temp.parentTconst,
    episode_temp.seasonNumber,
    episode_temp.episodeNumber
FROM
    episode_temp,
    series
WHERE
    series.id = episode_temp.parentTconst;

-- Loading 'title.ratings.csv' file
CREATE TEMPORARY TABLE ratings_temp (
    tconst text NOT NULL,
    averageRating float,
    numVotes int
);

-- Copy the tsv file into temporary table ratings_temp
\copy ratings_temp FROM program 'tail -n +2 title.ratings.tsv';

-- Using ratings_temp to update rating in episode table
UPDATE
    episode
SET
    rating = ratings_temp.averageRating
FROM
    ratings_temp
WHERE
    episode.episodeid = ratings_temp.tconst;

-- Loading 'name.basics.tsv' file
CREATE TEMPORARY TABLE people_temp (
    nconst text NOT NULL,
    primaryName text,
    birthYear int,
    deathYear int,
    primaryProfession text,
    knownForTitles text
);

-- Copy the tsv file into temporary table people_temp
\copy people_temp FROM program 'tail -n +2 name.basics.tsv';

-- Entering data into person table
INSERT INTO Person (SSN, Name, birthYear, deathYear)
SELECT
    nconst,
    primaryName,
    birthYear,
    deathYear
FROM
    people_temp;

-- Entering data into Cast_Crew table
INSERT INTO Cast_Crew (SSN)
SELECT
    nconst
FROM
    people_temp;

CREATE TEMPORARY TABLE person_id_temp (
    SSN text,
    split_id text
);

-- Splitting title_ids present in name.basics
INSERT INTO person_id_temp (SSN, split_id)
SELECT
    people_temp.nconst,
    regexp_split_to_table(people_temp.knownForTitles, E',')
FROM
    people_temp;

-- Associating person to an episode in which he/she is part of
INSERT INTO Partofepisode (SSN, episodeid)
SELECT
    person_id_temp.SSN,
    episode.episodeid
FROM
    person_id_temp,
    episode
WHERE
    person_id_temp.split_id = episode.episodeid;

-- Associating person to an movie in which he/she is part of
INSERT INTO Part_of_movie (SSN, ID)
SELECT
    person_id_temp.SSN,
    movie.ID
FROM
    person_id_temp,
    movie
WHERE
    person_id_temp.split_id = movie.ID;

-- Loading title.principals.tsv
CREATE TEMPORARY TABLE principals_temp (
    tconst text NOT NULL,
    ordering int,
    nconst text,
    category text,
    job text,
    characters text
);

\copy principals_temp FROM program 'tail -n +2 title.principals.tsv';

-- Updating the role coumn in Partofepisode, Part_of_movie only if episodeid is equal to tconst
UPDATE
    Partofepisode
SET
    ROLE = principals_temp.category
FROM
    principals_temp
WHERE
    Partofepisode.episodeid = principals_temp.tconst;

UPDATE
    Part_of_movie
SET
    ROLE = principals_temp.category
FROM
    principals_temp
WHERE
    Part_of_movie.ID = principals_temp.tconst;

-- Populating episode table from 'title.akas.tsv' file
CREATE TEMPORARY TABLE region_temp (
    titleID text,
    ordering int,
    title text,
    region text,
    language text,
    types text,
    attributes text,
    isOriginalTitle int
);

\copy region_temp FROM program 'tail -n +2 title.akas.tsv';

-- Adding regions into location table
INSERT INTO Location (region)
SELECT DISTINCT
    (region)
FROM
    region_temp;

-- Adding data into Air_info_Movies from the temporary table region_temp
INSERT INTO Air_info_Movies (Release_title, movieid, locationid)
SELECT
    region_temp.title,
    movie.id,
    location.id
FROM
    movie,
    region_temp,
    location
WHERE
    movie.id = region_temp.titleID
    AND (region_temp.region = location.region
        OR (region_temp.region IS NULL
            AND location.region IS NULL));

-- Adding data into episode_releases_in from the temporary table region_temp
INSERT INTO episode_releases_in (Release_title, episodeid, locationid)
SELECT
    region_temp.title,
    episode.episodeid,
    location.id
FROM
    episode,
    region_temp,
    location
WHERE
    episode.episodeid = region_temp.titleID
    AND (region_temp.region = location.region
        OR (region_temp.region IS NULL
            AND location.region IS NULL));

-- Adding data into air_info_Series from the temporary table region_temp
INSERT INTO air_info_Series (Release_title, seriesid, locationid)
SELECT
    region_temp.title,
    series.id,
    location.id
FROM
    series,
    region_temp,
    location
WHERE
    series.id = region_temp.titleID
    AND (region_temp.region = location.region
        OR (region_temp.region IS NULL
            AND location.region IS NULL));

-- Adding runtime attribute to episode_releases_in, Air_info_Movies
UPDATE
    episode_releases_in
SET
    Run_time = titles_temp.runtimeMinutes
FROM
    titles_temp
WHERE
    episode_releases_in.episodeid = titles_temp.tconst
    AND titles_temp.originalTitle = episode_releases_in.Release_title;

UPDATE
    Air_info_Movies
SET
    Run_time = titles_temp.runtimeMinutes
FROM
    titles_temp
WHERE
    Air_info_Movies.movieid = titles_temp.tconst
    AND titles_temp.originalTitle = Air_info_Movies.Release_title;

-- Adding languages of release into main_class
CREATE TEMPORARY TABLE languages_temp (
    tconst text,
    language text
);

INSERT INTO languages_temp (tconst,
    LANGUAGE)
SELECT
    titleId,
    LANGUAGE
FROM
    region_temp;

CREATE TEMPORARY TABLE languages_list_temp (
    tconst text,
    languages text
);

-- Adding multiple languages by making it comma separated
INSERT INTO languages_list_temp
SELECT
    tconst,
    string_agg(
        LANGUAGE, ', ')
FROM
    languages_temp
GROUP BY
    tconst;

UPDATE
    main_class
SET
    Language_of_release = languages_list_temp.languages
FROM
    languages_list_temp
WHERE
    main_class.id = languages_list_temp.tconst;

-- Adding data by crawling from the web
CREATE TEMPORARY TABLE kaggle_imdb (
    Poster_Link text,
    Series_Title text,
    Released_Year text,
    Certificate text,
    Runtime text,
    genre text,
    IMDB_Rating text,
    Overview text,
    MetaScore text,
    Director text,
    Star1 text,
    Star2 text,
    Star3 text,
    Star4 text,
    Noofvotes text,
    Gross text
);

-- Loading the file
\copy kaggle_imdb FROM 'imdb_top_1000.csv' (format csv, NULL'\N', header 1); 
CREATE TEMPORARY TABLE bonus_crawling (
    id serial PRIMARY KEY,
    Certificate text,
    Plot text,
    Series_Title text,
    Box_office text
);

INSERT INTO bonus_crawling (Certificate, Plot, Box_office, Series_Title)
SELECT
    Certificate,
    Overview,
    Gross,
    Series_Title
FROM
    kaggle_imdb;

-- Adding Plot into main_class
UPDATE
    main_class
SET
    Plot = bonus_crawling.Plot
FROM
    bonus_crawling
WHERE
    main_class.Original_title = bonus_crawling.Series_Title;

-- Adding Certificate into Air_info_Movies
UPDATE
    Air_info_Movies
SET
    Certificate = bonus_crawling.Certificate
FROM
    bonus_crawling
WHERE
    Air_info_Movies.Release_title = bonus_crawling.Series_Title;

-- Adding Certificate into air_info_Series
UPDATE
    air_info_Series
SET
    Certificate = bonus_crawling.Certificate
FROM
    bonus_crawling
WHERE
    air_info_Series.Release_title = bonus_crawling.Series_Title;

UPDATE
    Movie
SET
    Box_office = REPLACE(bonus_crawling.Box_office, ',', '')::numeric
FROM
    bonus_crawling, main_class
WHERE
    bonus_crawling.Box_office <> '' AND main_class.Original_title = bonus_crawling.Series_Title;

-- Dropping temporary tables that are used to create the tables
DROP TABLE titles_temp;

DROP TABLE episode_temp;

DROP TABLE ratings_temp;

DROP TABLE people_temp;

DROP TABLE person_id_temp;

DROP TABLE principals_temp;

DROP TABLE region_temp;

DROP TABLE languages_temp;

DROP TABLE languages_list_temp;

DROP TABLE kaggle_imdb;

DROP TABLE bonus_crawling;

