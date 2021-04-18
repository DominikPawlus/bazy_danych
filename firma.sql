
-- cw1
CREATE DATABASE firma;

--cw2
CREATE SCHEMA rozliczenia;

--cw3
CREATE TABLE pracownicy(
	id_pracownika SERIAL,
	imie varchar(25) NOT NULL, 
	nazwisko varchar(30) NOT NULL, 
	adres varchar(40) NOT NULL, 
	telefon int NOT NULL, 
	PRIMARY KEY (id_pracownika));
	
CREATE TABLE godziny(
	id_godziny SERIAL, 
	data_ date NOT NULL, 
	liczba_godzin int NOT NULL, 
	id_pracownika int, 
	PRIMARY KEY (id_godziny));
	
CREATE TABLE premie(
	id_premii SERIAL, 
	rodzaj varchar(20), 
	kwota int, 
	PRIMARY KEY (id_premii));
	
CREATE TABLE pensje(
	id_pensji SERIAL, 
	stanowisko varchar(30) NOT NULL, 
	kwota int not null, 
	id_premii int, 
	PRIMARY KEY (id_pensji));
	
ALTER TABLE godziny
	ADD FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika);
	
ALTER TABLE pensje
	ADD FOREIGN KEY (id_premii) REFERENCES premie(id_premii);

--cw4
INSERT INTO pracownicy(imie, nazwisko, adres, telefon)
	VALUES('Bazyli', 'Barnaba', 'Toussaint', 784672018), ('Stefan', 'Kołaczkowski', 'Kraków', 674563872), ('Michaił', 'Tal', 'Ryga', 66836720), ('Geralt', 'Z Rivii', 'Rivia', 758352637), ('Zofia', 'Nałkowska', 'Warszawa', 655534625), ('Eddie', 'Hall', 'Londyn', 787676565), ('Robert', 'Biedroń', 'Krosno', 567456019), ('Fakir', 'Michał', 'Kair', 63546785), ('Ragnar', 'Lodbrok', 'Kattegatt', 77745633), ('Tyrion', 'Lannister', 'Kings Landing', 786543245);

INSERT INTO godziny(data_, liczba_godzin, id_pracownika)
	VALUES('2018-02-12', 175, 1), ('2018-03-13', 144, 2), ('2018-03-14', 160, 3), ('2018-05-14', 160, 4), ('2019-02-17', 163, 5), ('2019-10-23', 148, 6), ('2019-02-01', 197, 7), ('2020-07-22', 165, 8), ('2020-09-17', 170, 9), ('2021-01-21', 200, 10);

INSERT INTO premie(rodzaj, kwota)
	VALUES('Miesięczna', 1000), ('Miesięczna', 2000), ('Miesięczna', 3000), ('Kwartalna', 5000), ('Kwartalna', 5000), ('Kwartalna', 5000), ('Roczna', 10000), ('Roczna', 15000), ('Roczna', 20000), ('Roczna', 25000);

INSERT INTO pensje(stanowisko, kwota, id_premii)
	VALUES('majordomus', 4000, 8), ('krytyk', 3500, 4), ('szachista', 1000, 10), ('wiedźmin', 10000, 9), ('pisarka', 45000, 1), ('strongman', 3000, 5), ('polityk', 8000, 2), ('portier', 2500, 3), ('jarl', 15000, 6), ('starszy nad monetą', 12000, 7);
	
--cw5
SELECT nazwisko, adres FROM pracownicy;

--cw6
SELECT data_, EXTRACT(WEEK FROM data_), EXTRACT(MONTH FROM data_) FROM godziny;

--cw7
ALTER TABLE pensje 
	RENAME COLUMN kwota TO kwota_brutto;
	
ALTER TABLE pensje ADD kwota_netto int;

UPDATE pensje SET kwota_netto = kwota_brutto / 1.23;