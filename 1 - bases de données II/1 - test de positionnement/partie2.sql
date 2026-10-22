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
select * from utilisateur;
select * from genre;
insert into utilisateur values (null,'test','test','test@test.com','test',1); 
select * from contenu;
insert into contenu values (null,1,3,'Inception','films des reves lucides',90,2016,null);
select * from contenu where titre = 'inception';

select * from historique;

#je peut le faire avec les identifiant du contenu et de l'utilisteur directement
insert into historique values (12,11,30);

#je supprime l'enregistrement inséré
delete from historique where id_contenu = 12 and id_utilisateur = 11;

#je peut le faire avec la recherche des identifaint par sous requete dans la requete d'insertion
insert into historique values (
(select id_contenu from contenu where titre = 'inception'),
(select id_utilisateur from utilisateur where nom = 'test' and prenom = 'test'),
30);



-- 2.	Modification et Suppression (10 pts)
-- 	1.	Avec ALTER TABLE, ajoutez une colonne nationalite (VARCHAR(50)) à la table Acteurs.

#pour la modification des données on fait update (LMD)
update historique set minute_vue = 45 where id_contenu = 12 and id_utilisateur = 11;
select * from historique;
#pour la modification de la structure des données on fait alter (LDD)
select * from acteur;
alter table acteur add nationalite varchar(50);
alter table acteur modify nationalite text;
alter table acteur drop nationalite;
alter table acteur add nationalite varchar(50) default 'américaine';

-- 	2.	Mettez à jour la nationalité de l'acteur Keanu Reeves pour 'Canadienne'.
update acteur set nationalite = 'canadienne' where nom = 'Brown' and prenom  like 'Millie%';
update acteur set nationalite = 'tunisienne' where nom like '_rown' and prenom  like '%Bob%';
update acteur set nationalite = 'canadienne' where nom = 'Keanu' and prenom  = 'Reeves';

#lorsque une chaine de caractère contienne un ' utiliser l'echappement \' ou '' pour l'intérer dans la requete sql
update acteur set nom = 'M''hamed' where id_acteur = 1;
update acteur set nom = 'M\'hamed' where id_acteur = 1;
select * from acteur;

-- 	3.	Mettez à jour tous les contenus de "Science-Fiction" sortis avant 2000 pour ajouter 
-- 	la mention "[CLASSIQUE]" au début de leur titre.

from contenu join possede on contenu.id_contenu = possede.id_contenu;
select * from acteur limit 5;

/*
syntaxe général 
SELECT distinct {*|champ1,champ2.....}
FROM table join table ..... 
WHERE conditions and|or condition.....
GROUP BY champs
having conditions and|or condition.....
ORDER BY champs asc, champs desc....
LIMIT nb;
*/

#Exemples
#afficher tous les champs de la table acteur
select * from acteur;

#afficher tous les champs de la table acteur qui ont la nationnalité Marocaine
select * from acteur where nationalite = 'Marocaine';

#afficher le nom et le prenom des acteurs qui ont la nationnalité Marocaine et qui ont le nom qui commence par m
select nom,prenom from acteur where nationalite = 'Egyptienne' and nom like 'm%';

#afficher les différentes nationalités des acteurs
select distinct nationalite from acteur;

#afficher les 5 premiers aacteurs américains
select * from acteur where nationalite = 'américaine' limit 5;

#afficher les 5 premiers aacteurs américains trié par nom ascendant (du plus petit au plus grand)
select * from acteur where nationalite = 'américaine' order by nom asc limit 5;

#afficher les 5 premiers aacteurs américains trié par prenom ascendant puis par nom ascendant
select * from acteur where nationalite = 'américaine' order by prenom asc, nom asc limit 5;

#afficher les 5 premiers aacteurs américains trié par prenom descendant .
select * from acteur where nationalite = 'américaine' order by prenom desc limit 5;

#jointure simple

#utilisation des alias et jointure avec on
select titre, resume, c.id_saison
from contenu c join saison s on c.id_saison = s.id_saison;

#jointure avec using
select titre, resume, c.id_saison
from contenu c join saison s using(id_saison);  # c'est equivalent de c.id_saison = s.id_saison

#afficher pour chaque contenu son/ses genre
select titre, libelle 
from contenu join possede using(id_contenu)
			 join genre using(id_genre);

select titre, libelle 
from contenu join possede on contenu.id_contenu = possede.id_contenu
			 join genre on possede.id_genre = genre.id_genre;



select * from utilisateur;

#les différents genres que l'utilisateur dupont aime voir
select distinct genre.libelle  "Libelle genre"
from utilisateur  
				join historique using(id_utilisateur)
				join contenu using(id_contenu)
                join possede on contenu.id_contenu = possede.id_contenu
			    join genre on possede.id_genre = genre.id_genre
where nom = 'dupont';

#quels sont les utilisateurs qui ont l'abonnement standart

#methode de jointure
select * 
from utilisateur  join formules_abonnement using(id_formule)
where libelle = 'standard';

#methode de sous requette
select * 
from utilisateur 
where id_formule in (select id_formule 
					from formules_abonnement 
                    where libelle = 'standard' );

#afficher tous les contenus qui ont la classifiation "Interdit aux moins de 16 ans" 
select *
from contenu join classification using(id_classification)
where libelle = 'Interdit aux moins de 16 ans';


select * 
from contenu 
where id_classification in (select id_classification 
							from classification 
                            where libelle = 'Interdit aux moins de 16 ans');
                            
                            
                            
with c1 as (select id_classification 
							from classification 
                            where libelle = 'Interdit aux moins de 16 ans' )
    
    

#je veux la liste des classifications qui n'ont aucun contenu

#avec left join
select classification.*  from
classification left join contenu using(id_classification)
where id_contenu is null;

#avec not in et une sous requete
select * from classification where id_classification not in (select distinct id_classification from contenu);

    #je veux compter pour chaque classification le nombre de ces contenus
select c.id_classification, count(*) as nb                  #count est un fonction d'aggregation comme sum, avg, max et min 
from classification c join contenu t using (id_classification)
group by c.id_classification ;


select libelle, count(*) as nb
from classification c join contenu t using (id_classification)
group by libelle;

#je veut compter le nombre d'utilsiateur par formule d'abonnement
select libelle,count(id_utilisateur) as nb
from formules_abonnement  join utilisateur using(id_formule)
group by libelle;
 
 
# je veux compter pour chaque utilisateur le  nombre de minutes vues

select id_utilisateur, nom , sum(minute_vue) as total_minutes
from utilisateur join historique using(id_utilisateur)
group by id_utilisateur, nom;

# je veux la liste des utilsiateur qui ont vue 100 minutes et plus

select id_utilisateur, nom , sum(minute_vue) as total_minutes
from utilisateur join historique using(id_utilisateur)
group by id_utilisateur, nom
having total_minutes>=100;

select * from historique order by id_utilisateur;

-- 	4.	Supprimez la série "Chronique des Techies". Vérifiez que les épisodes associés ont 
-- 	bien été supprimés également (grâce à la contrainte ON DELETE CASCADE).
-- 3.	Optimisation de Requêtes (5 pts)
-- 	Expliquez l'utilité d'un index. Sur quelle(s) colonne(s) de la table Contenus serait-il 
-- 	le plus pertinent d'ajouter un index pour accélérer la recherche par titre ? Justifiez
-- 	 et écrivez la requête CREATE INDEX.
-- 
-- 	Présentez votre travail au formateur pour validation avant de continuer.
