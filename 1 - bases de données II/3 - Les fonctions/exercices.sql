/*
Exercice 1 : Formatter une date en français
Écrire une fonction qui reçoit une date et la retourne sous la forme "Jour NomDuMois Année"
 (ex: "12 septembre 2024"). 
Comparez une approche manuelle avec `CASE` et une approche utilisant les fonctions natives de MySQL.
*/
use vod_esr;
drop function if exists ex1;
delimiter $$
create function ex1(d date)
	returns varchar(50)
    deterministic
begin
	declare j, m, a int;
    declare mm varchar(50);
    
    set j = day(d);
    set m = month(d);
    set a= year(d);
    

    set  mm = case m
    when 1 then 'Janvier'
    when 2 then 'Février'
    when 3 then 'Mars'
    when 4 then 'Avril'
    when 5 then 'Mai'
    when 6 then 'juin'
    when 7 then 'Juillet'
    when 8 then 'Aout'
    when 9 then 'Septembre'
    when 10 then 'octobre'
    when 11 then 'Novembre'
    when 12 then 'decembre'
    else
		'erreur'
    end;
	return concat(j, " " , mm, " ", a);
end $$
delimiter ;

select ex1('2026/11/05');


/*
Écrire une fonction qui reçoit deux dates (`DATETIME`) et une unité de calcul
 ('jour', 'mois', 'année', 'heure', etc.) et qui retourne l'écart entre les
 deux dates selon l'unité demandée.
*/

drop function if exists ex2;
delimiter $$
create function ex2(d1 datetime, d2 datetime, unite varchar(50))
	returns bigint
    deterministic
begin
	declare ecart bigint;
    set ecart = case unite
    when 'année' then timestampdiff(year, d1, d2)
    when 'mois' then timestampdiff(month, d1, d2)
    when 'jour' then timestampdiff(day, d1, d2)
    when 'heure' then timestampdiff(hour, d1, d2)
    when 'minute' then timestampdiff(minute, d1, d2)
    when 'seconde' then timestampdiff(second, d1, d2)
    else
    0
    end;
    
	return ecart;
end $$
delimiter ;

select ex2('2026/11/05 10:00:00', '2026/11/06 12:00:00', 'second');


DROP DATABASE IF EXISTS vols_esr;
CREATE DATABASE vols_esr COLLATE utf8mb4_general_ci;
USE vols_esr;

CREATE TABLE Pilote(numpilote INT AUTO_INCREMENT PRIMARY KEY, nom VARCHAR(50), villepilote VARCHAR(50), datedebut DATE);
CREATE TABLE Avion(numav INT AUTO_INCREMENT PRIMARY KEY, typeav VARCHAR(50), capav INT);
CREATE TABLE Vol(numvol INT AUTO_INCREMENT PRIMARY KEY, numpil INT NOT NULL, numav INT NOT NULL);

ALTER TABLE Vol ADD CONSTRAINT fk_vol_pilote FOREIGN KEY(numpil) REFERENCES Pilote(numpilote);
ALTER TABLE Vol ADD CONSTRAINT fk_vol_avion FOREIGN KEY(numav) REFERENCES Avion(numav);

INSERT INTO Avion(numav, typeav, capav) VALUES (1,'Boeing',350), (2,'Caravelle',250), (3,'Airbus',500), (4,'Concorde',150);
INSERT INTO Pilote(numpilote, nom, villepilote, datedebut) VALUES (1,'Hassan','Tétouan','2022-01-01'), (2,'Saida','Casablanca','2005-01-01'), (3,'Youssef','Tanger','2002-01-01');
INSERT INTO Vol(numvol, numpil, numav) VALUES (1,1,1), (2,1,1), (3,2,2), (4,2,2), (5,3,3), (6,3,3), (7,1,1), (8,1,1), (9,1,2), (10,1,2), (11,3,3), (12,3,3), (13,2,1), (14,3,1);


select * from avion;
select * from vol;
select * from pilote;
/*
Exercice 3 : Nombre de pilotes par volume de vols
Écrire une fonction qui retourne le nombre de pilotes
 ayant effectué un nombre de vols strictement supérieur à un seuil donné en paramètre.
*/
select * from vol;



drop function if exists ex3;
delimiter $$
create function ex3(n int)
	returns int
    deterministic
begin
	declare nb int;
    
    select count(*) into nb from (
							select numpil, count(*) 
                            from vol 
                            group by numpil 
                            having count(*)>n
                            ) as p;
    
    
	return nb;
end  $$
delimiter ;

select ex3(10);

/*
Exercice 4 : Ancienneté d'un pilote
Écrire une fonction qui retourne l'ancienneté (en années complètes) 
d'un pilote dont l'ID est passé en paramètre.
*/


drop function if exists ex4;
delimiter $$
create function if not exists ex4(id int)
	returns int
    deterministic
begin   
	declare anciennete int;
    
	select vod_esr.ex2(datedebut,curdate(),'année') into anciennete from pilote where numpilote = id;

	return anciennete;
end  $$
delimiter ;

select ex4(2);


/*
Exercice 5 : Avions non affectés
Écrire une fonction qui renvoie le nombre des avions qui ne sont pas du tout affectés à des vols.
*/

select * from avion;
select * from vol;

select count(*) from (
select * from avion where numav not in( select numav from vol)
) p;


with p as (
select * from avion where numav not in( select numav from vol)
)

select count(*) from p;



drop function if exists ex5;
delimiter $$
create function if not exists ex5()
	returns int
    deterministic
begin   
	declare nb int;
    
	with p as (
			select * from avion where numav not in( select numav from vol)
	)

	select count(*) into nb from p;

	return nb;
end  $$
delimiter ;

