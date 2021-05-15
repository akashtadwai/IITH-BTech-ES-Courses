-- Query 1
SELECT
    m.id,
    Original_title
FROM (
    SELECT
        id,
        count(*)
    FROM
        part_of_movie
    WHERE
        ROLE = 'director'
    GROUP BY
        id
    HAVING
        count(*) >= 2) AS d,
    main_class AS m
WHERE
    d.id = m.id;

-- Query 2
WITH directorActor (
    actorSSN,
    directorSSN,
    directorName,
    movieCount
) AS (
    SELECT
        actor.SSN,
        part_of_movie.SSN,
        Person.Name,
        count(part_of_movie.ID)
    FROM (
        SELECT
            SSN,
            ID
        FROM
            part_of_movie
        WHERE
            ROLE = 'actor') AS actor,
    part_of_movie,
    Person
    WHERE
        actor.id = Part_of_movie.id
        AND part_of_movie.role = 'director'
        AND part_of_movie.SSN = Person.SSN
    GROUP BY
        actor.SSN,
        part_of_movie.SSN,
        Person.Name
)
SELECT
    dirAct.actorSSN,
    Person.Name
FROM (
    SELECT
        DA.actorSSN AS actSSN,
        max(DA.movieCount) AS maxCount
    FROM
        directorActor AS DA
    WHERE
        DA.directorName <> 'Zack Snyder'
    GROUP BY
        DA.actorSSN) AS maxMapping,
    directorActor AS dirAct,
    Person
WHERE
    dirAct.directorName = 'Zack Snyder'
    AND maxMapping.maxCount < dirAct.movieCount
    AND Person.SSN = dirAct.actorSSN;

-- Query 3
SELECT
    Nomination_MainClass.ID,
    main.Original_title,
    COUNT(Nomination_MainClass.Award_Name)
FROM
    Nomination_MainClass
    INNER JOIN Movie ON Movie.ID = Nomination_MainClass.ID,
    main_class AS main
WHERE
    main.ID = Nomination_MainClass.ID AND Nomination_MainClass.won=1
GROUP BY
    Nomination_MainClass.ID,
    main.Original_title
HAVING
    COUNT(Nomination_MainClass.Award_Name) < 2;

-- Query 4
SELECT
    actor.actorname AS actorname,
    Person.Name AS directorname,
    count(part_of_movie.ID)
FROM (
    SELECT
        P.SSN AS actorssn,
        PM.ID AS movieid,
        P.Name AS actorname
    FROM
        part_of_movie AS PM,
        Person AS P
    WHERE
        ROLE = 'actor'
        AND P.SSN = PM.SSN) AS actor,
    part_of_movie,
    Person,
    main_class
WHERE
    actor.movieid = Part_of_movie.id
    AND part_of_movie.role = 'director'
    AND part_of_movie.SSN = Person.SSN
    AND main_class.id = Part_of_movie.id
    AND main_class.rating > 7
GROUP BY
    actor.actorname,
    Person.Name
HAVING
    count(part_of_movie.ID) <= 2;

-- Query 5
-- Populating
-- CREATE TEMPORARY TABLE titles_temp (
--     tconst text NOT NULL,
--     titleType text,
--     primaryTitle text,
--     originalTitle text,
--     isAdult int,
--     startYear int,
--     endYear int,
--     runtimeMinutes text,
--     genres text
-- );
-- \copy titles_temp FROM program 'tail -n +2 title.basics.tsv';
-- UPDATE
--     air_info_Series
-- SET
--     Start_date = titles_temp.startYear,
--     End_date = titles_temp.endYear
-- FROM
--     titles_temp
-- WHERE
--     air_info_Series.seriesid = titles_temp.tconst;
-- Query 5
SELECT
    seriesid,
    release_title,
    (
        CASE WHEN End_date IS NULL THEN
            2021
        ELSE
            End_date
        END) - Start_date AS time_run
FROM
    air_info_Series
WHERE
    Start_date IS NOT NULL
ORDER BY
    time_run DESC
LIMIT 1;

