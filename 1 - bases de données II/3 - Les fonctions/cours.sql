drop database if exists esr27;
create database if not exists esr27 collate utf8mb4_general_ci;
use esr27;

#Les instructions de controle
la declaration des variables
l''affectation
les conditions (if et case)
les boucles (while, repeat, loop)


#Comment créer un bloc d'instruction (fonctions)
#les fonctions système 'built-in'
 select floor(5.5);
 select ceiling(5.5);
 select round(5.434,2);
 select rand();
 select concat("bonjour", " " , "said");
 
 #les fonctions utilisateurs
 
#on supprime la fonction si elle existe déjà
 drop function if exists hello;
 
 #on change le délimiter par defaut a un autre delimitre de notre choix
 delimiter $$
 
 #on crée la fonction si elle n'existe pas encore
 create  function if not exists hello()
 	# on spécifie le type de retour
	returns varchar(50)
    #on précise que la fonction est determistique ça veur que pour les memes entrées on va toujours avoir la meme sortie
	deterministic
 # on ouvre le bloc avec begin   
 begin
	#on fait no traitements
    #....
    #on return la valeur calculée
	return "hello world";
 #on ferme le bloc avec en et le délimiteur spécifié plus haut   
 end $$
 
 # on remet le délmiter a ;
 delimiter ;
 
 # on appel la fonction avec select
 select hello();
 
 # meme si on est dans une autre base de données on peut appeler les fonctions des autres bases de données
 use garagiste;
 select esr27.hello();
 
 use esr27;
 
 #exemple avec paramètre
 #------------------------
 drop function if exists hello2;
 delimiter $$
 create function if not exists hello2(name varchar(30))
	returns varchar(50)
	deterministic
 begin
 	return concat("bonjour ",name);
 end $$
 delimiter ;
 
 select hello2('marwa');
 
 #fonction de calcule d'addition
 #la declaration et l'affecation
 
  drop function if exists addition;
 delimiter $$
 create function if not exists addition(a int, b int   )
	returns int
	deterministic
 begin
	declare c int;  # declaration
    set c = a+b;  #affectation avec set
 
 	return  c  ;
 end $$
 delimiter ;
 
 select addition(3,5);
 
 #affectation avec select
 
 drop function if exists addition;
 delimiter $$
 create function if not exists addition(a int, b int   )
	returns int
	deterministic
 begin
	declare c int;  # declaration
    select  a+b into c;  #affectation avec select
 	return  c  ;
 end $$
 delimiter ;
 
 select addition(13,5);
 
 
 # on souhaite developper un fonctions "calcules" qui reçoit deux valeurs réelle et qui calcule leur somme, soustration, multiplication ou division selon le caratère envoyé à la fonction
 # exemple select calculs (3,5,'+')  -> affiche 8 , calculs (3,5,'x')  -> affiche 15
 #utilisation des conditions
 
 drop function if exists calculs;
 delimiter $$
 create function if not exists calculs(a float, b float , op char  )
	returns varchar(50)
	deterministic
 begin
	declare c varchar(50);  
    if op = '+' then
		set c= a+b ;
    elseif op = "-" then
		set c= a-b ;
    elseif op = "/" then
		if b <> 0 then
			set c= a/b ;
		else
			set c = "erreur de division par 0";
        end if;    
    elseif op = "x" then
		set c= a*b ;
    else
		set c = "erreur";
    end if;
 	return c  ;
 end $$
 delimiter ;
 
 select calculs(3,2,'+') as resultat;
 
 #Exercice
 #ecrire une fonction qui reçoit trois entier et qui affiche le plus grand
 
  drop function if exists plusGrand;
 delimiter $$
 create function if not exists plusGrand(a int, b int, c int   )
	returns int
	deterministic
 begin
	declare max int default a;  # declaration
    if max<b then
		set max =b;
	end if;
    if max<c then
		set max = c;
    end if;
	return  max  ;
 end $$
 delimiter ;
 
 select plusGrand(3000,5000,5000);
 
 #utilisation de case
 
 drop function if exists calculs;
 delimiter $$
 create function if not exists calculs(a float, b float , op char  )
	returns varchar(50)
	deterministic
 begin
	declare c varchar(50);  
    case op  #equivalent de switch en C++, C# ou match en python/php
     when '+' then
		set c= a+b ;
     when "-" then
		set c= a-b ;
     when "/" then
		if b <> 0 then
			set c= a/b ;
		else
			set c = "erreur de division par 0";
        end if;    
    when "x" then
		set c= a*b ;
    else
		set c = "erreur";
    end case;
 	return c  ;
 end $$
 delimiter ;
 
 select calculs(3,0,'/') as resultat;
 
 #ecrire un fonction qui permet d'afficher le nom de la journée si en introduit son numero 1 : Dimanche, 2: Lundi...
 
 
 drop function if exists jourSemaine;
 delimiter $$
 create function if not exists jourSemaine(j int )
	returns varchar(50)
	deterministic
 begin
	declare jour varchar(50);  
    #on va utiliser des affecations dans les blocs when
    case j
		when 1 then set jour = "Dimanche";
		when 2 then set jour = "Lundi";
		when 3 then set jour = "Mardi";
		when 4 then set jour = "Mercredi";
		when 5 then set jour = "Jeudi";
		when 6 then set jour = "Vendredi";
		when 7 then set jour = "Samedi";
    else
		set jour = "erreur";
    end case;
 	return jour  ;
 end $$
 delimiter ;
 
 select jourSemaine(9);
 
 
 
 drop function if exists jourSemaine;
 delimiter $$
 create function if not exists jourSemaine(j int )
	returns varchar(50)
	deterministic
 begin
	declare jour varchar(50);  
    #on va affecter les valeur après when "attention par de point virgule à la fin des when
    # aussi case ne se termine par par end case on met seulement end;
    set jour = case j
					when 1 then "Dimanche"
					when 2 then "Lundi"
					when 3 then "Mardi"
					when 4 then "Mercredi"
					when 5 then "Jeudi"
					when 6 then "Vendredi"
					when 7 then "Samedi"
				else
					 "erreur"
				end;
 	return jour  ;
 end $$
 delimiter ;
  select jourSemaine(3);
 
 
 
 
 drop function if exists jourSemaine;
 delimiter $$
 create function if not exists jourSemaine(j int )
	returns varchar(50)
	deterministic
 begin
	# on return directement la valeur de case sans la stocker dans une variable
    return case j
					when 1 then "Dimanche"
					when 2 then "Lundi"
					when 3 then "Mardi"
					when 4 then "Mercredi"
					when 5 then "Jeudi"
					when 6 then "Vendredi"
					when 7 then "Samedi"
				else
					 "erreur"
				end;
 
 end $$
 delimiter ;
  select jourSemaine(3);
  
  
  
  
 drop function if exists jourSemaine;
 delimiter $$
 create function if not exists jourSemaine(j int )
	returns varchar(50)
	deterministic
 begin
	#on met pas case j on met seulement case et j on va la comparer après when
    return case
					when   j=1 then "Dimanche"
					when   j=2 then "Lundi"
					when   j=3 then "Mardi"
					when   j=4 then "Mercredi"
					when   j=5 then "Jeudi"
					when   j=6 then "Vendredi"
					when   j=7 then "Samedi"
				else
					 "erreur"
				end;
 
 end $$
 delimiter ;
  select jourSemaine(5);
  
  #ecrire un fonction qui return la mention d'une note bien, très bien, faible....
  
  
  
 drop function if exists mentionNote;
 delimiter $$
 create function if not exists mentionNote(note float )
	returns varchar(50)
	deterministic
 begin
    return case 
					when note<0 then "erreur"
					when note<5 then "Très faible"
					when note <9 then "Faible"
					when note <10 then "Insuffisant"
					when note <12 then "Passable"
					when note <14 then "Assez bien"
					when note <16 then "Bien"
					when note <18 then "Très bien"
                    when note <=20 then "excellent"
                    else
						"erreur"
				end;
 
 end $$
 delimiter ;
  select mentionNote(22);
  
  # les boucles
  #les trois boucles de mysql sont while, repeat et loop
  
  # la boucle while
  #une fonction qui calcule la somme des n premiers entier;
  #exemple avec While
  drop function if  exists sommeEntiers;
  delimiter $$
  create function if not exists sommeEntiers (n int)
	returns bigint
    deterministic
  begin 
	declare i int default 0;
    declare somme bigint default 0;
   #avec while les itération seront executées 0 ou n fois
	while i<=n do
		set somme = somme+i;
        set i = i+1;
    end while;
    return somme;
  end $$
  delimiter ;
  
  
  select sommeEntiers(5);
  
  
   #exemple avec repeat
  drop function if  exists sommeEntiers;
  delimiter $$
  create function if not exists sommeEntiers (n int)
	returns bigint
    deterministic
  begin 
	declare i int default 0;
    declare somme bigint default 0;
    #avec repeat les itération seront executées 1 ou n fois
	repeat
		set somme = somme+i;
        set i = i+1;
    until i>n end repeat ;
    return somme;
  end $$
  delimiter ;
  
  
  select sommeEntiers(3);
  
  
  
   #exemple avec loop
  drop function if  exists sommeEntiers;
  delimiter $$
  create function if not exists sommeEntiers (n int)
	returns bigint
    deterministic
  begin 
	declare i int default 0;
    declare somme bigint default 0;
    #avec loop il faut toujours nommer la boucle et faire une condition pour leave
	l1: loop
		set somme = somme+i;
        set i = i+1;
        if i>n then
			leave l1;
        end if;
    end loop l1;
    return somme;
  end $$
  delimiter ;
    
  select sommeEntiers(6);
  
  use vod_esr;
  select * from contenu;
  # on souhaite créer un fonction dans la base de données vod_esr qui retourn le  nombre de cotenus
  
  drop function if exists getNbContent;
  delimiter $$
  create function if not exists getNbContent()
	returns int
	deterministic
  begin
	declare nb int;
    # on peut utiliser set et mettre la requette entre parentèse ou utiliser select ... into variable
    #attention le resultat de la requete doit obligatoirement être une valeur scalaire 
	# en mysql y a pas de fontions table il n'y a que des fonctions scalaires
    
    #set nb = (select count(*) from contenu);
    select count(*) into nb from contenu;

 	return nb;
  end $$
  delimiter ;
  
  
  # meme fonction avec un return direct sans aucune affectation
  drop function if exists getNbContent;
  delimiter $$
  create function if not exists getNbContent()
	returns int
	deterministic
  begin
    return (select count(*) from contenu);
  end $$
  delimiter ;
  
  
  select getNbContent();
  
  #je veux une fonction qui return le nombre d'utilisateurs par type d'abonnement
  #on envoi a la fonction le nom du type d'abonnement 'id_formule' et on reçoit le nombre des utilsiateur
  #qui ont ce type
  
  
  
  drop function if exists getNbUsersByFormula;
  delimiter **
  create function if not exists getNbUsersByFormula(fr varchar(50))
	returns int
    deterministic
  begin  
	return (select count(*) 
			from utilisateur 
            where id_formule in (select id_formule 
								from formules_abonnement 
                                where libelle = fr
                                )
			);
  
  end **
  delimiter ;
  
select getNbUsersByFormula('Premium');