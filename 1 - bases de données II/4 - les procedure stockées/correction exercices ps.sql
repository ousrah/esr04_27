DROP DATABASE IF EXISTS produits_esr;
CREATE DATABASE produits_esr COLLATE utf8mb4_general_ci;
USE produits_esr;

CREATE TABLE Produit(
    numProduit INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50),
    PU FLOAT,
    stock INT
);

INSERT INTO produit VALUES 
(1,'table',350,100), (2,'chaise',100,10), (3,'armoire',2350,10),
(4,'pc',3500,20), (5,'clavier',150,200), (6,'souris',50,200),
(7,'ecran',2350,70), (8,'scanner',1350,5), (9,'imprimante',950,5);

select * from produit;

-- 1. Afficher tous les produits
DROP PROCEDURE IF EXISTS q1_prdt;
DELIMITER &&
CREATE PROCEDURE if not exists  q1_prdt()
BEGIN
	SELECT * FROM produit;
END&&
DELIMITER ;
CALL q1_prdt();


-- 2. Afficher les produits avec stock faible
DROP PROCEDURE IF EXISTS q2_stockfaible;
DELIMITER &&
CREATE PROCEDURE q2_stockfaible()
BEGIN
	SELECT libelle FROM produit WHERE stock < 10;
END&&
DELIMITER ;
CALL q2_stockfaible();

-- 3. Afficher les détails d'un produit spécifique
DROP PROCEDURE IF EXISTS q3_aff_prod;
DELIMITER &&
CREATE PROCEDURE q3_aff_prod(num_prod INT)
BEGIN
	SELECT CONCAT('Libellé: ', libelle, ", PU: ", pu, ", Stock: ", stock) AS 'message'
	FROM produit
	WHERE numProduit = num_prod;
END&&
DELIMITER ;
CALL q3_aff_prod(2);

-- 4. Supprimer un produit (déjà vu au chapitre 6)
-- CALL q4_ps_supprimer_produit(9);

DROP PROCEDURE IF EXISTS q4_ps_supprimer_produit;
DELIMITER &&
CREATE PROCEDURE q4_ps_supprimer_produit(num_prod INT)
BEGIN
	delete 
	FROM produit
	WHERE numProduit = num_prod;
END&&
DELIMITER ;
CALL q4_ps_supprimer_produit(9);

select * from produit;


-- La solution est la procédure ex2_vente détaillée au chapitre 6.
DROP PROCEDURE IF EXISTS ex2_vente;
DELIMITER $$
CREATE PROCEDURE ex2_vente(IN num INT, IN qte INT)
BEGIN
	DECLARE stock_reste INT;
	SELECT stock INTO stock_reste FROM produit WHERE numproduit=num;
	IF stock_reste < qte THEN 
		SELECT 'Opération impossible' AS 'message';
	ELSE
		UPDATE produit SET stock= stock_reste - qte WHERE numproduit=num;
		IF stock_reste-qte <10 THEN 
			SELECT CONCAT('Besoin de réapprovisionnement, reste : ', stock_reste-qte) AS 'message';
		ELSE
			SELECT CONCAT('Opération effectuée avec succès, reste : ', stock_reste-qte) AS 'message';
		END IF;
	END IF;
END$$
DELIMITER ;

CALL ex2_vente(4, 11);


DROP PROCEDURE IF EXISTS ex3_moyenne;
DELIMITER $$
CREATE PROCEDURE ex3_moyenne(OUT moyenne FLOAT)
BEGIN
	SELECT AVG(pu) INTO moyenne FROM produit;
END$$
DELIMITER ;

CALL ex3_moyenne(@m);
SELECT @m AS 'Prix Unitaire Moyen';
select @c;
CALL ex3_moyenne(@c);


f(5) = 5! = 5x4x3x2x1
f(1) = 1
f(0) = 1
f(-n) = indéfini


