#dans cet exemple on va créer une procedure qui affiche la liste de tous les employes et tous els departements

drop procedure if exists p1;
delimiter $$
create procedure if not exists p1()
begin
	select * from employe;
    select * from departement;
end $$
delimiter ;

call p1();


#dans cet exemple on va créer une procedure qui affiche la liste de tous les employes et les informations d'un departement donnée


drop procedure if exists p2;
delimiter $$
create procedure if not exists p2(id int)
begin
	select * from employe where id_dep = id;
    select * from departement where id_dep = id;
end $$
delimiter ;

call p2(3);



#paramètres d'entrée et parametres de sortie

#cette fonction affiche la somme de a et b mais elle ne retourne pas leur somme
drop procedure if exists addition;
delimiter $$
create procedure if not exists addition(a int, b int)
begin
	select a+b;
end $$
delimiter ;

call addition(3,5);



drop procedure if exists addition;
delimiter $$
create procedure if not exists addition(in a int, in b int, out r int)
begin
	select a+b into r;
end $$
delimiter ;

call addition(30,5, @var);
select @var*2;
select @var;

#exemple d'utilisatoin de inout

drop procedure if exists modifier_salaire;
delimiter $$
create procedure if not exists modifier_salaire(inout s float)
begin
	update employe set salaire = salaire+s;
    select avg(salaire) into s from employe;
end $$
delimiter ;

select * from employe;

set @v = 1000;
call modifier_salaire(@v)
select @v;



#avec une procedure stockées on peut retourner plusieurs calcules contrairement a une fonction qui ne peut retrouner qu'une seule valeure scalaire

drop procedure if exists calcules;
delimiter $$
create procedure if not exists calcules(in a int, in b int, out addition int, out multiplication int, out soustraction int, out division float)
begin
	select a+b into addition;
    select a-b into soustraction;
    select a*b into multiplication;
    if b=0 then
		select null into division;
	else
		select a/b into division;
	end if;
end $$
delimiter ;

call calcules(30,0, @a,@m,@s,@d);
select @a;
select @m;
select @s;
select @d;




-- Cette procédure récupère le stock actuel dans une variable AVANT de le modifier
DROP PROCEDURE IF EXISTS ex2_vente;
DELIMITER $$
CREATE PROCEDURE ex2_vente(IN np INT, IN qte_vendue INT)
BEGIN
	DECLARE stock_actuel INT;
    
    -- On récupère la valeur du stock de la table et on la met dans notre variable
	SELECT stock INTO stock_actuel FROM produit WHERE num_produit = np;
    
	IF stock_actuel < qte_vendue THEN 
		SELECT 'Opération impossible : stock insuffisant' AS 'message';
	ELSE
		UPDATE produit SET stock = stock_actuel - qte_vendue WHERE num_produit = np;
		IF stock_actuel - qte_vendue < 10 THEN 
			SELECT CONCAT('Besoin de réapprovisionnement, stock restant : ', stock_actuel - qte_vendue) AS 'message';
		ELSE
			SELECT CONCAT('Opération effectuée avec succès, stock restant : ', stock_actuel - qte_vendue) AS 'message';
		END IF;
	END IF;
END$$
DELIMITER ;


create table produit (num_produit int auto_increment primary key, designation varchar(50), stock int);
insert into produit values(1,'table',15), (2,'pc',5),(3,'chaise',20),(4,'souris',50);
select * from produit;
CALL ex2_vente(4, 10); -- Vente de 15 PC (stock 20) -> succès, stock restant 5 -> réapprovisionnement
CALL ex2_vente(4, 10); -- Vente de 10 PC (stock 5) -> impossible



