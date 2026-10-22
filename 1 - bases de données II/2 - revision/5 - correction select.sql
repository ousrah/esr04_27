use courses_hyppiques;
-- 1.	la liste de tous les cheveaux.
select * 
from cheval;
-- 2.	la listes de champs qui peuvent acceuillir la catégorie "trot attelé"
select nom_champ
from champ 
where id_champ in (select id_champ 
					from accueil 
                    where id_categorie in (select id_categorie 
											from categorie 
                                            where nom_categorie = 'trot attelé'
                                            )
					);
                    
select nom_champ
from champ join accueil using(id_champ)
join categorie using(id_categorie)
where nom_categorie = 'trot attelé';

-- 3.	la liste des cheveaux qui participent a la course "Grand Prix d''Amérique" 
-- de l'edition 'Janvier 2024' triés par classement

-- on ne peut pas trier par classement 
select * 
from cheval where id_cheval in (select id_cheval 
								from participe 
                                where id_edition in (select id_edition 
													from edition_course 
                                                    where 
                                                    month(date_course) = 1
                                                    and year(date_course) = 2024 
                                                    and id_course in (select id_course 
																		from course 
                                                                        where designation_course = 'grand prix d''amerique'
                                                                        )
													)
								);
                                
                                
                                
select nom_cheval, classement
from cheval                                 
join participe using(id_cheval)
join edition_course using(id_edition)
join course using(id_course)
where month(date_course) = 1
and year(date_course) = 2024 
and designation_course = 'grand prix d''amerique'
and classement is not null
order by classement asc;

-- 4.	la liste des jockeys qui ont monté le cheval "Idao de Tillard" durant tout son historique

select distinct j.* 
from cheval c 
join participe p using(id_cheval)
join jockey j using(id_jockey)
where c.nom_cheval = 'Idao de Tillard';


select * from jockey where id_jockey in (
					select id_jockey 
					from participe 
                    where id_cheval in (
									select id_cheval from cheval 
									where nom_cheval = 'Idao de Tillard'
										)
									);

-- 5.	Le cheval qui a remporté le plus grand nombre de compétitions
with f as (
	select id_cheval, count(classement) as nb
	from participe 
	where classement = 1 
	group by id_cheval
		),
	g as (select max(nb) as maximum from f)

select c.id_cheval, nom_cheval, count(classement) as nb
	from participe p join cheval c using(id_cheval)
	where classement = 1 
	group by c.id_cheval, nom_cheval 
    having nb = (select maximum from g);
;


-- 6.	Les parents du cheval qui a remporté le plus grand nombre de compétitions

with f as (
	select id_cheval, count(classement) as nb
	from participe 
	where classement = 1 
	group by id_cheval
		),
	g as (select max(nb) as maximum from f),
champion as (
select c.id_cheval, nom_cheval, count(classement) as nb
	from participe p join cheval c using(id_cheval)
	where classement = 1 
	group by c.id_cheval, nom_cheval 
    having nb = (select maximum from g))
    
select c.nom_cheval as cheval_champion, ch.nom_cheval as parent
from champion c 
join parent p  on p.che_id_cheval = c.id_cheval 
join cheval ch on p.id_cheval = ch.id_cheval  ;     
    
    ;

select * from parent;
select * from participe where classement = 1;
-- 7.	Le montant total remporté par Idao de Tillard dans toutes les compétitions qu'il a remporté

select sum(dotation_course) as somme_gains_Idao
from participe 
join edition_course using(id_edition)
where classement = 1 and id_cheval in (select id_cheval from cheval where nom_cheval = 'Idao de Tillard');

select * from edition_course;

-- 8.	La catégorie que le cheval Idao de Tillard remporte le plus

select nom_categorie, count(*)
from participe 
join edition_course using(id_edition)
join course using(id_course)
join categorie using (id_categorie)
where classement = 1 and id_cheval in (select id_cheval from cheval where nom_cheval = 'Idao de Tillard')
group by nom_categorie;

-- a finaliser par vous meme