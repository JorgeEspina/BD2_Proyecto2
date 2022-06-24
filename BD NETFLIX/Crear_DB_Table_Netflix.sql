CREATE DATABASE NETFLIX;

use NETFLIX;

EXEC sp_addlinkedserver
    @server = N'35.193.226.141',
    @srvproduct = N'SQL Server';



CREATE TABLE titletype(
    id int IDENTITY(1,1),
    name VARCHAR(115),
    PRIMARY KEY (id)
);

CREATE TABLE genre(
    id int IDENTITY(1,1),
    name VARCHAR(115),
    PRIMARY KEY (id)
);

CREATE TABLE title(
    id VARCHAR(115),
    primaryTitle VARCHAR(600),
    isAdult int,
    startYear int,
    endYear int,
    runtime int,
    description VARCHAR(5000),
    titleTypeId int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleTypeId) REFERENCES titletype(id)
);

CREATE TABLE title_genre(
    genreId int,
    titleId VARCHAR(115),
    PRIMARY KEY (genreId, titleId),
    FOREIGN KEY (genreId) REFERENCES genre(id),
    FOREIGN KEY (titleId) REFERENCES title(id)
);

CREATE TABLE episode(
    id int IDENTITY(1,1),
    season int,
    episode int,
    titleId VARCHAR(115),
    parentId VARCHAR(115),
    PRIMARY KEY (id),
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (parentId) REFERENCES title(id)
);

CREATE TABLE person(
    id VARCHAR(115),
    name VARCHAR(115),
    PRIMARY KEY (id)
);

CREATE TABLE role(
    id int IDENTITY(1,1),
    name VARCHAR(45),
    PRIMARY KEY (id)
);

CREATE TABLE crew(
    id int IDENTITY(1,1),
    titleId VARCHAR(115),
    personId VARCHAR(115),
    roleId int,
    PRIMARY KEY (id),
    FOREIGN KEY (titleId) REFERENCES title(id),
    FOREIGN KEY (personId) REFERENCES person(id),
    FOREIGN KEY (roleId) REFERENCES role(id)
);



