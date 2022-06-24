INSERT INTO role(name) VALUES('actress');
INSERT INTO role(name) VALUES('actor');
INSERT INTO role(name) VALUES('director');
INSERT INTO role(name) VALUES('writer');

SELECT * FROM role;

INSERT INTO titletype(name)
SELECT name FROM [35.193.226.141].IMDB.dbo.titletype;

SELECT * FROM titletype;

INSERT INTO genre(name)
SELECT name FROM [35.193.226.141].IMDB.dbo.genre;

SELECT * FROM genre;

INSERT INTO person(id, name)
SELECT id, primaryName FROM [35.193.226.141].IMDB.dbo.name;

SELECT * FROM person;