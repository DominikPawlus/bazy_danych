DROP DATABASE firma;
DROP SCHEMA ksiegowosc;

-- cw1
CREATE DATABASE firma;

-- cw2
CREATE SCHEMA ksiegowosc;

USE firma;
USE ksiegowosc;

-- cw3
CREATE TABLE pracownicy(
	id_pracownika int NOT NULL AUTO_INCREMENT,
	imie varchar(25) NOT NULL, 
	nazwisko varchar(30) NOT NULL, 
	adres varchar(40) NOT NULL, 
	telefon int NOT NULL, 
	PRIMARY KEY (id_pracownika));
	
CREATE TABLE godziny(
	id_godziny int NOT NULL AUTO_INCREMENT, 
	data_ date NOT NULL, 
	liczba_godzin int NOT NULL, 
	id_pracownika int, 
	PRIMARY KEY (id_godziny),
    FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika));
	
CREATE TABLE premie(
	id_premii int NOT NULL AUTO_INCREMENT, 
	rodzaj varchar(20), 
	kwota int, 
	PRIMARY KEY (id_premii));
	
CREATE TABLE pensje(
	id_pensji int NOT NULL AUTO_INCREMENT, 
	stanowisko varchar(30) NOT NULL, 
	kwota int NOT NULL, 
	id_premii int, 
	PRIMARY KEY (id_pensji),
    FOREIGN KEY (id_premii) REFERENCES premie(id_premii));
    
CREATE TABLE wynagrodzenia(
	id_wynagrodzenia int NOT NULL AUTO_INCREMENT,
    data_ date,
    id_pracownika int,
    id_godziny int,
    id_pensji int,
    id_premii int, 
    PRIMARY KEY (id_wynagrodzenia),
    FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika),
    FOREIGN KEY (id_godziny) REFERENCES godziny(id_godziny),
    FOREIGN KEY (id_pensji) REFERENCES pensje(id_pensji),
    FOREIGN KEY (id_premii) REFERENCES premie(id_premii));

-- cw4
INSERT INTO pracownicy(imie, nazwisko, adres, telefon)
	VALUES('Bazylia', 'Barnaba', 'Toussaint', 784672018), ('Stefan', 'Kołaczkowski', 'Kraków', 674563872), ('Michaił', 'Tal', 'Ryga', 66836720), ('Geralt', 'Z Rivii', 'Rivia', 758352637), ('Jadwiga', 'Nałkowska', 'Warszawa', 655534625), ('Eddie', 'Hall', 'Londyn', 787676565), ('Robert', 'Biedroń', 'Krosno', 567456019), ('Fakir', 'Michał', 'Kair', 63546785), ('Ragnar', 'Lodbrok', 'Kattegatt', 77745633), ('Tyrion', 'Lannister', 'Kings Landing', 786543245);

INSERT INTO godziny(data_, liczba_godzin, id_pracownika)
	VALUES('2018-02-12', 175, 1), ('2018-03-13', 144, 2), ('2018-03-14', 160, 3), ('2018-05-14', 160, 4), ('2019-02-17', 163, 5), ('2019-10-23', 148, 6), ('2019-02-01', 197, 7), ('2020-07-22', 165, 8), ('2020-09-17', 170, 9), ('2021-01-21', 200, 10);

INSERT INTO premie(rodzaj, kwota)
	VALUES('Miesięczna', 0), ('Miesięczna', 2000), ('Miesięczna', 3000), ('Kwartalna', 5000), ('Kwartalna', 5000), ('Kwartalna', 5000), ('Roczna', 10000), ('Roczna', 15000), ('Roczna', 20000), ('Roczna', 25000);

INSERT INTO pensje(stanowisko, kwota, id_premii)
	VALUES('majordomus', 4000, 8), ('portier', 3500, 4), ('szachista', 3000, 1), ('manager', 10000, 9), ('pisarka', 45000, 1), ('manager', 3000, 5), ('polityk', 8000, 2), ('portier', 2500, 3), ('manager', 15000, 6), ('starszy nad monetą', 12000, 7);

INSERT INTO wynagrodzenia(data_, id_pracownika, id_godziny, id_pensji, id_premii)
values ('2018-02-12',1,1,1,8),('2018-03-13',2,2,2,4),('2018-03-14',3,3,3,10),('2018-05-14',4,4,4,9),('2019-02-17',5,5,5,1),('2019-10-23',6,6,6,5),('2019-02-01',7,7,7,2),('2020-07-22',8,8,8,3),('2020-09-17',9,9,9,6),('2021-01-21',10,10,10,7);

