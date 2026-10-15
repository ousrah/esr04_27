drop database if exists vod_esr;

create database  if not exists vod_esr  collate utf8mb4_general_ci ; #case sensitive

-- ouvrir la base de données
use vod_esr;

#script inside
create table formules_abonnement (
	id_formule int auto_increment primary key,
    libelle varchar(50) not null
);

create table genre(
	id_genre int auto_increment primary key,
    libelle varchar(50) not null
);

create table classification(
	id_classification int auto_increment primary key,
    libelle varchar(50) not null
);

create table serie(
	id_serie int auto_increment primary key,
    libelle varchar(50) not null
);


create table acteur(
	id_acteur int auto_increment primary key,
    nom   varchar(50) not null,
    prenom varchar(50) not null);
    
create table langue(
	id_langue int auto_increment primary key,
    libelle   varchar(50) not null);
    

create table utilisateur(
	id_utilisateur int auto_increment primary key,
	nom varchar(50) not null,
	prenom varchar(50),
	email varchar(50) not null,
	mdp varchar(50) not null,
	id_formule int not null,
    constraint fk_uti_for foreign key (id_formule) references formules_abonnement(id_formule)    
    
);



create table saison (
	id_saison int auto_increment primary key,
    id_serie int not null,
    libelle varchar(50) not null,
    constraint fk_sai_ser foreign key (id_serie) references serie(id_serie)
    
);


create table contenu(
	id_contenu int auto_increment primary key,
	id_saison  int not null,
	id_classification  int not null,
	titre varchar(100) not null,
	resume text,
	duree smallint,
	annee_sortie smallint,
	numero_episode varchar(10),
    constraint fk_con_sai foreign key (id_saison) references saison(id_saison),
    constraint fk_con_cla foreign key (id_classification) references classification(id_classification)
    
);



create table possede(
	id_contenu int not null ,
	id_genre int not null ,
	constraint pk_possede primary key (id_contenu,id_genre),
    constraint fk_pos_gen foreign key (id_genre) references genre(id_genre),
    constraint fk_pos_con foreign key (id_contenu) references contenu(id_contenu)


);



create table doublage(
	id_contenu int not null ,
	id_langue int not null ,
	constraint pk_doublage primary key (id_contenu,id_langue),
    constraint fk_dou_lan foreign key (id_langue) references langue(id_langue),
    constraint fk_dou_con foreign key (id_contenu) references contenu(id_contenu)
);

create table jouer(
	id_contenu int not null ,
	id_acteur int not null ,
	constraint pk_jouer primary key (id_contenu,id_acteur),
    constraint fk_jou_act foreign key (id_acteur) references acteur(id_acteur),
    constraint fk_jou_con foreign key (id_contenu) references contenu(id_contenu)
);

create table historique(
	id_contenu int not null ,
	id_utilisateur int not null ,
	minute_vue smallint,  
	constraint pk_jouer primary key (id_contenu,id_utilisateur),
    constraint fk_his_uti foreign key (id_utilisateur) references utilisateur(id_utilisateur),
    constraint fk_his_con foreign key (id_contenu) references contenu(id_contenu)
);


