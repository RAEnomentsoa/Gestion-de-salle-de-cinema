-- =========================================
-- SEED DATA: cinema / room / seat / movie / showtime
-- =========================================

-- Optional if you used a schema:
-- SET search_path TO cinema_management;

-- Clean (optional) - careful in production
TRUNCATE TABLE showtime RESTART IDENTITY CASCADE;
TRUNCATE TABLE seat RESTART IDENTITY CASCADE;
TRUNCATE TABLE room RESTART IDENTITY CASCADE;
TRUNCATE TABLE movie RESTART IDENTITY CASCADE;
TRUNCATE TABLE cinema RESTART IDENTITY CASCADE;
TRUNCATE TABLE ticket RESTART IDENTITY CASCADE;
TRUNCATE TABLE tarif RESTART IDENTITY CASCADE;
TRUNCATE TABLE reservation RESTART IDENTITY CASCADE;
TRUNCATE TABLE client RESTART IDENTITY CASCADE;

-- -------------------------
-- 1) CINEMA
-- -------------------------
INSERT INTO cinema (name, address, city, status)
VALUES ('Cine Star', 'Avenue de l''Independance', 'Antananarivo', 'ACTIVE');
-- Expected cinema_id:
-- 1 = Ciné Star, 2 = Ciné Ocean, 3 = Ciné Nord

-- -------------------------
-- 2) ROOM
-- -------------------------
INSERT INTO room (cinema_id, name, capacity, status)
VALUES
(1, 'Salle 1',20, 'ACTIVE'),
(1, 'Salle 2',20, 'ACTIVE'),
(1, 'Salle 3',20, 'MAINTENANCE');


INSERT INTO tarif (nom, prix) VALUES
('STANDARD', 20000.00),
('PREMIUM', 50000.00),
('VIP', 90000.00);


INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active) VALUES
-- Salle 1 → tarif_id = 1
(1, 'A', 1, 1, TRUE),
(1, 'A', 2, 1, TRUE),
(1, 'A', 3, 1, TRUE),
(1, 'A', 4, 1, TRUE),
(1, 'A', 5, 1, TRUE),
(1, 'A', 6, 1, TRUE),
(1, 'A', 7, 1, TRUE),
(1, 'A', 8, 2, TRUE),
(1, 'A', 9, 2, TRUE),
(1, 'A', 10, 2, TRUE),

-- Salle 2 → tarif_id = 2
(2, 'A', 1, 2, TRUE),
(2, 'A', 2, 2, TRUE),
(2, 'A', 3, 2, TRUE),
(2, 'A', 4, 2, TRUE),
(2, 'A', 5, 2, TRUE),
(2, 'A', 6, 2, TRUE),
(2, 'A', 7, 1, TRUE),
(2, 'A', 8, 1, TRUE),
(2, 'A', 9, 1, TRUE),
(2, 'A', 10, 1, TRUE),

-- Salle 3 → tarif_id = 2
(3, 'A', 1, 2, TRUE),
(3, 'A', 2, 2, TRUE),
(3, 'A', 3, 1, TRUE),
(3, 'A', 4, 1, TRUE),
(3, 'A', 5, 1, TRUE),
(3, 'A', 6, 1, TRUE),
(3, 'A', 7, 1, TRUE),
(3, 'A', 8, 2, TRUE),
(3, 'A', 9, 2, TRUE),
(3, 'A', 10, 2, TRUE);

-- -------------------------
-- 4) MOVIE
-- -------------------------
INSERT INTO movie (title, duration_min, age_rating, status)
VALUES ('Avatar', 120, '-16', 'ACTIVE');;

-- Expected movie_id:
-- 1 The Last Voyage, 2 Madagascar Nights, 3 Action City, 4 Old Classic

-- -------------------------
-- 5) SHOWTIME (séances)
-- Note: ends_at > starts_at required
-- -------------------------
INSERT INTO showtime (
    room_id,
    movie_id,
    starts_at,
    ends_at,
    status
) VALUES (
    1,
    1,
    '2026-01-10 10:00:00',
    '2026-01-10 12:00:00',
    'OPEN'
);


-- Done ✅

INSERT INTO client (nom, address, age) VALUES
('Client 1',  'Adresse 1',  22),
('Client 2',  'Adresse 2',  25),
('Client 3',  'Adresse 3',  30),
('Client 4',  'Adresse 4',  28),
('Client 5',  'Adresse 5',  35),
('Client 6',  'Adresse 6',  40),
('Client 7',  'Adresse 7',  16),
('Client 8',  'Adresse 8',  27),
('Client 9',  'Adresse 9',  33),
('Client 10', 'Adresse 10', 45);


INSERT INTO ticket (
    showtime_id,
    seat_id,
    prix
) VALUES (
    1,
    1,
    15000.00
);

INSERT INTO reservation (ticket_id, client_id, status) VALUES
(1, 1, 'PAYER'),
(1, 2, 'PAYER'),
(1, 3, 'NON_PAYER'),
(1, 4, 'PAYER'),
(1, 5, 'NON_PAYER'),
(1, 6, 'PAYER'),
(1, 7, 'PAYER'),
(1, 8, 'NON_PAYER'),
(1, 9, 'PAYER'),
(1, 10, 'PAYER');


-- Create default admin: username=admin password=admin123
INSERT INTO app_user (username, password_hash, full_name, role, status)
VALUES ('admin','admin123', 'Administrateur', 'ADMIN', 'ACTIVE');



