INSERT INTO pub_tarif (prix) VALUES
    (200000);

INSERT INTO societe (num, prix) VALUES
('Vaniala', null);  -- 0 si pas de prix spécifique, sinon mettre le prix correspondant



INSERT INTO pub (showtime_id, id_societe, dates, id_prix) VALUES
(1, 1, '2026-01-22 10:00:00', 1),
(1, 1, '2026-01-22 12:00:00', 1),
(1, 1, '2026-01-22 14:00:00', 1),
(1, 1, '2026-01-22 16:00:00', 1);

-- SELECT p.id, p.dates, pt.prix, s.starts_at
-- FROM pub p
-- JOIN pub_tarif pt ON p.id_prix = pt.id
-- JOIN showtime s ON p.showtime_id = s.showtime_id
-- WHERE p.showtime_id = 1;


