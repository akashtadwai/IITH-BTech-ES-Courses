CREATE TABLE Main_class (
  ID text NOT NULL,
  Original_title text,
  Language_of_release text,
  plot text,
  genre text,
  Budget int,
  Websites text,
  Filmed_at text,
  PRIMARY KEY (ID)
);

CREATE TABLE Production (
  Company_ID text NOT NULL,
  Name text,
  PRIMARY KEY (Company_ID)
);

CREATE TABLE Movie (
  ID text NOT NULL,
  Box_office int,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Main_class (ID)
);

CREATE TABLE Awards (
  Year int NOT NULL,
  Category text NOT NULL,
  Award_Name text NOT NULL,
  PRIMARY KEY (Year, Award_Name, Category)
);

CREATE TABLE Series (
  ID text NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Main_class (ID)
);

CREATE TABLE Episode (
  episodeid text NOT NULL,
  seriesid text NOT NULL,
  Season_Number int,
  Episode_Number int,
  Rating float,
  Episode_Name text,
  Plot text,
  PRIMARY KEY (episodeid),
  FOREIGN KEY (seriesid) REFERENCES Series (ID),
  UNIQUE (Season_Number, Rating, episodeid)
);

CREATE TABLE Location (
  id serial PRIMARY KEY,
  Region text,
  Country text
);

CREATE TABLE Person (
  SSN text NOT NULL,
  Name text,
  birthYear int,
  deathYear int,
  Gender text,
  PRIMARY KEY (SSN)
);

CREATE TABLE Users (
  SSN text NOT NULL,
  PRIMARY KEY (SSN),
  FOREIGN KEY (SSN) REFERENCES Person (SSN)
);

CREATE TABLE Is_Producing (
  ID text NOT NULL,
  Company_ID text NOT NULL,
  PRIMARY KEY (ID, Company_ID),
  FOREIGN KEY (ID) REFERENCES Main_class (ID),
  FOREIGN KEY (Company_ID) REFERENCES Production (Company_ID)
);

CREATE TABLE Nomination_MainClass (
  ID text NOT NULL,
  Year int NOT NULL,
  Award_Name text NOT NULL,
  Category text NOT NULL,
  Won int,
  PRIMARY KEY (ID, Year, Award_Name, Category),
  FOREIGN KEY (ID) REFERENCES Main_class (ID),
  FOREIGN KEY (Year, Award_Name, Category) REFERENCES Awards (Year, Award_Name, Category)
);

CREATE TABLE Air_info_Movies (
  id serial PRIMARY KEY,
  movieid text NOT NULL,
  locationid int NOT NULL,
  Release_title text,
  Run_time text,
  Release_date int,
  Certificate text,
  Parental_Guidance text,
  FOREIGN KEY (movieid) REFERENCES Movie (ID),
  FOREIGN KEY (locationid) REFERENCES Location (id)
);

CREATE TABLE episode_releases_in (
  id serial PRIMARY KEY,
  episodeid text NOT NULL,
  locationid int NOT NULL,
  Release_title text,
  Run_time text,
  Release_date int,
  Parental_guidance text,
  FOREIGN KEY (locationid) REFERENCES Location (id),
  FOREIGN KEY (episodeid) REFERENCES Episode (episodeid)
);

CREATE TABLE air_info_Series (
  id serial PRIMARY KEY,
  seriesid text NOT NULL,
  locationid int NOT NULL,
  Release_title text,
  Start_date int,
  End_date int,
  Certificate text,
  Is_Running int,
  FOREIGN KEY (locationid) REFERENCES Location (id),
  FOREIGN KEY (seriesid) REFERENCES Series (ID)
);

CREATE TABLE User_Rates_Reviews_in_movies (
  ID text NOT NULL,
  SSN text NOT NULL,
  Rating float,
  Review text,
  PRIMARY KEY (ID, SSN),
  FOREIGN KEY (ID) REFERENCES Movie (ID),
  FOREIGN KEY (SSN) REFERENCES Users (SSN)
);

CREATE TABLE User_Rates_Reviews_in_series (
  SSN text NOT NULL,
  episodeid text NOT NULL,
  Rating float,
  Review text,
  PRIMARY KEY (SSN, episodeid),
  FOREIGN KEY (SSN) REFERENCES Users (SSN),
  FOREIGN KEY (episodeid) REFERENCES Episode (episodeid)
);

CREATE TABLE Cast_Crew (
  SSN text NOT NULL,
  PRIMARY KEY (SSN),
  FOREIGN KEY (SSN) REFERENCES Person (SSN)
);

CREATE TABLE Nomination_People (
  SSN text NOT NULL,
  Year int NOT NULL,
  Award_Name text NOT NULL,
  Category text NOT NULL,
  Won int,
  PRIMARY KEY (Year, Award_Name, Category, SSN),
  FOREIGN KEY (Year, Award_Name, Category) REFERENCES Awards (Year, Award_Name, Category),
  FOREIGN KEY (SSN) REFERENCES Cast_Crew (SSN)
);

CREATE TABLE Partofepisode (
  SSN text NOT NULL,
  episodeid text NOT NULL,
  Role TEXT,
  PRIMARY KEY (SSN, episodeid),
  FOREIGN KEY (SSN) REFERENCES Cast_Crew (SSN),
  FOREIGN KEY (episodeid) REFERENCES Episode (episodeid)
);

CREATE TABLE Part_of_movie (
  SSN text NOT NULL,
  ID text NOT NULL,
  Role TEXT,
  PRIMARY KEY (SSN, ID),
  FOREIGN KEY (SSN) REFERENCES Cast_Crew (SSN),
  FOREIGN KEY (ID) REFERENCES Movie (ID)
);