-- Query 6
-- Populated
-- UPDATE
--     Air_info_Movies
-- SET
--     Release_date = titles_temp.startYear
-- FROM
--     titles_temp
-- WHERE
--     Air_info_Movies.movieid = titles_temp.tconst;
-- ALTER TABLE Air_info_Movies ALTER COLUMN Run_time TYPE text USING Run_time::integer;
-- ALTER TABLE Air_info_Movies ALTER COLUMN Run_time TYPE INT USING Run_time::integer;
-- CREATE TEMPORARY TABLE crew_temp (
--     titleID text,
--     directors text,
--     writers text,
-- );
-- \copy crew_temp FROM program 'tail -n +2 title.crew.tsv';
-- CREATE TEMPORARY TABLE direct_id_temp (
--     titleId text,
--     split text
-- );
-- Splitting title_ids present in name.basics
-- INSERT INTO direct_id_temp (titleId, split)
-- SELECT
--     crew_temp.titleID,
--     regexp_split_to_table(crew_temp.directors, E',')
-- FROM
--     crew_temp;
-- Adding director roles into Part_of_movie
-- UPDATE
--     Part_of_movie
-- SET
--     ROLE = 'director'
-- FROM
--     crew_temp
-- WHERE
--     Part_of_movie.ID = crew_temp.titleID
--     AND ROLE IS NULL
--     AND crew_temp.directors IS NOT NULL;
-- INSERT INTO Part_of_movie (SSN, ID, ROLE)
-- SELECT
--     direct_id_temp.split,
--     direct_id_temp.titleID,
--     'director'
-- FROM
--     direct_id_temp,Movie,Cast_Crew
-- WHERE direct_id_temp.titleID = Movie.ID AND direct_id_temp.split = Cast_Crew.SSN
-- ON CONFLICT (SSN, ID) DO NOTHING;
--------------------------------
SELECT
    directorTable.name,
    directorTable.title,
    directorTable.runtime,
    directorTable.runtimerank
FROM (
    SELECT
        P.Name AS Name,
        A.Release_title AS title,
        A.Run_time AS runtime,
        dense_rank() OVER (ORDER BY A.Run_time ASC) AS runtimerank
    FROM
        Air_info_Movies AS A,
        Part_of_movie AS M,
        Person AS P
    WHERE
        A.Release_date = 2020
        AND A.movieid = M.ID
        AND M.ROLE = 'director'
        AND M.SSN = P.SSN
        AND A.Run_time IS NOT NULL) AS directorTable
WHERE
    directorTable.runtimerank = 2;

-- Query 7
-- ALTER TABLE main_class
--     ADD COLUMN isAdult INT;
-- ALTER TABLE main_class
--     ADD COLUMN rating FLOAT;
-- Populating isadult
-- UPDATE
--     main_class
-- SET
--     rating = titles_temp.isAdult
-- FROM
--     titles_temp
-- WHERE
--     main_class.id = titles_temp.tconst;
-- Populating rating
-- CREATE TEMPORARY TABLE ratings_temp (
--     tconst text NOT NULL,
--     averageRating float,
--     numVotes int
-- );
-- \copy ratings_temp FROM program 'tail -n +2 title.ratings.tsv';
-- UPDATE
--     main_class
-- SET
--     rating = ratings_temp.averageRating
-- FROM
--     ratings_temp
-- WHERE
--     main_class.id = ratings_temp.tconst;
SELECT
    *
FROM (
    SELECT
        Movie.id AS id,
        main.Original_title AS title,
        main.rating AS rating,
        dense_rank() OVER (ORDER BY main.rating ASC) AS ratingrank
    FROM
        main_class AS main,
        Movie
    WHERE
        main.id = Movie.id
        AND main.isAdult = 1
        AND main.rating IS NOT NULL) AS ratingTableMovies
WHERE
    ratingTableMovies.ratingrank = 1
UNION
SELECT
    *
FROM (
    SELECT
        Series.id AS id,
        main.Original_title AS title,
        main.rating AS rating,
        dense_rank() OVER (ORDER BY main.rating ASC) AS ratingrank
    FROM
        main_class AS main,
        Series
    WHERE
        main.id = Series.id
        AND main.isAdult = 1
        AND main.rating IS NOT NULL) AS ratingTableSeries
WHERE
    ratingTableSeries.ratingrank = 1;

-- Query 8
WITH director_avg_table (
    SSN,
    name,
    avg_rating
) AS (
    SELECT
        T.SSN,
        T.name,
        T.avg_rating
    FROM (
        SELECT
            Person.SSN AS SSN,
            Person.name AS name,
            avg(main_class.rating) AS avg_rating
    FROM
        Person,
        Part_of_movie,
        main_class
    WHERE
        Part_of_movie.ID = main_class.id
        AND Person.SSN = Part_of_movie.SSN
        AND Part_of_movie.role = 'director'
    GROUP BY
        Person.SSN,
        Person.name) AS T
)
SELECT
    T.SSN,
    T.name,
    T.avg_rating,
    T.row_number
FROM (
    SELECT
        direct.SSN,
        direct.name,
        direct.avg_rating,
        DENSE_RANK() OVER (ORDER BY direct.avg_rating DESC) AS row_number
    FROM
        director_avg_table AS direct
    WHERE
        direct.avg_rating IS NOT NULL) AS T
