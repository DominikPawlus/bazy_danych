DROP DATABASE firma;
DROP SCHEMA ksiegowosc;

CREATE DATABASE firma;

CREATE SCHEMA ksiegowosc;

USE firma;
USE ksiegowosc;

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

-- a
UPDATE ksiegowosc.pracownicy
SET telefon = CONCAT('(+48) ', telefon );
SELECT telefon FROM ksiegowosc.pracownicy;

-- b
UPDATE ksiegowosc.pracownicy
SET telefon = SUBSTRING(telefon, 1, 9)+'-'+
             SUBSTRING(telefon, 10, 3)+'-'+
             SUBSTRING(telefon, 14, 3);
SELECT telefon FROM ksiegowosc.pracownicy;

-- c
SELECT  upper(nazwisko), LENGTH(nazwisko) nazwisko_len FROM ksiegowosc.pracownicy ORDER BY nazwisko_len DESC , nazwisko DESC LIMIT 1;

-- d
SELECT  md5(imie) md_imie, md5(nazwisko) md_nazwisko, md5(adres) md_adres, md5(telefon) md_telefon FROM ksiegowosc.pracownicy;

-- e
SELECT pracownicy.id_pracownika, pracownicy.imie, pracownicy.nazwisko, pensje.kwota AS pensja, premie.kwota AS premia 
FROM ksiegowosc.pracownicy left JOIN (ksiegowosc.pensje left JOIN (ksiegowosc.premie left JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.premie.id_premii = ksiegowosc.wynagrodzenia.id_premii)
ON ksiegowosc.pensje.id_pensji = ksiegowosc.wynagrodzenia.id_pensji) 
ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenia.id_pracownika;

-- f
SELECT CONCAT('Pracownik ', imie, ' ', nazwisko, ' w dniu ', data_wynagrodzenia, ' otrzymał ',
(pensje.kwota + premie.kwota), 'zł. Wynagrodzenie zasadnicze = ', CAST(pensje.kwota AS CHAR(10)), ' premie: ',
premie.kwota, ' nadgodziny: ', premie.kwota) AS raport
FROM ksiegowosc.pracownicy INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenia.id_pracownika
INNER JOIN ksiegowosc.pensje ON ksiegowosc.wynagrodzenia.id_pensji = ksiegowosc.pensje.id_pensji
INNER JOIN ksiegowosc.premie ON ksiegowosc.wynagrodzenia.id_premii = ksiegowosc.premie.id_premii

