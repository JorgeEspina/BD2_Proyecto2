SELECT Name from sys.databases;

CREATE DATABASE IMDB;

use IMDB;

-- CREACION DE TABLAS TEMPORALES

CREATE TABLE namebasics(
    nconst VARCHAR(115),
    primaryname VARCHAR(115),
    birthyear VARCHAR(45),
    deathyear VARCHAR(45),
    primaryProfession VARCHAR(115),
    knownforTitles VARCHAR(115)
);

BULK INSERT namebasics
FROM '/home/canchemolinas/namebasics.tsv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
);

CREATE TABLE titlebasics(
    tconst VARCHAR(45),
    titleType VARCHAR(155),
    primaryTitle VARCHAR(455),
    originalTitle VARCHAR(455),
    isAdult VARCHAR(125),
    startYear VARCHAR(45),
    endYear VARCHAR(45),
    runtimeMinutes VARCHAR(45),
    genres VARCHAR(45)
);

-- drop TABLE titlebasics;

BULK INSERT titlebasics
FROM '/home/canchemolinas/titlebasics.tsv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
);

CREATE TABLE titlecrew(
    tconst VARCHAR(45),
    directors VARCHAR(MAX),
    writers VARCHAR(MAX)
);

--drop table titlecrew;

BULK INSERT titlecrew
FROM '/home/canchemolinas/titlecrew.tsv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
);

CREATE TABLE titleepisode(
    tconst VARCHAR(45),
    parentConst VARCHAR(45),
    seasonnumber VARCHAR(11),
    episodenumber VARCHAR(11)
);

BULK INSERT titleepisode
FROM '/home/canchemolinas/titleepisode.tsv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
);

CREATE TABLE titleprincipals(
    tconst VARCHAR(45),
    ordering VARCHAR(7),
    nconst VARCHAR(45),
    category VARCHAR(45),
    job VARCHAR(1000),
    characters VARCHAR(6000)
);

-- drop table titleprincipals;

BULK INSERT titleprincipals
FROM '/home/canchemolinas/titleprincipals.tsv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
);

CREATE TABLE titleratings(
    tconst VARCHAR(45),
    averageRating VARCHAR(11),
    numVotes VARCHAR(11)
);

BULK INSERT titleratings
FROM '/home/canchemolinas/titleratings.tsv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
);

select count(*) from namebasics;
SELECT count(*) FROM titlebasics;
SELECT count(*) FROM titlecrew;
SELECT count(*) FROM titleepisode;
SELECT count(*) FROM titleprincipals;
SELECT count(*) FROM titleratings;

-- CREACION DE TABLAS DEL MODELO ER

create table genre(
    id int IDENTITY(1,1),
    name VARCHAR(75),
    PRIMARY KEY (id)
);

CREATE TABLE titletype(
    id int IDENTITY(1,1),
    name VARCHAR(75),
    PRIMARY KEY(id)
);

CREATE TABLE title(
    id VARCHAR(45),
    titleTypeId int,
    primaryTitle VARCHAR(500),
    originalTitle VARCHAR(500),
    isAdult int,
    startYear int,
    endYear int,
    runtime int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleTypeId) REFERENCES titletype(id)
);

CREATE TABLE titleGenre(
    titleId VARCHAR(45),
    genreId int,
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (genreId) REFERENCES genre(id)
);

CREATE TABLE name(
    id VARCHAR(45),
    primaryName VARCHAR(115),
    birthYear int,
    deathYear int,
    PRIMARY KEY (id)
);

CREATE TABLE profession(
    id int IDENTITY(1,1),
    name VARCHAR(115),
    PRIMARY KEY(id)
);

CREATE TABLE nameProfession(
    nameId VARCHAR(45),
    professionId int,
    FOREIGN KEY(nameId) REFERENCES name(id),
    FOREIGN KEY(professionId) REFERENCES profession(id)
);

CREATE TABLE category(
    id int IDENTITY(1,1),
    name varchar(115),
    PRIMARY KEY(id)
);

CREATE TABLE principal(
    id int IDENTITY(1,1),
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    categoryId int,
    jobId VARCHAR(1000),
    orden VARCHAR(45),
    character VARCHAR(6000),
    PRIMARY KEY (id),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (categoryId) REFERENCES category(id)
);

CREATE TABLE knowForTitle(
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE director(
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE writer(
    nameId VARCHAR(45),
    titleId VARCHAR(45),
    FOREIGN KEY (nameId) REFERENCES name(id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE rating(
    id int IDENTITY(1,1),
    titleId VARCHAR(45),
    averageRating DECIMAL,
    numVotes int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE episode(
    id int IDENTITY(1,1),
    titleId VARCHAR(45),
    parentId VARCHAR(45),
    season int,
    episode int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (parentId) REFERENCES title(id)
);

CREATE TABLE region(
    id int IDENTITY(1,1),
    name VARCHAR(55),
    PRIMARY KEY(id)
);

CREATE TABLE language(
    id int IDENTITY(1,1),
    name VARCHAR(55),
    PRIMARY KEY(id)
);

CREATE TABLE alternativeType(
    id int IDENTITY(1,1),
    name VARCHAR(55),
    PRIMARY KEY(id)
);

CREATE TABLE alternativeAttribute(
    id int IDENTITY(1,1),
    name VARCHAR(55),
    PRIMARY KEY(id)
);

CREATE TABLE alternativeTitle(
    id int IDENTITY(1,1),
    titleId VARCHAR(45),
    regionId int,
    languageId int,
    alternativeTypeId int,
    alternativeAttributeId int,
    title VARCHAR(500),
    ordering int,
    isOriginal int,
    PRIMARY KEY(id),
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (regionId) REFERENCES region(id),
    FOREIGN KEY (languageId) REFERENCES language(id),
    FOREIGN KEY (alternativeTypeId) REFERENCES alternativeType(id),
    FOREIGN KEY (alternativeAttributeId) REFERENCES alternativeAttribute(id)
);