WHERE
    T.row_number <= 5;

-- Query 9
WITH multiProduction (
    seriesId,
    cntProduction
) AS (
    SELECT
        S.id AS sereisId,
        COUNT(Production.company_id) AS cntProduction
    FROM
        is_producing AS Production,
        Series AS S
    WHERE
        S.id = Production.id
    GROUP BY
        S.id
    HAVING
        COUNT(Production.company_id) >= 2
    ORDER BY
        cntProduction DESC
)
SELECT
    MP.seriesId AS seriesId,
    count(L.country) AS cntCountry
FROM
    multiProduction AS MP,
    air_info_Series AS air,
    Location AS L
WHERE
    MP.seriesId = air.seriesid
    AND L.id = air.Locationid
GROUP BY
    MP.seriesId
HAVING
    COUNT(L.country) >= 3;

-- Query 10
SELECT
    p.name
FROM
    Nomination_People award,
    Person P
WHERE
    award.Award_Name = 'oscar'
    AND award.won = 1
    AND P.ssn = award.ssn
ORDER BY
    award.Year DESC;

-- Query 11
-- CREATE TEMPORARY TABLE principals_temp (
--     tconst text NOT NULL,
--     ordering int,
--     nconst text,
--     category text,
--     job text,
--     characters text
-- );
-- \copy principals_temp FROM program 'tail -n +2 title.principals.tsv';
-- ALTER TABLE part_of_movie ADD COLUMN job TEXT;
-- UPDATE
--     part_of_movie
-- SET
--     JOB = principals_temp.job
-- FROM principals_temp
-- WHERE principals_temp.tconst = part_of_movie.id;
-----------------------------------------------------------
WITH experience(SSN, expcnt) AS (
    SELECT PM.SSN AS SSN,
        COUNT(PM.ID) AS expcnt
    FROM part_of_movie AS PM
    WHERE PM.JOB IN ('director', 'assistant director')
        AND PM.Role = 'director'
    GROUP BY PM.SSN
),
avg_dir(SSN, avg_dir_rate) AS (
    SELECT PM.SSN AS SSN,
        AVG(main_class.rating) AS avg_dir_rate
    FROM part_of_movie AS PM,
        main_class
    WHERE PM.job = 'director'
        AND PM.Role = 'director'
        AND PM.id = main_class.id
    GROUP BY PM.SSN
),
avg_asstdir(SSN, avg_asstdir_rate) AS (
    SELECT PM.SSN AS SSN,
        AVG(main_class.rating) AS avg_asstdir_rate
    FROM part_of_movie AS PM,
        main_class
    WHERE PM.job = 'assistant director'
        AND PM.Role = 'director'
        AND PM.id = main_class.id
    GROUP BY PM.SSN
)
SELECT experience.SSN,
    0.3 * experience.expcnt + 0.7 * (
        0.8 * (COALESCE(ad.avg_dir_rate, 0)) + 0.2 * (COALESCE(asd.avg_asstdir_rate, 0))
    ) AS Score
FROM experience,
    avg_dir AS ad
    FULL OUTER JOIN avg_asstdir AS asd ON ad.SSN = asd.SSN
WHERE experience.SSN = ad.SSN
    OR experience.SSN = asd.SSN
ORDER BY Score DESC;

-- Query 12
CREATE TEMPORARY TABLE genreTable (
    PK serial PRIMARY KEY,
    ID text NOT NULL,
    genre text,
    Name text
);

INSERT INTO genreTable (ID, genre, name) (
    SELECT
        main.ID,
        regexp_split_to_table(main.genre, E','),
        main.Original_title
    FROM
        Main_class AS main);

SELECT
    *
FROM (
    SELECT
        genres.genre AS agg_genre,
        Person.SSN AS directorname,
        genres.Name AS movietitle,
        row_number() OVER (PARTITION BY genres.genre ORDER BY movie.Box_office - main_class.Budget DESC) AS earningRank
    FROM
        genreTable AS genres,
        main_class,
        movie,
        part_of_movie,
        Person
    WHERE
        main_class.Budget IS NOT NULL
        AND movie.Box_office IS NOT NULL
        AND main_class.id = movie.id
        AND genres.ID = movie.id
        AND part_of_movie.id = movie.id
        AND part_of_movie.SSN = Person.SSN) AS earnings
WHERE
    earnings.earningRank <= 5
ORDER BY
    earnings.agg_genre,
    earnings.earningRank ASC;

-- Query 13
SELECT
    p.NAME
FROM
    Partofepisode AS pEpisode,
    Part_of_movie AS pMovie,
    Person AS p