-- cw5
-- a
SELECT id_pracownika,adres FROM pracownicy; 

-- b
SELECT pracownicy.id_pracownika, pensje.kwota 
from pracownicy INNER JOIN (pensje INNER JOIN wynagrodzenia ON pensje.id_pensji = wynagrodzenia.id_pensji) ON pracownicy.id_pracownika = wynagrodzenia.id_pracownika 
WHERE pensje.kwota > 1000.00;

-- c
SELECT pracownicy.id_pracownika
FROM pracownicy INNER JOIN (pensje INNER JOIN (premie INNER JOIN wynagrodzenia ON premie.id_premii = wynagrodzenia.id_premii) ON pensje.id_pensji = wynagrodzenia.id_pensji) 
ON pracownicy.id_pracownika = wynagrodzenia.id_pracownika
WHERE premie.kwota = 0 AND pensje.kwota > 2000;

-- d
SELECT * FROM pracownicy WHERE imie LIKE 'J%';

-- e
SELECT * FROM pracownicy 
WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';

-- f
SELECT imie, nazwisko, liczba_godzin - 160 AS nadgodziny
FROM pracownicy INNER JOIN godziny ON pracownicy.id_pracownika = godziny.id_pracownika
where godziny.liczba_godzin > 160;

-- g
SELECT pracownicy.imie, pracownicy.nazwisko, pensje.kwota
FROM pracownicy INNER JOIN (pensje INNER JOIN wynagrodzenia ON pensje.id_pensji = wynagrodzenia.id_pensji) ON pracownicy.id_pracownika = wynagrodzenia.id_pracownika 
WHERE pensje.kwota BETWEEN 1500 AND 3000;

-- h
SELECT imie, nazwisko FROM ksiegowosc.pracownicy INNER JOIN (ksiegowosc.godziny INNER JOIN
(ksiegowosc.premie INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.premie.id_premii = ksiegowosc.wynagrodzenia.id_premii)
ON ksiegowosc.godziny.id_godziny = ksiegowosc.wynagrodzenia.id_godziny)
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenia.id_pracownika
WHERE ksiegowosc.godziny.liczba_godzin > 160 AND ksiegowosc.premie.kwota = 0;

-- i
SELECT * FROM pracownicy
INNER JOIN wynagrodzenia ON pracownicy.id_pracownika = wynagrodzenia.id_pracownika 
INNER JOIN pensje ON pensje.id_pensji = wynagrodzenia.id_pensji 
ORDER BY pensje.kwota;

-- j
SELECT * FROM pracownicy INNER JOIN (pensje INNER JOIN (premie INNER JOIN wynagrodzenia ON premie.id_premii = wynagrodzenia.id_premii) ON pensje.id_pensji = wynagrodzenia.id_pensji) 
ON pracownicy.id_pracownika = wynagrodzenia.id_pracownika
ORDER BY pensje.kwota DESC, premie.kwota DESC;

-- k
SELECT stanowisko, COUNT(pensje.stanowisko)
FROM pensje
GROUP BY stanowisko;

-- l
SELECT MAX(pensje.kwota), MIN(pensje.kwota), AVG(pensje.kwota)
FROM pensje
WHERE stanowisko = 'manager';

-- m
SELECT SUM(pensje.kwota)
FROM pensje;

-- n
SELECT stanowisko, SUM(pensje.kwota)
FROM pensje
GROUP BY stanowisko;

-- o
SELECT stanowisko, COUNT(premie.kwota) 
FROM premie INNER JOIN (pensje INNER JOIN wynagrodzenia ON pensje.id_pensji = wynagrodzenia.id_pensji) ON premie.id_premii = wynagrodzenia.id_premii
GROUP BY stanowisko;

-- p
SET FOREIGN_KEY_CHECKS = 0;
DELETE pensje,premie,godziny
FROM pracownicy INNER JOIN (pensje INNER JOIN (premie INNER JOIN (godziny INNER JOIN wynagrodzenia ON godziny.id_godziny = wynagrodzenia.id_godziny) ON premie.id_premii = wynagrodzenia.id_premii) ON pensje.id_pensji = wynagrodzenia.id_pensji)
WHERE pensje.kwota < 1200;
SET FOREIGN_KEY_CHECKS = 1;

