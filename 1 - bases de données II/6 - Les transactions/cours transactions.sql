drop database if exists banque_esr;
create database if not exists banque_esr collate utf8mb4_general_ci;
use banque_esr;

#Gestion des exceptions

drop procedure if exists affectation;
delimiter  $$
create procedure if not exists affectation(a int )
begin
	declare  x smallint;
    declare exit handler for sqlexception 
		begin
			select "la valeur passée est trop grande" as message; 
        end ;    
    set x = a;
    select concat("la valeur de x est ", x) as resulat;
end$$
delimiter ;

call affectation(12);


drop procedure if exists division;
delimiter $$
create procedure if not exists division(a int, b int, out r int)
begin
	declare exit handler for sqlexception 
    select "erreur de division par zero" as erreur;
    set r=a/b;
end$$
delimiter ;

call division(150,0,@r);
select @r;


create table compte (rib varchar(24) primary key, 
montant decimal(8,2) check (montant>=0) default 0);
delete from compte;
insert into compte values ('1234',2000);
insert into compte values ('5678',1000);

select * from compte;

drop procedure if exists virement;
delimiter $$
create procedure if not exists virement(
										c_deb varchar(24), 
										c_crd varchar(24),
										mnt decimal(8,2)
										)
begin 
	declare exit handler for sqlexception
    begin
		rollback;
        select "virement annulé, fonds indisponibles" as erreur;
    end;
	start transaction ;
	    update compte set montant =  montant + mnt where rib = c_crd;
        update compte set montant =  montant - mnt where rib = c_deb;
    commit ;
    select "operation de virement effectuée avec succès" as message;
    
end $$
delimiter ;

call virement('5678','1234',500);
select * from compte;
call virement('5678','1234',600);
select * from compte;



DROP DATABASE IF EXISTS salles_esr;
CREATE DATABASE salles_esr COLLATE utf8mb4_general_ci;
USE salles_esr;

CREATE TABLE Salle (NumSalle INT AUTO_INCREMENT PRIMARY KEY,
 Etage INT,
 NombreChaises INT, 
CONSTRAINT chk_NombreChaises CHECK (NombreChaises BETWEEN 20 AND 30));

CREATE TABLE Transfert (
NumSalleOrigine INT, 
NumSalleDestination INT, 
DateTransfert DATE, 
NbChaisesTransferees INT,
CONSTRAINT fk_NumSalleOrigine FOREIGN KEY (NumSalleOrigine) REFERENCES salle(numsalle),
CONSTRAINT fk_NumSalleDestination FOREIGN KEY (NumSalleDestination) REFERENCES salle(numsalle));

INSERT INTO salle VALUES (1,1,24), (2,1,26), (3,1,26), (4,2,28);
select * from salle;



DROP PROCEDURE IF EXISTS ps_transfert_chaises;
DELIMITER $$
CREATE PROCEDURE ps_transfert_chaises(salle_origine INT, salle_dest INT, nb_chaises INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
            SELECT "Impossible d’effectuer le transfert : une contrainte a été violée." AS 'message';
		END;

	START TRANSACTION;
        UPDATE salle SET nombreChaises = nombreChaises - nb_chaises WHERE NumSalle = salle_origine;
        UPDATE salle SET nombreChaises = nombreChaises + nb_chaises WHERE NumSalle = salle_dest;
        INSERT INTO transfert VALUES (salle_origine, salle_dest, CURDATE(), nb_chaises);
	COMMIT;
    SELECT "Transfert effectué avec succès." AS 'message';
END$$
DELIMITER ;
select * from salle;
-- Test 1 : Transfert valide (26-4=22 ; 26+4=30. OK)
CALL ps_transfert_chaises(2, 3, 4);
-- Test 2 : Transfert invalide (22-4=18. NON OK)
CALL ps_transfert_chaises(2, 3, 4);