WHERE
    pEpisode.SSN = pMovie.SSN
    AND pEpisode.SSN = p.SSN
    AND pEpisode.ROLE = 'actor'
    AND pMovie.ROLE = 'actor';

-- Query 14
-- Populated
-- UPDATE
--     episode_releases_in
-- SET
--     Release_date = titles_temp.startYear
-- FROM
--     titles_temp
-- WHERE
--     episode_releases_in.episodeid = titles_temp.tconst;
SELECT
    ep.episode_name,
    releasesIn.Release_date,
    MIN(run_time::numeric) AS runTime
FROM
    episode_releases_in AS releasesIn,
    Episode AS ep
WHERE
    releasesIn.run_time IS NOT NULL
    AND ep.episodeid = releasesIn.episodeid
GROUP BY
    ep.episode_name,
    releasesIn.Release_date
ORDER BY
    releasesIn.Release_date ASC;

-- Query 15
-- If query 12 is not run before query15 please run
-- the sql code in the below commented part
-- CREATE TEMPORARY TABLE genreTable (
--     PK serial PRIMARY KEY,
--     ID text NOT NULL,
--     genre text,
--     Name text
-- );
-- INSERT INTO genreTable (ID, genre, Name) (
--     SELECT
--         main.ID,
--         regexp_split_to_table(main.genre, E','),
--         main.Original_title
--     FROM
--         Main_class AS main);
SELECT
    *
FROM (
    SELECT
        genres.Name AS movieName,
        genres.genre AS genre,
        row_number() OVER (PARTITION BY genres.genre ORDER BY main_class.rating DESC) AS Ratingrank
    FROM
        genreTable AS genres,
        main_class,
        movie
    WHERE
        main_class.id = movie.id
        AND genres.id = main_class.id) AS goodMovies
WHERE
    goodMovies.Ratingrank <= 3
ORDER BY
    goodMovies.genre,
    goodMovies.Ratingrank ASC;

DROP genreTable;

-- Query 16
SELECT
    main.id,
    main.Original_title
FROM
    Main_class AS main
WHERE
    main.Filmed_at LIKE '%Switzerland%';

-- Query 17
-- Populated release date from titles_temp table.
-- If you have already created db using assignment 2
-- please uncomment the below part to populate
-------------------------------------------------------------------------
-- UPDATE
--     Air_info_Movies
-- SET
--     Release_date = titles_temp.startYear
-- FROM
--     titles_temp
-- WHERE
--     Air_info_Movies.movieid = titles_temp.tconst;
SELECT
    movieid,
    Release_title,
    locationid
FROM
    Air_info_Movies
WHERE
    Certificate = 'A'
    AND Release_date = 1995
ORDER BY
    locationid;

-- Query 18
-- Taking distinct roles as our profession
WITH professions (
    profession
) AS (
    SELECT DISTINCT
        (part_of_movie.role)
    FROM
        part_of_movie
)
SELECT
    *
FROM (
    SELECT
        P.SSN AS SSN,
        P.Name AS Name,
        P.birthYear,
        prof.profession AS profession,
        rank() OVER (PARTITION BY prof.profession ORDER BY P.birthYear DESC) AS rank_person
    FROM
        professions AS prof,
        Person AS P,
        Part_of_movie AS PM
    WHERE
        PM.Role = prof.profession
        AND P.birthYear IS NOT NULL
        AND PM.SSN = P.SSN) AS agerank
WHERE
    agerank.rank_person = 1;

-- Query 19
-- In the tsv files, we have observed that
-- role of music producer, director etc is composer
SELECT
    part_of_movie.SSN AS SSN,
    COUNT(part_of_movie.id) AS numMovies
FROM
    part_of_movie
WHERE
    part_of_movie.role = 'composer'
GROUP BY
    part_of_movie.SSN
HAVING
    COUNT(part_of_movie.id) >= 5;

-- Query 20
-- The movie we have considered here is 'One Act Play'
WITH crewCount (
    Movieid,
    numCrew
) AS (
    SELECT
        part_of_movie.id AS Movieid,
        COUNT(part_of_movie.SSN) AS numCrew
    FROM
        part_of_movie,
        main_class
    WHERE
        main_class.id = part_of_movie.id
        AND main_class.Original_title = 'One Act Play'
    GROUP BY
        part_of_movie.id
),
personCount (
    SSN, numMovies
) AS (
    SELECT
        part_of_movie.SSN AS Movieid,
        COUNT(part_of_movie.ID) AS numMovies
    FROM
        part_of_movie
    GROUP BY
        part_of_movie.SSN
)
SELECT
    Person.name,
    Person.SSN
FROM
    personCount,
    Person,
    crewCount
WHERE
    personCount.numMovies = crewCount.numCrew
    AND Person.SSN = personCount.SSN;

