CREATE DATABASE GeoStrat;
USE GeoStrat;

CREATE TABLE GeoEon (
    id_eon INT NOT NULL AUTO_INCREMENT,
    nazwa_eon VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_eon)
);

CREATE TABLE GeoEra (
    id_era INT NOT NULL AUTO_INCREMENT,
    id_eon INT,
    nazwa_era VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_era),
    FOREIGN KEY (id_eon)
        REFERENCES GeoEon (id_eon)
);

CREATE TABLE GeoOkres (
    id_okres INT NOT NULL AUTO_INCREMENT,
    id_era INT,
    nazwa_okres VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_okres),
    FOREIGN KEY (id_era)
        REFERENCES GeoEra (id_era)
);

CREATE TABLE GeoEpoka (
    id_epoka INT NOT NULL AUTO_INCREMENT,
    id_okres INT,
    nazwa_epoka VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_epoka),
    FOREIGN KEY (id_okres)
        REFERENCES GeoOkres (id_okres)
);

CREATE TABLE GeoPietro (
    id_pietro INT NOT NULL AUTO_INCREMENT,
    id_epoka INT,
    nazwa_pietro VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_pietro),
    FOREIGN KEY (id_epoka)
        REFERENCES GeoEpoka (id_epoka)
);

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO GeoEon(nazwa_eon)
VALUES('FANEROZOIK');

INSERT INTO GeoEra(id_eon, nazwa_era)
VALUES(1, 'Kenozoik'), (1, 'Mezozoik'), (1, 'Paleozoik');

INSERT INTO GeoOkres(id_era, nazwa_okres)
VALUES(1, 'Czwartorzęd'), (1, 'Neogen'), (1, 'Paleogen'), (2, 'Kreda'), (2, 'Jura'), (2, 'Trias'), (3, 'Perm'), (3, 'Karbon'), (3, 'Dewon'), (3, 'Sylur'), (3, 'Ordowik'), (3, 'Kambr');

INSERT INTO GeoEpoka(id_okres, nazwa_epoka)
VALUES(1, 'Holocen'), (1, 'Plejstocen'),
(2, 'Pliocen'), (2, 'Miocen'),
(3, 'Oligocen'), (3, 'Eocen'), (3, 'Paleocen'),
(4, 'Górna'), (4, 'Dolna'),
(5, 'Górna'), (5, 'Środkowa'), (5, 'Dolna'),
(6, 'Górny'), (6, 'Środkowy'), (6, 'Dolny'),
(7, 'Górny'), (7, 'Dolny'),
(8, 'Górny'), (8, 'Dolny'),
(9, 'Górny'), (9, 'Środkowy'), (9, 'Dolny'),
(10, 'Przydol'), (10, 'Ludlow'), (10, 'Wenlok'), (10, 'Landower'),
(11, 'Górny'), (11, 'Środkowy'), (11, 'Dolny'),
(12, 'Furong'), (12, 'Środkowy'), (12, 'Dolny');

INSERT INTO GeoPietro(id_epoka, nazwa_pietro)
VALUES(2, 'Górny'), (2, 'Środkowy'), (2, 'Dolny'),
(3, 'Gelas'), (3, 'Piacent'), (3, 'Zankl'),
(4, 'Mesyn'), (4, 'Torton'), (4, 'Serrawal'), (4, 'Lang'), (4, 'Burdygał'), (4, 'Akwitan'),
(5, 'Szat'), (5, 'Rupel'),
(6, 'Priabon'), (6, 'Barton'), (6, 'Lutet'), (6, 'Iprez'),
(7, 'Tanet'), (7, 'Zeland'), (7, 'Dan'),
(8, 'Mastrycht'), (8, 'Kampan'), (8, 'Santon'), (8, 'Koniak'), (8, 'Turon'), (8, 'Cenoman'),
(9, 'Alb'), (9, 'Apt'), (9, 'Barrem'), (9, 'Hoteryw'), (9, 'Walanżyn'), (9, 'Berias'),
(10, 'Tyton'), (10, 'Kimeryd'), (10, 'Oksford'),
(11, 'Kelowej'), (11, 'Baton'), (11, 'Bajos'), (11, 'Aalen'),
(12, 'Toark'), (12, 'Pliensbach'), (12, 'Synemur'), (12, 'Hetang'),
(13, 'Retyk'), (13, 'Noryk'), (13, 'Karnik'),
(14, 'Ladyn'), (14, 'Anizyk'),
(15, 'Olenek'), (15, 'Ind'),
(16, 'Tatar'), (16, 'Kazań'), (16, 'Ufa'),
(17, 'Kungur'), (17, 'Artinsk'), (17, 'Sakmar'), (17, 'Assel'),
(18, 'Stefan'), (18, 'Westfal'),(18,'Namur'), 
(19, 'Wizen'), (19, 'Turnej'),
(20, 'Famen'), (20, 'Fran'),
(21, 'Żywet'), (21, 'Eifel'),
(22, 'Ems'), (22, 'Prag'), (22, 'Lochkow'),
(27, 'Aszgil'), (27, 'Karadok'),
(28, 'Landeil'), (28, 'Lanwirn'),
(29, 'Arenig'), (29, 'Tremadok');