DROP PROCEDURE IF EXISTS ex4_factoriel;
DELIMITER //
CREATE PROCEDURE ex4_factoriel(IN nb INT, OUT factoriel BIGINT)
BEGIN 
    DECLARE i INT DEFAULT 1;

    IF nb < 0 THEN 
		SET factoriel = NULL; -- Factoriel n'est pas défini pour les négatifs
	ELSE
        SET factoriel = 1;
		REPEAT 
			SET factoriel = i * factoriel;
            SET i = i + 1;
        UNTIL i > nb END REPEAT;
    END IF;
END//
DELIMITER ;

CALL ex4_factoriel(0, @f);
SELECT @f; -- Résultat: 120



DROP PROCEDURE IF EXISTS calcule;
DELIMITER $$ 
CREATE PROCEDURE calcule(IN a INT, IN b INT, IN op CHAR(1), OUT resultat FLOAT)
BEGIN 
	IF op IN ('/', '%') AND b=0 THEN
		SET resultat = NULL;
	ELSE
		SET resultat = CASE op 
			WHEN '+' THEN  a+b 
			WHEN '/' THEN  a/b 
			WHEN '*' THEN  a*b 
			WHEN '-' THEN  a-b 
			WHEN '%' THEN  a%b 
            ELSE NULL
		END;
	END IF;
END$$
DELIMITER ;

CALL calcule(5, 0, '/', @res);
SELECT @res; -- Résultat: NULL
CALL calcule(10, 3, '%', @res);
SELECT @res; -- Résultat: 1


DROP DATABASE IF EXISTS cuisine_esr;
CREATE DATABASE cuisine_esr;
USE cuisine_esr;

CREATE TABLE Fournisseur (NumFou INT AUTO_INCREMENT PRIMARY KEY, RSFou VARCHAR(50), AdrFou VARCHAR(100));
CREATE TABLE Recettes (NumRec INT AUTO_INCREMENT PRIMARY KEY, NomRec VARCHAR(50), MethodePreparation VARCHAR(60), TempsPreparation INT);
CREATE TABLE Ingredients (NumIng INT AUTO_INCREMENT PRIMARY KEY, NomIng VARCHAR(50), PUIng FLOAT, UniteMesureIng VARCHAR(20), NumFou INT, CONSTRAINT fk_ing_fou FOREIGN KEY (NumFou) REFERENCES Fournisseur(NumFou));
CREATE TABLE Composition_Recette (NumRec INT NOT NULL, NumIng INT NOT NULL, QteUtilisee FLOAT, CONSTRAINT fk_cr_rec FOREIGN KEY (NumRec) REFERENCES Recettes(NumRec), CONSTRAINT fk_cr_ing FOREIGN KEY (NumIng) REFERENCES Ingredients(NumIng), CONSTRAINT pk_cr PRIMARY KEY (NumIng,NumRec));



INSERT INTO Fournisseur (RSFou, AdrFou) VALUES
('Fournisseur A', '123 Rue des Oliviers, Casablanca'),
('Fournisseur B', '456 Avenue des Pâtes, Rabat'),
('Fournisseur C', '789 Boulevard des Epices, Marrakech');

INSERT INTO Ingredients (NomIng, PUIng, UniteMesureIng, NumFou) VALUES
('Farine', 3.50, 'kg', 1),
('Oeufs', 0.20, 'unité', 1),
('Beurre', 8.00, 'kg', 2),
('Sucre', 2.50, 'kg', 1),
('Lait', 1.00, 'litre', 2),
('Poulet', 6.00, 'kg', 3),
('Tomates', 2.00, 'kg', 3),
('Oignon', 1.20, 'kg', 3),
('Ail', 1.80, 'kg', 3),
('Poivre', 15.00, 'kg', 2);
INSERT INTO Recettes (NomRec, MethodePreparation, TempsPreparation) VALUES
('Gâteau au chocolat', 'Mélanger les ingrédients, cuire au four', 45),
('Crêpes', 'Mélanger, faire cuire des petites galettes', 20),
('Poulet rôti', 'Assaisonner et cuire le poulet au four', 60),
('Salade de tomates', 'Couper et mélanger les ingrédients', 10),
('Omelette', 'Battre les oeufs et cuire à la poêle', 10),
('Pain maison', 'Pétrir et cuire au four', 90),
('Soupe à l\'oignon', 'Faire revenir les oignons et cuire dans un bouillon', 40),
('Poulet curry', 'Faire cuire le poulet et les épices', 50),
('Tarte aux pommes', 'Préparer la pâte et garnir avec les pommes', 60),
('Gratin dauphinois', 'Couper les pommes de terre, ajouter la crème et cuire', 70);

