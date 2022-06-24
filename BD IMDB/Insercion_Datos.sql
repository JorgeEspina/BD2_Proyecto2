INSERT into category
SELECT distinct category from titleprincipals;

INSERT into titletype
SELECT distinct titleType FROM titlebasics;

INSERT into genre
SELECT distinct gen.[value] FROM titlebasics CROSS APPLY string_split(genres, ',') gen WHERE genres != '\N';

INSERT into profession
SELECT distinct prof.[value] from namebasics CROSS APPLY string_split(primaryProfession, ',') prof;

UPDATE namebasics SET birthyear = '0' WHERE birthyear = '\N';
UPDATE namebasics SET deathyear = '0' WHERE deathyear = '\N';

ALTER TABLE namebasics ALTER COLUMN birthyear int;
ALTER TABLE namebasics ALTER COLUMN deathyear int;

INSERT into name
SELECT distinct nconst, primaryname, birthyear, deathyear FROM namebasics;

INSERT into nameProfession
SELECT distinct nconst, p.id FROM namebasics nb CROSS APPLY string_split(primaryProfession, ',') prof
INNER JOIN profession p ON prof.[value] = p.name;

UPDATE titlebasics SET startYear = '0' WHERE startYear = '\N';
UPDATE titlebasics SET endYear = '0' WHERE endYear = '\N';
UPDATE titlebasics SET runtimeMinutes = '0' WHERE runtimeMinutes = '\N';

ALTER TABLE titlebasics ALTER COLUMN startYear int;
ALTER TABLE titlebasics ALTER COLUMN endYear int;
ALTER TABLE titlebasics ALTER COLUMN runtimeMinutes int;
ALTER TABLE titlebasics ALTER COLUMN isAdult int;

ALTER TABLE title ALTER COLUMN primaryTitle VARCHAR(455);
ALTER TABLE title ALTER COLUMN originalTitle VARCHAR(455);

INSERT into title
SELECT distinct tb.tconst, tt.id, tb.primaryTitle, tb.originalTitle,
tb.isAdult, tb.startYear, tb.endYear, tb.runtimeMinutes FROM titlebasics tb
INNER JOIN titletype tt on tb.titleType = tt.name;

INSERT into titleGenre
SELECT distinct tb.tconst, g.id FROM titlebasics tb CROSS APPLY string_split(tb.genres, ',') gen
INNER JOIN genre g ON gen.[value] = g.name;

-- VERIFICAR PRINCIPAL
INSERT into principal(nameId, titleId, categoryId, jobId, orden, [character])
SELECT distinct n.id, tt.id, cg.id, tp.job, tp.ordering, tp.characters
FROM titleprincipals tp INNER JOIN category cg ON tp.category = cg.name
INNER JOIN name n ON tp.nconst = n.id INNER JOIN title tt on tp.tconst = tt.id
WHERE tp.nconst != '\N' AND tp.tconst != '\N';

INSERT into knowForTitle
SELECT distinct n.id, t.id FROM namebasics nb
CROSS APPLY string_split(nb.knownforTitles, ',') kt
INNER JOIN name n ON nb.nconst = n.id INNER JOIN title t on kt.[value] = t.id
WHERE nb.nconst != '\N' AND kt.[value] != '\N';

INSERT into director (nameId, titleId)
SELECT n.id, t.id FROM titlecrew tcw CROSS APPLY string_split(tcw.directors, ',') dir
INNER JOIN name n ON n.id = dir.[value] INNER JOIN title t ON t.id = tcw.tconst;

INSERT into writer (nameId, titleId)
SELECT n.id, t.id FROM titlecrew tcw CROSS APPLY string_split(tcw.writers, ',') wr
INNER JOIN name n ON n.id = wr.[value] INNER JOIN title t ON t.id = tcw.tconst;

UPDATE titleepisode SET seasonnumber = '0' WHERE seasonnumber = '\N';
UPDATE titleepisode SET episodenumber = '0' WHERE episodenumber = '\N';

ALTER TABLE titleepisode ALTER COLUMN seasonnumber int;
ALTER TABLE titleepisode ALTER COLUMN episodenumber int;

INSERT into episode(titleId, parentId, season, episode)
SELECT tit.id, parent.id, tep.seasonnumber, tep.episodenumber FROM titleepisode tep INNER JOIN title parent
ON tep.parentConst = parent.id INNER JOIN title tit ON tep.tconst = tit.id;

ALTER TABLE titleratings ALTER COLUMN averageRating DECIMAL;
ALTER TABLE titleratings ALTER COLUMN numVotes int;

INSERT into rating (titleId, averageRating, numVotes)
SELECT t.id, tr.averageRating, tr.numVotes FROM titleratings tr INNER JOIN title t ON tr.tconst = t.id;

SELECT n.primaryName, prof.name FROM nameProfession names INNER JOIN name n ON names.nameId = n.id
INNER JOIN profession prof ON names.professionId = prof.id WHERE prof.name = 'actress' OR prof.name = 'actor'
OR prof.name = 'writer' OR prof.name = 'director';

SELECT * FROM writer;
SELECT * FROM category;

EXEC sp_addlinkedserver
    @server = N'172.17.0.2',
    @srvproduct = N'SQL Server';
GO

SELECT name FROM [172.17.0.2].master.sys.databases;