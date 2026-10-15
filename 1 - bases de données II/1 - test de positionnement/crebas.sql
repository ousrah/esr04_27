/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     15/10/2026 20:28:38                          */
/*==============================================================*/


/*==============================================================*/
/* Table: ACTEUR                                                */
/*==============================================================*/
create table ACTEUR
(
   ID_ACTEUR            int not null auto_increment,
   NOM_ACTEUR           varchar(50) not null,
   PRENOM_ACTEUR        varchar(50) not null,
   primary key (ID_ACTEUR)
);

/*==============================================================*/
/* Table: CLASSIFICATION                                        */
/*==============================================================*/
create table CLASSIFICATION
(
   ID_CLASSIFICATION    int not null auto_increment,
   LIBELLE_CLASSIFICATION varchar(50) not null,
   primary key (ID_CLASSIFICATION)
);

/*==============================================================*/
/* Table: SERIE                                                 */
/*==============================================================*/
create table SERIE
(
   ID_SERIE             int not null auto_increment,
   NOM_SERIE            varchar(250) not null,
   primary key (ID_SERIE)
);

/*==============================================================*/
/* Table: SAISON                                                */
/*==============================================================*/
create table SAISON
(
   ID_SAISON            int not null auto_increment,
   ID_SERIE             int not null,
   LIBELLE_SAISON       varchar(250) not null,
   primary key (ID_SAISON),
   constraint FK_SE_TROUVE foreign key (ID_SERIE)
      references SERIE (ID_SERIE) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: CONTENU                                               */
/*==============================================================*/
create table CONTENU
(
   ID_CONTENU           int not null auto_increment,
   ID_SAISON            int,
   ID_CLASSIFICATION    int not null,
   TITRE_CONTENU        varchar(250) not null,
   DUREE_CONTENU        smallint not null,
   RESUME_CONTENU       text,
   ANNEE_SORTIE         smallint not null,
   NUMERO_EPISODE       varchar(10),
   primary key (ID_CONTENU),
   constraint FK_APPARTIENT foreign key (ID_SAISON)
      references SAISON (ID_SAISON) on delete restrict on update restrict,
   constraint FK_EST_CLASSEE foreign key (ID_CLASSIFICATION)
      references CLASSIFICATION (ID_CLASSIFICATION) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: LANGUE                                                */
/*==============================================================*/
create table LANGUE
(
   ID_LANGUE            int not null auto_increment,
   LIBELLE_LANGUE       varchar(50) not null,
   primary key (ID_LANGUE)
);

/*==============================================================*/
/* Table: DOUBLAGE                                              */
/*==============================================================*/
create table DOUBLAGE
(
   ID_CONTENU           int not null,
   ID_LANGUE            int not null,
   primary key (ID_CONTENU, ID_LANGUE),
   constraint FK_DOUBLAGE foreign key (ID_CONTENU)
      references CONTENU (ID_CONTENU) on delete restrict on update restrict,
   constraint FK_DOUBLAGE2 foreign key (ID_LANGUE)
      references LANGUE (ID_LANGUE) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: FORMULES_ABONNEMENT                                   */
/*==============================================================*/
create table FORMULES_ABONNEMENT
(
   ID_FORMULE           int not null auto_increment,
   LIBELLE_FORMULE      varchar(50) not null,
   primary key (ID_FORMULE)
);

/*==============================================================*/
/* Table: GENRE                                                 */
/*==============================================================*/
create table GENRE
(
   ID_GENRE             int not null auto_increment,
   LIBELLE_GENRE        varchar(50) not null,
   primary key (ID_GENRE)
);

/*==============================================================*/
/* Table: UTILISATEUR                                           */
/*==============================================================*/
create table UTILISATEUR
(
   ID_UTILISATEUR       int not null auto_increment,
   ID_FORMULE           int not null,
   NOM_UTILISATEUR      varchar(30) not null,
   PRENOM_UTILISATEUR   varchar(30),
   EMAIL_UTILISATEUR    varchar(30) not null,
   MOT_DE_PASSE         varchar(30) not null,
   primary key (ID_UTILISATEUR),
   constraint FK_INSCRIT foreign key (ID_FORMULE)
      references FORMULES_ABONNEMENT (ID_FORMULE) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: HISTORIQUE                                            */
/*==============================================================*/
create table HISTORIQUE
(
   ID_UTILISATEUR       int not null,
   ID_CONTENU           int not null,
   MINUTE_VUE           smallint,
   primary key (ID_UTILISATEUR, ID_CONTENU),
   constraint FK_HISTORIQUE foreign key (ID_UTILISATEUR)
      references UTILISATEUR (ID_UTILISATEUR) on delete restrict on update restrict,
   constraint FK_HISTORIQUE2 foreign key (ID_CONTENU)
      references CONTENU (ID_CONTENU) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: JOUER                                                 */
/*==============================================================*/
create table JOUER
(
   ID_CONTENU           int not null,
   ID_ACTEUR            int not null,
   primary key (ID_CONTENU, ID_ACTEUR),
   constraint FK_JOUER foreign key (ID_CONTENU)
      references CONTENU (ID_CONTENU) on delete restrict on update restrict,
   constraint FK_JOUER2 foreign key (ID_ACTEUR)
      references ACTEUR (ID_ACTEUR) on delete restrict on update restrict
);

/*==============================================================*/
/* Table: POSSEDE                                               */
/*==============================================================*/
create table POSSEDE
(
   ID_GENRE             int not null,
   ID_CONTENU           int not null,
   primary key (ID_GENRE, ID_CONTENU),
   constraint FK_POSSEDE foreign key (ID_GENRE)
      references GENRE (ID_GENRE) on delete restrict on update restrict,
   constraint FK_POSSEDE2 foreign key (ID_CONTENU)
      references CONTENU (ID_CONTENU) on delete restrict on update restrict
);

