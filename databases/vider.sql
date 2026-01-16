-- ============================================================
-- Script pour vider toutes les données sauf certaines tables
-- Tables conservées : cinema, tarif, categorie, movie
-- ============================================================

-- Désactiver temporairement les contraintes de clés étrangères
ALTER TABLE seat DISABLE TRIGGER ALL;
ALTER TABLE room DISABLE TRIGGER ALL;
ALTER TABLE showtime DISABLE TRIGGER ALL;
ALTER TABLE client DISABLE TRIGGER ALL;
ALTER TABLE ticket DISABLE TRIGGER ALL;
ALTER TABLE reservation DISABLE TRIGGER ALL;
ALTER TABLE app_user DISABLE TRIGGER ALL;

-- Vider les tables dépendantes d'abord
TRUNCATE TABLE reservation CASCADE;
TRUNCATE TABLE ticket CASCADE;
TRUNCATE TABLE client CASCADE;
TRUNCATE TABLE showtime CASCADE;
TRUNCATE TABLE seat CASCADE;
TRUNCATE TABLE room CASCADE;
TRUNCATE TABLE app_user CASCADE;

-- Réactiver les triggers / contraintes
ALTER TABLE seat ENABLE TRIGGER ALL;
ALTER TABLE room ENABLE TRIGGER ALL;
ALTER TABLE showtime ENABLE TRIGGER ALL;
ALTER TABLE client ENABLE TRIGGER ALL;
ALTER TABLE ticket ENABLE TRIGGER ALL;
ALTER TABLE reservation ENABLE TRIGGER ALL;
ALTER TABLE app_user ENABLE TRIGGER ALL;

-- Vérification : toutes les tables vidées sauf les tables conservées
-- SELECT COUNT(*) FROM reservation;
-- SELECT COUNT(*) FROM client;
-- SELECT COUNT(*) FROM ticket;
-- SELECT COUNT(*) FROM showtime;
-- SELECT COUNT(*) FROM room;
-- SELECT COUNT(*) FROM seat;
-- SELECT COUNT(*) FROM app_user;
