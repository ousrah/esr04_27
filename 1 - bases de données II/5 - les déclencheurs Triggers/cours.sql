DROP DATABASE IF EXISTS ventes;
CREATE DATABASE ventes COLLATE utf8mb4_general_ci;
USE ventes;

CREATE TABLE produit(
    id_produit INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    prix FLOAT,
    stock INT,
    CHECK (stock >= 0) -- Contrainte pour ne jamais avoir de stock négatif
);

CREATE TABLE vente(
    id_vente INT AUTO_INCREMENT PRIMARY KEY,
    date_vente DATETIME DEFAULT CURRENT_TIMESTAMP,
    qte INT,
    id_produit INT,
    CONSTRAINT fk_vente_produit FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);

INSERT INTO produit VALUES (1,'chaise',200,20), (2,'table',1500,10), (3,'armoire',5000,5);


DROP TRIGGER IF EXISTS after_insert_vente;
DELIMITER $$
CREATE TRIGGER after_insert_vente 
AFTER INSERT ON vente 
FOR EACH ROW
BEGIN
    UPDATE produit SET stock = stock - NEW.qte WHERE id_produit = NEW.id_produit;
END$$
DELIMITER ;

select * from produit;
-- Test : vendons 2 tables (stock initial : 10)
INSERT INTO vente (qte, id_produit) VALUES (2, 20);
SELECT * FROM produit WHERE id_produit = 2; -- Le stock est maintenant à 8


drop trigger if exists after_delete_vente;
delimiter $$
create trigger if not exists after_delete_vente
AFTER DELETE on vente for each row
begin
 update produit set stock = stock + old.qte where id_produit = old.id_produit;
end$$
delimiter ;

select * from vente;
delete from vente where id_vente = 1;
select * from produit;

drop trigger if exists after_update_vente;
delimiter $$
create trigger after_update_vente AFTER UPDATE on vente for each row
begin
	#update produit set stock = stock + old.qte where id_produit = old.id_produit;
	#update produit set stock = stock - new.qte where id_produit = new.id_produit;

	update produit set stock = stock + old.qte - new.qte where id_produit = new.id_produit;

end $$
delimiter ;

select * from vente;
INSERT INTO vente (qte, id_produit) VALUES (2, 2);
select * from produit;

update vente set qte = 2 where id_vente = 3;



DROP TRIGGER IF EXISTS before_insert_produit;
DELIMITER $$
CREATE TRIGGER before_insert_produit
BEFORE INSERT ON produit
FOR EACH ROW
BEGIN
    -- 1. Modification des données : Mettre le nom en majuscules
    SET NEW.nom = UPPER(NEW.nom);

	if new.prix<0 then
		signal sqlstate '45000' set MESSAGE_TEXT = 'le prix ne peut pas être négatif';
	end if;
    -- 2. Validation des données : Empêcher un stock initial négatif
    IF NEW.stock < 0 THEN
        -- SIGNAL est la manière propre de générer une erreur personnalisée
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Le stock initial ne peut pas être négatif.';
    END IF;
END$$
DELIMITER ;

select * from produit;
insert into produit values (null,'pc dell2',5500,15);
insert into produit values (null,'pc dell3',6000,-5);
insert into produit values (null,'pc dell4',6000,5);