INSERT INTO Composition_Recette (NumRec, NumIng, QteUtilisee) VALUES
-- Gâteau au chocolat
(1, 1, 1), -- Farine
(1, 2, 3), -- Oeufs
(1, 3, 0.2), -- Beurre
(1, 4, 0.5), -- Sucre
(1, 5, 0.25), -- Lait

-- Crêpes
(2, 1, 0.5), -- Farine
(2, 2, 2), -- Oeufs
(2, 3, 0.1), -- Beurre
(2, 5, 0.3), -- Lait

-- Poulet rôti
(3, 6, 1), -- Poulet
(3, 8, 0.1), -- Oignon
(3, 9, 0.05), -- Ail
(3, 10, 0.01), -- Poivre

-- Salade de tomates
(4, 7, 0.5), -- Tomates
(4, 8, 0.1), -- Oignon
(4, 9, 0.02), -- Ail

-- Omelette
(5, 2, 3), -- Oeufs
(5, 3, 0.05), -- Beurre
(5, 9, 0.01), -- Ail
(5, 10, 0.01), -- Poivre

-- Pain maison
(6, 1, 0.8), -- Farine
(6, 4, 0.2), -- Sucre
(6, 5, 0.5), -- Lait

-- Soupe à l'oignon
(7, 8, 0.5), -- Oignon
(7, 9, 0.05), -- Ail
(7, 10, 0.01), -- Poivre

-- Poulet curry
(8, 6, 0.8), -- Poulet
(8, 8, 0.1), -- Oignon
(8, 9, 0.05), -- Ail
(8, 10, 0.02), -- Poivre

-- Tarte aux pommes
(9, 1, 0.3), -- Farine
(9, 3, 0.15), -- Beurre
(9, 4, 0.2), -- Sucre

-- Gratin dauphinois
(10, 5, 0.7), -- Lait
(10, 8, 0.2), -- Oignon
(10, 10, 0.01); -- Poivre

#PS1 : Affiche la liste des ingrédients avec le nom de leur fournisseur.

DROP PROCEDURE IF EXISTS ps1;
DELIMITER $$
CREATE PROCEDURE ps1()
BEGIN
	SELECT i.NumIng, i.NomIng, f.RSFou FROM ingredients i JOIN fournisseur f USING (numfou);
END$$
DELIMITER ;
CALL ps1();
select * from ingredients;



#PS2 : Affiche pour chaque recette son nom, le nombre d'ingrédients et son coût total.


DROP PROCEDURE IF EXISTS ps2;
DELIMITER $$
CREATE PROCEDURE ps2()
BEGIN
	SELECT numrec, nomrec, COUNT(cr.numing) AS 'Nombre Ingredients', format(SUM(qteUtilisee * PUIng),2) AS 'Coût Total' 
	FROM recettes r 
	LEFT JOIN composition_recette cr USING (numrec)
	LEFT JOIN ingredients i USING (numing)
	GROUP BY numrec, nomrec;
END$$
DELIMITER ;
CALL ps2();

#PS4 : Reçoit un numéro de recette et retourne son nom.


DROP PROCEDURE IF EXISTS ps4;
DELIMITER $$
CREATE PROCEDURE ps4(IN n INT, OUT nom VARCHAR(50))
BEGIN
	SELECT NomRec INTO nom FROM recettes WHERE NumRec=n;
