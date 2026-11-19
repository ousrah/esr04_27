drop database if exists commerce_esr;
create database if not exists commerce_esr collate utf8mb4_general_ci;
use commerce_esr;

create table produit (
					id int auto_increment primary key, 
					nom varchar(50) not null unique, 
					prix decimal(8,2) check (prix>0)
					);

  

drop procedure if exists creer_produit;
delimiter $$
create procedure if not exists creer_produit (designation varchar(50),p decimal(8,2))
begin

	#Gestionnaire d'exceptions générique
    #declare exit handler for sqlexception  
    #begin
	#	select "erreur d'insertion" as erreur;
    #end;


	#gestionnaire d'exceptions spécialisé
    declare exit handler for 1062
    begin
		select "le nom du produit existe deja" as erreur;
    end;
    declare exit handler for 1048
    begin
		select "le nom du produit ne peut pas être null" as erreur;
    end;
    declare exit handler for  3819
    begin
		select "le prix ne peut pas être inférieur ou égale a zero" as erreur;
    end;


	insert into produit (nom, prix) values (designation, p);
end$$
delimiter ;
select * from produit;
call creer_produit('pc',3500);



#un autre algorythme qui fait exactement la meme chose.

drop procedure if exists creer_produit;
delimiter $$
create procedure if not exists creer_produit (designation varchar(50),p decimal(8,2))
begin
    declare msg varchar(255) default '';
    begin
		declare exit handler for 1062 set msg =  "le nom du produit existe deja";
		declare exit handler for 1048 set msg =  "le nom du produit ne peut pas être null";
		declare exit handler for  3819 set msg= "le prix ne peut pas être inférieur ou égale a zero" ;
		insert into produit (nom, prix) values (designation, p);
        select "insertion effectuée avec succes" as message;
    end ;   
	if msg!='' then
		select msg as erreur;
	end if;
end$$
delimiter ;
select * from produit;
call creer_produit('table',3500); 



DROP PROCEDURE IF EXISTS ajout_avec_diagnostic;
DELIMITER $$
CREATE PROCEDURE ajout_avec_diagnostic(designation VARCHAR(100), p DOUBLE)
BEGIN
    DECLARE numero_erreur INT;
    DECLARE message_original VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 numero_erreur = MYSQL_ERRNO, message_original = MESSAGE_TEXT;
        SELECT CONCAT("Erreur N°", numero_erreur, " : ", message_original) AS "Erreur détaillée";
    END;
    
    INSERT INTO produit (nom, prix) VALUES (designation, p);
    SELECT "Insertion réussie." AS "Succès";
END$$
DELIMITER ;
CALL ajout_avec_diagnostic('table44', -150);

#faire plate le code


drop procedure if exists faire_planter;
delimiter $$
create procedure faire_planter(x int)
begin
 DECLARE erreur_plantage CONDITION FOR SQLSTATE '45000';
 if x = 5 then
     SIGNAL erreur_plantage SET MESSAGE_TEXT = 'par sécurité on arrete le programme parceque x = 5';
 end if;
 select "programme terminé avec succes" as message;
end $$
delimiter; 

call faire_planter(5);


DROP PROCEDURE IF EXISTS diviser;
DELIMITER $$
CREATE PROCEDURE diviser(a INT, b INT, OUT r DOUBLE)
BEGIN
	-- 1. On déclare une condition nommée pour notre erreur métier
	DECLARE erreur_division CONDITION FOR SQLSTATE '45000';
    
    -- 3. Le handler intercepte notre erreur personnalisée
    DECLARE EXIT HANDLER FOR erreur_division 
    BEGIN
        SELECT "Problème de division par zéro détecté." AS 'Erreur';
    END;

	IF b = 0 THEN
		-- 2. On déclenche l'erreur si notre condition métier est violée
		SIGNAL erreur_division SET MESSAGE_TEXT = 'Division par zéro interdite';
	ELSE
		SET r = a / b;
	END IF;
END$$
DELIMITER ;

CALL diviser(10, 0, @r);
select @r;