CREATE TABLE GeoTabela AS SELECT * FROM GeoPietro NATURAL JOIN GeoEpoka NATURAL JOIN GeoOkres NATURAL JOIN GeoEra NATURAL JOIN GeoEon;

CREATE TABLE Dziesiec (
    cyfra INT,
    bit INT
);

INSERT INTO Dziesiec(cyfra)
VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9);


CREATE TABLE Milion (
    liczba INT,
    cyfra INT,
    bit INT
);

INSERT INTO  Milion 
SELECT a1.cyfra + 10 * a2.cyfra + 100 * a3.cyfra + 1000 * a4.cyfra + 10000 * a5.cyfra + 100000 * a6.cyfra
 AS liczba, a1.cyfra AS cyfra, a1.bit AS bit FROM Dziesiec a1, Dziesiec a2, Dziesiec a3, Dziesiec a4, Dziesiec a5, Dziesiec a6;

-- INDEKSACJA
-- 1ZL
CREATE INDEX i ON GeoTabela (id_pietro);
CREATE INDEX J ON Milion(liczba);

-- 2ZL
DROP INDEX i on GeoTabela;
CREATE INDEX k on GeoPietro (id_pietro,nazwa_pietro);
CREATE INDEX l on GeoEpoka (id_epoka,nazwa_epoka);
CREATE INDEX m on GeoOkres (id_okres,nazwa_okres);
CREATE INDEX n on GeoEra (id_era,nazwa_era);
CREATE INDEX o on GeoEon (id_eon,nazwa_eon);

-- 3ZL
CREATE INDEX i on GeoTabela (id_pietro);
DROP INDEX k on GeoPietro;
DROP INDEX l on GeoEpoka;
DROP INDEX m on GeoOkres;
DROP INDEX n on GeoEra;
DROP INDEX o on GeoEon;

-- 4ZL
DROP INDEX i on GeoTabela;
CREATE INDEX k on GeoPietro (id_pietro,nazwa_pietro);
CREATE INDEX l on GeoEpoka (id_epoka,nazwa_epoka);
CREATE INDEX m on GeoOkres (id_okres,nazwa_okres);
CREATE INDEX n on GeoEra (id_era,nazwa_era);
CREATE INDEX o on GeoEon (id_eon,nazwa_eon);


SELECT COUNT(*) FROM Milion INNER JOIN GeoTabela ON (MOD(Milion.liczba, 88) = (GeoTabela.id_pietro));
    
SELECT COUNT(*) FROM Milion INNER JOIN GeoPietro ON (MOD(Milion.liczba, 88) = GeoPietro.id_pietro) NATURAL JOIN GeoEpoka NATURAL JOIN GeoOkres NATURAL JOIN GeoEra NATURAL JOIN GeoEon;
    
SELECT COUNT(*) FROM Milion WHERE MOD(Milion.liczba, 88) = (SELECT id_pietro FROM GeoTabela WHERE MOD(Milion.liczba, 88) = (id_pietro));
            
SELECT COUNT(*) FROM Milion WHERE MOD(Milion.liczba, 88) IN (SELECT GeoPietro.id_pietro FROM GeoPietro NATURAL JOIN GeoEpoka NATURAL JOIN GeoOkres NATURAL JOIN GeoEra NATURAL JOIN GeoEon);
