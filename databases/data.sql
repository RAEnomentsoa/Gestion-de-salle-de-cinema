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

-- -------------------------
-- 1) CINEMA
-- -------------------------
INSERT INTO cinema (name, address, city, status) VALUES
('Ciné Star', 'Avenue de l''Indépendance', 'Antananarivo', 'ACTIVE'),
('Ciné Ocean', 'Boulevard de la Mer', 'Toamasina', 'ACTIVE'),
('Ciné Nord', 'Rue du Port', 'Antsiranana', 'ACTIVE');

-- Expected cinema_id:
-- 1 = Ciné Star, 2 = Ciné Ocean, 3 = Ciné Nord

-- -------------------------
-- 2) ROOM
-- -------------------------
INSERT INTO room (cinema_id, name, screen_type, status) VALUES
(1, 'Salle 1', 'STANDARD', 'ACTIVE'),
(1, 'Salle 2', 'IMAX', 'ACTIVE'),
(2, 'Salle 1', 'STANDARD', 'ACTIVE'),
(3, 'Salle 1', 'STANDARD', 'MAINTENANCE');

-- Expected room_id:
-- 1 (Ciné Star Salle 1), 2 (Ciné Star Salle 2), 3 (Ciné Ocean Salle 1), 4 (Ciné Nord Salle 1)

-- -------------------------
-- 3) SEAT (small sample)
-- Room 1: rows A-B, seats 1-6
-- Room 2: rows A-B, seats 1-4 (VIP in row A)
-- Room 3: rows A, seats 1-5 (with one PMR)
-- -------------------------

-- Room 1 (room_id = 1)
INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active) VALUES
(1,'A',1,'STANDARD',true),(1,'A',2,'STANDARD',true),(1,'A',3,'STANDARD',true),
(1,'A',4,'STANDARD',true),(1,'A',5,'STANDARD',true),(1,'A',6,'STANDARD',true),
(1,'B',1,'STANDARD',true),(1,'B',2,'STANDARD',true),(1,'B',3,'STANDARD',true),
(1,'B',4,'STANDARD',true),(1,'B',5,'STANDARD',true),(1,'B',6,'STANDARD',true);

-- Room 2 (room_id = 2)
INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active) VALUES
(2,'A',1,'VIP',true),(2,'A',2,'VIP',true),(2,'A',3,'VIP',true),(2,'A',4,'VIP',true),
(2,'B',1,'STANDARD',true),(2,'B',2,'STANDARD',true),(2,'B',3,'STANDARD',true),(2,'B',4,'STANDARD',true);

-- Room 3 (room_id = 3)
INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active) VALUES
(3,'A',1,'PMR',true),(3,'A',2,'STANDARD',true),(3,'A',3,'STANDARD',true),(3,'A',4,'STANDARD',true),(3,'A',5,'STANDARD',true);

-- -------------------------
-- 4) MOVIE
-- -------------------------
INSERT INTO movie (title, duration_min, release_date, age_rating, status) VALUES
('The Last Voyage', 125, '2024-11-15', 'PG-13', 'ACTIVE'),
('Madagascar Nights', 98, '2023-07-01', 'ALL', 'ACTIVE'),
('Action City', 140, '2022-03-10', '16+', 'ACTIVE'),
('Old Classic', 110, '1999-01-01', 'ALL', 'ARCHIVED');

-- Expected movie_id:
-- 1 The Last Voyage, 2 Madagascar Nights, 3 Action City, 4 Old Classic

-- -------------------------
-- 5) SHOWTIME (séances)
-- Note: ends_at > starts_at required
-- -------------------------
INSERT INTO showtime (cinema_id, room_id, movie_id, starts_at, ends_at, base_price, status) VALUES
(1, 1, 2, '2026-01-10 14:00:00', '2026-01-10 15:45:00', 15000.00, 'SCHEDULED'),
(1, 2, 1, '2026-01-10 18:30:00', '2026-01-10 20:40:00', 25000.00, 'OPEN'),
(2, 3, 3, '2026-01-11 16:00:00', '2026-01-11 18:20:00', 18000.00, 'SCHEDULED'),
(3, 4, 2, '2026-01-12 10:00:00', '2026-01-12 11:40:00', 12000.00, 'CANCELED');

-- Done ✅