END$$
DELIMITER ;
CALL ps4(2, @r);
SELECT @r;


#PS6 : Reçoit un numéro de recette et affiche la liste de ses ingrédients (nom, quantité, montant).


DROP PROCEDURE IF EXISTS ps6;
DELIMITER $$
CREATE PROCEDURE ps6(IN num_recette INT)
BEGIN
    SELECT 
        i.NomIng,
        cr.QteUtilisee, 
        format((i.PUIng * cr.QteUtilisee),2) AS 'montant'
	FROM composition_recette cr 	JOIN ingredients i USING (numing)
	WHERE cr.numrec = num_recette;
END$$
DELIMITER ;
CALL ps6(1);


#PS7 : Reçoit un numéro de recette et affiche une fiche complète en appelant les autres procédures.


DROP PROCEDURE IF EXISTS ps7;
DELIMITER $$
CREATE PROCEDURE ps7(IN recette INT)
BEGIN
	CALL ps4(recette, @nom);
	SELECT @nom AS 'Nom de la Recette';
	CALL ps6(recette);
END$$
DELIMITER ;
CALL ps7(3);


#PS8 : Gère les fournisseurs : vérifie son existence et, s'il n'a pas d'ingrédients, le supprime.


DROP PROCEDURE IF EXISTS ps8;
DELIMITER $$
CREATE PROCEDURE ps8(IN f INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM fournisseur WHERE numfou = f) THEN
		SELECT 'Aucun fournisseur ne porte ce numéro' AS 'message';
	ELSE
		IF NOT EXISTS (SELECT * FROM ingredients WHERE numfou = f) THEN
			SELECT 'Ce fournisseur n\'a aucun ingrédient. Il sera supprimé' AS 'message';
			DELETE FROM fournisseur WHERE numfou = f;
		ELSE
			SELECT NumIng, NomIng FROM ingredients WHERE numfou = f;
		END IF;
	END IF;
END$$
DELIMITER ;

select * from fournisseur;
select distinct numfou from ingredients;

INSERT INTO fournisseur VALUES (4, 'Testeur', 'test');
call ps8(5);
CALL ps8(4); -- Va supprimer le fournisseur 4
CALL ps8(1); -- Va lister les ingrédients du fournisseur 1


#PS9 : Affiche une fiche de synthèse pour une recette donnée.


DROP PROCEDURE IF EXISTS ps9;
DELIMITER $$
CREATE PROCEDURE ps9(IN num_recette INT)
BEGIN
    DECLARE v_nom_rec VARCHAR(50);
    DECLARE v_temps INT;
    DECLARE v_methode VARCHAR(60);
    DECLARE v_cout_total FLOAT;

    -- Récupérer les informations de la recette
    SELECT NomRec, TempsPreparation, MethodePreparation 
    INTO v_nom_rec, v_temps, v_methode
    FROM Recettes WHERE NumRec = num_recette;
    
    -- Calculer le coût total de la recette
    SELECT SUM(cr.QteUtilisee * i.PUIng) 
    INTO v_cout_total
    FROM Composition_Recette cr
    JOIN Ingredients i ON cr.NumIng = i.NumIng
    WHERE cr.NumRec = num_recette;

    -- Afficher les messages et les résultats
    SELECT CONCAT('Recette : ', v_nom_rec, ', temps de préparation : ', v_temps, ' minutes') AS 'Information';
    
    -- Afficher la liste des ingrédients
    SELECT i.NomIng, cr.QteUtilisee
    FROM Composition_Recette cr
    JOIN Ingredients i ON cr.NumIng = i.NumIng
    WHERE cr.NumRec = num_recette;

    SELECT CONCAT('Sa méthode de préparation est : ', v_methode) AS 'Préparation';

    IF v_cout_total < 50 THEN
        SELECT 'Prix intéressant' AS 'Avis sur le coût';
    ELSE
        SELECT 'Prix élevé' AS 'Avis sur le coût';
    END IF;
END$$
DELIMITER ;

CALL ps9(1);