select ex5();
INSERT INTO Avion(numav, typeav, capav) VALUES (5,'Boeing',747);
select * from avion;
select ex5();


/*
Exercice 6
Écrire une fonction qui retourne le numéro du pilote le plus ancien (basé sur `datedebut`)
 ayant piloté un avion dont le numéro est passé en paramètre.
 */
 
 select numpilote
	 from vol v
	 join pilote p on v.numpil = p.numpilote
	 where numav = 1
	 order by  ex4(p.numpilote)  desc
	 limit 1;
 

 
 
drop function if exists ex6;
delimiter $$
create function if not exists ex6(na int)
	returns int
    deterministic
begin   
	declare np int;
    
	 select numpilote into np
	 from vol v
	 join pilote p on v.numpil = p.numpilote
	 where numav = na
	 order by  ex4(p.numpilote)  desc
	 limit 1;

	return np;
end  $$
delimiter ;

select ex6(1);


DROP DATABASE IF EXISTS employes_esr;
CREATE DATABASE employes_esr COLLATE 'utf8mb4_general_ci';
USE employes_esr;

CREATE TABLE DEPARTEMENT (ID_DEP INT AUTO_INCREMENT PRIMARY KEY, NOM_DEP VARCHAR(50), Ville VARCHAR(50));
CREATE TABLE EMPLOYE (ID_EMP INT AUTO_INCREMENT PRIMARY KEY, NOM_EMP VARCHAR(50), PRENOM_EMP VARCHAR(50), SALAIRE FLOAT, ID_DEP INT, CONSTRAINT fk_emp_dep FOREIGN KEY (ID_DEP) REFERENCES DEPARTEMENT(ID_DEP));

INSERT INTO DEPARTEMENT(NOM_DEP, Ville) VALUES ('FINANCIER','Tanger'), ('Informatique','Tétouan'), ('Marketing','Martil'), ('GRH','Mdiq');
INSERT INTO EMPLOYE(NOM_EMP, PRENOM_EMP, SALAIRE, ID_DEP) VALUES 
('said','said',8000,1), ('hassan','hassan',8500,1), ('khalid','khalid',7000,2),
('souad','souad',6500,2), ('Farida','Farida',5000,3), ('Amal','Amal',6000,4), ('Mohamed','Mohamed',7000,4);



select * from departement;
select * from employe;
/*
Exercice 7 : Création de fonctions statistiques globales
Créez quatre fonctions distinctes pour l'ensemble des employés : 
`nombre_total_employes()`, `somme_salaires()`, `salaire_minimum()` et
 `salaire_maximum()`. Puis, utilisez-les dans une seule requête pour afficher un tableau de bord global.
*/





drop function if exists nombre_total_employes;
delimiter $$
create function if not exists nombre_total_employes()
	returns int
    deterministic
begin   
	declare nb int;
    select count(*) into nb from employe;
	return nb;
end  $$
delimiter ;

select nombre_total_employes();



drop function if exists somme_salaire;
delimiter $$
create function if not exists somme_salaire()
	returns float
    deterministic
begin   
	declare s float;
    select sum(salaire) into s from employe;
	return s;
end  $$
delimiter ;
select * from employe;
select somme_salaire();



drop function if exists salaire_minimum;
delimiter $$
create function if not exists salaire_minimum()
	returns float
    deterministic
begin   
	declare s float;
    select min(salaire) into s from employe;
	return s;
end  $$
delimiter ;


select salaire_minimum();


drop function if exists salaire_maximum;
delimiter $$
create function if not exists salaire_maximum()
	returns float
    deterministic
begin   
	declare s float;
    select max(salaire) into s from employe;
	return s;
end  $$
delimiter ;


select  nombre_total_employes(), somme_salaire(), salaire_minimum(), salaire_maximum();

/*
Exercice 8 : Création de fonctions statistiques par département
De la même manière, créez quatre fonctions paramétrées par le 
nom du département (`NOM_DEP`) pour obtenir les mêmes statistiques,
 mais cette fois-ci, spécifiques à un département. 
Puis, utilisez-les pour générer un rapport complet par département.
*/


select * from departement;

drop function if exists nombre_total_employes_dep;
delimiter $$
create function if not exists nombre_total_employes_dep(dep varchar(50))
	returns int
    deterministic
begin   
	declare nb int;
    select count(*) into nb from employe where id_dep in (select id_dep from departement where nom_dep = dep);
	return nb;
end  $$
delimiter ;

select nombre_total_employes_dep('informatique');



drop function if exists somme_salaire_dep;
delimiter $$
create function if not exists somme_salaire_dep(dep varchar(50))
	returns float
    deterministic
begin   
	declare s float;
    select sum(salaire) into s from employe where id_dep in (select id_dep from departement where nom_dep = dep);
	return s;
end  $$
delimiter ;
select * from employe;
select somme_salaire_dep('informatique');



drop function if exists salaire_minimum_dep;
delimiter $$
create function if not exists salaire_minimum_dep(dep varchar(50))
	returns float
    deterministic
begin   
	declare s float;
    select min(salaire) into s from employe where id_dep in (select id_dep from departement where nom_dep = dep);
	return s;
end  $$
delimiter ;


select salaire_minimum_dep('inforamtique');


drop function if exists salaire_maximum_dep;
delimiter $$
create function if not exists salaire_maximum_dep(dep varchar(50))
	returns float
    deterministic
begin   
	declare s float;
    select max(salaire) into s from employe where id_dep in (select id_dep from departement where nom_dep = dep);
	return s;
end  $$
delimiter ;


select  ;

select id_dep as id, nombre_total_employes_dep(nom_dep ) as nb, somme_salaire_dep(nom_dep ) as somme, salaire_minimum_dep(nom_dep ) as minimum, salaire_maximum_dep(nom_dep ) as maximum from departement;