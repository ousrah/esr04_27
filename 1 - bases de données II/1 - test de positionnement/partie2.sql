-- Partie 2 : Manipulation et Optimisation (40 points)
-- 1.	Insertion de Données (5 pts)
-- 	1.	Insérez les genres 'Horreur', 'Documentaire' et 'Fantastique' en une seule requête 
-- 	INSERT.
use vod_esr;
select * from genre;
insert into  genre (id_genre, libelle) value (1,'test');
insert into  genre  value (2,'test2');
insert into  genre  value (null,'test3');
insert into  genre (libelle) value ('test4');
insert into  genre (libelle,id_genre ) value ('test5',5);

insert into  genre  value ('test6'); #erreur de nombre de champs
insert into  genre  value ('test6',6); #erreur d''ordre des champs
insert into  genre (id_genre)  value (7); #erreur le champs libelle non saisie
insert into  genre(libelle,id_genre)  value ('test6',6); #success
insert into  genre(libelle,id_genre)  value ('test6',6); #erreur de cle primaire en double
insert into  genre(libelle,id_genre)  value ('test6',7); #success
insert  into genre(id_genre, libelle) values (null,'test8'),(null,'test9'),(null,'test10');

select * from genre; 

delete from genre where libelle = 'test6'; #supprimer uniquement  les lignes correspondant a la condition 
delete from genre; #vide la table sans reinitialiser les compters
SET FOREIGN_KEY_CHECKS = 0;
truncate table genre; #vide le table et reinitialise les compteurs
SET FOREIGN_KEY_CHECKS = 1;

insert  into genre (libelle) values ('Horreur'),('Documentaire'),('Fantastique' );





-- 	2.	Ajoutez un nouvel utilisateur de votre choix. Ensuite, simulez le fait qu'il ait 
-- 	regardé 30 minutes du film 'Inception'.



-- 2.	Modification et Suppression (10 pts)
-- 	1.	Avec ALTER TABLE, ajoutez une colonne nationalite (VARCHAR(50)) à la table Acteurs.


-- 	2.	Mettez à jour la nationalité de l'acteur Keanu Reeves pour 'Canadienne'.


-- 	3.	Mettez à jour tous les contenus de "Science-Fiction" sortis avant 2000 pour ajouter 
-- 	la mention "[CLASSIQUE]" au début de leur titre.



-- 	4.	Supprimez la série "Chronique des Techies". Vérifiez que les épisodes associés ont 
-- 	bien été supprimés également (grâce à la contrainte ON DELETE CASCADE).
-- 3.	Optimisation de Requêtes (5 pts)
-- 	Expliquez l'utilité d'un index. Sur quelle(s) colonne(s) de la table Contenus serait-il 
-- 	le plus pertinent d'ajouter un index pour accélérer la recherche par titre ? Justifiez
-- 	 et écrivez la requête CREATE INDEX.
-- 
-- 	Présentez votre travail au formateur pour validation avant de continuer.
