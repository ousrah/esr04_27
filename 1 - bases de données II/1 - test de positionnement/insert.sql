-- S'assurer d'utiliser la base de données
use vod_esr;

-- Désactiver temporairement les vérifications de clés étrangères si nécessaire, 
-- bien que l'ordre des insertions ci-dessous les respecte parfaitement.
SET FOREIGN_KEY_CHECKS = 0;

-- Vider les tables au cas où le script serait exécuté plusieurs fois (dans l'ordre inverse des dépendances)
TRUNCATE TABLE historique;
TRUNCATE TABLE jouer;
TRUNCATE TABLE doublage;
TRUNCATE TABLE possede;
TRUNCATE TABLE contenu;
TRUNCATE TABLE saison;
TRUNCATE TABLE utilisateur;
TRUNCATE TABLE langue;
TRUNCATE TABLE acteur;
TRUNCATE TABLE serie;
TRUNCATE TABLE classification;
TRUNCATE TABLE genre;
TRUNCATE TABLE formules_abonnement;

SET FOREIGN_KEY_CHECKS = 1;


------------------------------------------------------------
-- 1. FORMULES D'ABONNEMENT (10 enregistrements)
------------------------------------------------------------
INSERT INTO formules_abonnement (id_formule, libelle) VALUES
(1, 'Freemium (Publicités)'),
(2, 'Essentiel HD (1 Écran)'),
(3, 'Standard Full HD (2 Écrans)'),
(4, 'Premium Ultra HD (4 Écrans)'),
(5, 'Pass Étudiant'),
(6, 'Pass Famille Plus'),
(7, 'Abonnement Annuel VIP'),
(8, 'Offre Découverte 1 Mois'),
(9, 'Pass Week-end Cinéma'),
(10, 'Formule Ultra Sport & Divertissement');


------------------------------------------------------------
-- 2. GENRE (10 enregistrements)
------------------------------------------------------------
INSERT INTO genre (id_genre, libelle) VALUES
(1, 'Action'),
(2, 'Science-Fiction'),
(3, 'Drame'),
(4, 'Comédie'),
(5, 'Thriller'),
(6, 'Horreur'),
(7, 'Animation'),
(8, 'Documentaire'),
(9, 'Romance'),
(10, 'Fantastique');


------------------------------------------------------------
-- 3. CLASSIFICATION (10 enregistrements)
------------------------------------------------------------
INSERT INTO classification (id_classification, libelle) VALUES
(1, 'Tous publics'),
(2, 'Déconseillé aux moins de 10 ans'),
(3, 'Déconseillé aux moins de 12 ans'),
(4, 'Interdit aux moins de 16 ans'),
(5, 'Interdit aux moins de 18 ans'),
(6, 'Tout public avec avertissement'),
(7, 'PG (Parental Guidance)'),
(8, 'PG-13'),
(9, 'R-Rated'),
(10, 'NC-17');


------------------------------------------------------------
-- 4. SERIE (10 enregistrements)
------------------------------------------------------------
INSERT INTO serie (id_serie, libelle) VALUES
(1, 'Stranger Things'),
(2, 'Breaking Bad'),
(3, 'The Witcher'),
(4, 'The Crown'),
(5, 'Dark'),
(6, 'Cyberpunk: Edgerunners'),
(7, 'Sherlock'),
(8, 'Lupin'),
(9, 'Peaky Blinders'),
(10, 'Money Heist (La Casa de Papel)');


------------------------------------------------------------
-- 5. ACTEUR (10 enregistrements)
------------------------------------------------------------
INSERT INTO acteur (id_acteur, nom, prenom) VALUES
(1, 'Brown', 'Millie Bobby'),
(2, 'Cranston', 'Bryan'),
(3, 'Cavill', 'Henry'),
(4, 'Foy', 'Claire'),
(5, 'Hofmann', 'Louis'),
(6, 'Kennard', 'Aoi'),
(7, 'Cumberbatch', 'Benedict'),
(8, 'Sy', 'Omar'),
(9, 'Murphy', 'Cillian'),
(10, 'Morte', 'Álvaro');


------------------------------------------------------------
-- 6. LANGUE (10 enregistrements)
------------------------------------------------------------
INSERT INTO langue (id_langue, libelle) VALUES
(1, 'Français'),
(2, 'Anglais'),
(3, 'Espagnol'),
(4, 'Allemand'),
(5, 'Japonais'),
(6, 'Italien'),
(7, 'Portugais'),
(8, 'Coréen'),
(9, 'Arabe'),
(10, 'Russe');


------------------------------------------------------------
-- 7. UTILISATEUR (10 enregistrements)
------------------------------------------------------------
INSERT INTO utilisateur (id_utilisateur, nom, prenom, email, mdp, id_formule) VALUES
(1, 'Dupont', 'Jean', 'jean.dupont@email.com', 'hashed_mdp_1', 3),
(2, 'Martin', 'Sophie', 'sophie.martin@email.com', 'hashed_mdp_2', 4),
(3, 'Bernard', 'Lucas', 'lucas.bernard@email.com', 'hashed_mdp_3', 1),
(4, 'Thomas', 'Chloé', 'chloe.thomas@email.com', 'hashed_mdp_4', 2),
(5, 'Petit', 'Mehdi', 'mehdi.petit@email.com', 'hashed_mdp_5', 6),
(6, 'Robert', 'Emma', 'emma.robert@email.com', 'hashed_mdp_6', 7),
(7, 'Richard', 'Thomas', 'thomas.richard@email.com', 'hashed_mdp_7', 3),
(8, 'Durand', 'Sarah', 'sarah.durand@email.com', 'hashed_mdp_8', 5),
(9, 'Moreau', 'Alexandre', 'alex.moreau@email.com', 'hashed_mdp_9', 8),
(10, 'Simon', 'Laura', 'laura.simon@email.com', 'hashed_mdp_10', 4);


------------------------------------------------------------
-- 8. SAISON (10 enregistrements)
------------------------------------------------------------
INSERT INTO saison (id_saison, id_serie, libelle) VALUES
(1, 1, 'Saison 1 - Upside Down'),
(2, 2, 'Saison 1 - Heisenberg'),
(3, 3, 'Saison 1 - Le Loup Blanc'),
(4, 4, 'Saison 1 - Le Début d\'un Règne'),
(5, 5, 'Saison 1 - Secrets de Famille'),
(6, 6, 'Saison Unique - Night City'),
(7, 7, 'Saison 1 - Une Étude en Rose'),
(8, 8, 'Partie 1 - Dans l\'Ombre d\'Arsène'),
(9, 9, 'Saison 1 - Les Gangsters de Birmingham'),
(10, 10, 'Partie 1 - Le Braquage du Siècle');


------------------------------------------------------------
-- 9. CONTENU (10 enregistrements)
------------------------------------------------------------
INSERT INTO contenu (id_contenu, id_saison, id_classification, titre, resume, duree, annee_sortie, numero_episode) VALUES
(1, 1, 3, 'Chapitre un : La Disparition de Will Byers', 'Un jeune garçon disparaît mystérieusement dans une petite ville.', 50, 2016, 'S01E01'),
(2, 2, 4, 'Chute libre', 'Un professeur de chimie découvre qu\'il est atteint d\'un cancer en phase terminale.', 58, 2008, 'S01E01'),
(3, 3, 4, 'Le Fin Mot de l\'Histoire', 'Un sorceleur voyage vers une ville minière tourmentée.', 60, 2019, 'S01E01'),
(4, 4, 2, 'Wolferton Splash', 'La jeune princesse Elizabeth apprend qu\'elle doit monter sur le trône.', 55, 2016, 'S01E01'),
(5, 5, 4, 'Secrets', 'Un enfant disparaît dans une petite ville allemande proche d\'une centrale.', 52, 2017, 'S01E01'),
(6, 6, 4, 'Let You Down', 'Un jeune garçon des rues essaie de survivre à Night City.', 25, 2022, 'EP01'),
(7, 7, 3, 'Une étude en rose', 'Un détective consultant excentrique rencontre un ancien médecin militaire.', 88, 2010, 'S01E01'),
(8, 8, 2, 'Chapitre 1', 'Un gentleman cambrioleur s\'inspire d\'Arsène Lupin.', 48, 2021, 'S01E01'),
(9, 9, 4, 'Épisode 1', 'Un gang de criminels s\'établit à Birmingham après la Grande Guerre.', 57, 2013, 'S01E01'),
(10, 10, 3, 'Effet de surprise', 'Un homme mystérieux recrutant huit criminels lance un plan audacieux.', 70, 2017, 'S01E01');


------------------------------------------------------------
-- 10. POSSEDE (10 enregistrements - Association Contenu / Genre)
------------------------------------------------------------
INSERT INTO possede (id_contenu, id_genre) VALUES
(1, 2), -- Stranger Things -> Sci-Fi
(1, 10),-- Stranger Things -> Fantastique
(2, 3), -- Breaking Bad -> Drame
(2, 5), -- Breaking Bad -> Thriller
(3, 1), -- The Witcher -> Action
(3, 10),-- The Witcher -> Fantastique
(4, 3), -- The Crown -> Drame
(5, 2), -- Dark -> Sci-Fi
(6, 7), -- Cyberpunk -> Animation
(7, 5); -- Sherlock -> Thriller


------------------------------------------------------------
-- 11. DOUBLAGE (10 enregistrements - Association Contenu / Langue)
------------------------------------------------------------
INSERT INTO doublage (id_contenu, id_langue) VALUES
(1, 1), -- Stranger Things (Français)
(1, 2), -- Stranger Things (Anglais)
(2, 2), -- Breaking Bad (Anglais)
(2, 3), -- Breaking Bad (Espagnol)
(3, 2), -- The Witcher (Anglais)
(4, 2), -- The Crown (Anglais)
(5, 4), -- Dark (Allemand)
(6, 5), -- Cyberpunk (Japonais)
(7, 2), -- Sherlock (Anglais)
(8, 1); -- Lupin (Français)


------------------------------------------------------------
-- 12. JOUER (10 enregistrements - Association Contenu / Acteur)
------------------------------------------------------------
INSERT INTO jouer (id_contenu, id_acteur) VALUES
(1, 1), -- Stranger Things -> Millie Bobby Brown
(2, 2), -- Breaking Bad -> Bryan Cranston
(3, 3), -- The Witcher -> Henry Cavill
(4, 4), -- The Crown -> Claire Foy
(5, 5), -- Dark -> Louis Hofmann
(6, 6), -- Cyberpunk -> Aoi Kennard
(7, 7), -- Sherlock -> Benedict Cumberbatch
(8, 8), -- Lupin -> Omar Sy
(9, 9), -- Peaky Blinders -> Cillian Murphy
(10, 10); -- Money Heist -> Álvaro Morte


------------------------------------------------------------
-- 13. HISTORIQUE (10 enregistrements - Association Contenu / Utilisateur)
------------------------------------------------------------
INSERT INTO historique (id_contenu, id_utilisateur, minute_vue) VALUES
(1, 1, 45),
(1, 2, 50),
(2, 3, 58),
(3, 4, 30),
(4, 5, 55),
(5, 6, 20),
(6, 7, 25),
(7, 8, 80),
(8, 9, 48),
(9, 10, 15);