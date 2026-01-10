-- ============================================================
-- BASE "Gestion de salle cinéma" (PostgreSQL)
-- Core tables: cinema, room, seat, movie
-- ============================================================
CREATE DATABASE cinema_management;

\c cinema_management


-- =========================
-- 1) CINEMA
-- =========================
CREATE TABLE cinema (
  cinema_id   BIGSERIAL PRIMARY KEY,
  name        VARCHAR(120) NOT NULL,
  address     VARCHAR(255) NOT NULL,
  city        VARCHAR(100) NOT NULL,
  status      VARCHAR(10) NOT NULL DEFAULT 'ACTIVE'
              CHECK (status IN ('ACTIVE', 'INACTIVE')),
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO cinema (name, address, city, status)
VALUES ('Cine Star', 'Avenue de l''Independance', 'Antananarivo', 'ACTIVE');


-- Unicité basique (optionnelle) : un cinéma de même nom dans la même ville
ALTER TABLE cinema
  ADD CONSTRAINT uq_cinema_name_city UNIQUE (name, city);

-- =========================
-- 2) ROOM (Salle)
-- =========================
CREATE TABLE room (
  room_id     BIGSERIAL PRIMARY KEY,
  cinema_id   BIGINT NOT NULL,
  name        VARCHAR(60) NOT NULL,
  status      VARCHAR(15) NOT NULL DEFAULT 'ACTIVE'
              CHECK (status IN ('ACTIVE', 'MAINTENANCE')),
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_room_cinema
    FOREIGN KEY (cinema_id) REFERENCES cinema(cinema_id),

  CONSTRAINT uq_room_cinema_name
    UNIQUE (cinema_id, name)
);

INSERT INTO room (cinema_id, name, status)
VALUES
(1, 'Salle 1', 'ACTIVE'),
(1, 'Salle 2', 'ACTIVE'),
(1, 'Salle 3', 'MAINTENANCE');



CREATE INDEX idx_room_cinema_id ON room(cinema_id);

-- =========================
-- 3) SEAT (Siège)
-- =========================
CREATE TABLE seat (
  seat_id     BIGSERIAL PRIMARY KEY,
  room_id     BIGINT NOT NULL,
  row_label   VARCHAR(10) NOT NULL,
  seat_number INT NOT NULL CHECK (seat_number > 0),
  seat_type   VARCHAR(15) NOT NULL DEFAULT 'STANDARD'
              CHECK (seat_type IN ('STANDARD', 'VIP', 'PMR', 'LOVESEAT')),
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,

  CONSTRAINT fk_seat_room
    FOREIGN KEY (room_id) REFERENCES room(room_id),

  CONSTRAINT uq_seat_room_row_number
    UNIQUE (room_id, row_label, seat_number)
);


CREATE INDEX idx_seat_room_id ON seat(room_id);
CREATE INDEX idx_seat_room_active ON seat(room_id, is_active);


INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active) VALUES
-- Salle 1
(1, 'A', 1, 'STANDARD', TRUE),
(1, 'A', 2, 'STANDARD', TRUE),
(1, 'A', 3, 'STANDARD', TRUE),
(1, 'A', 4, 'STANDARD', TRUE),
(1, 'A', 5, 'STANDARD', TRUE),
(1, 'A', 6, 'STANDARD', TRUE),
(1, 'A', 7, 'STANDARD', TRUE),
(1, 'A', 8, 'STANDARD', TRUE),
(1, 'A', 9, 'STANDARD', TRUE),
(1, 'A', 10, 'STANDARD', TRUE),

-- Salle 2
(2, 'A', 1, 'STANDARD', TRUE),
(2, 'A', 2, 'STANDARD', TRUE),
(2, 'A', 3, 'STANDARD', TRUE),
(2, 'A', 4, 'STANDARD', TRUE),
(2, 'A', 5, 'STANDARD', TRUE),
(2, 'A', 6, 'STANDARD', TRUE),
(2, 'A', 7, 'STANDARD', TRUE),
(2, 'A', 8, 'STANDARD', TRUE),
(2, 'A', 9, 'STANDARD', TRUE),
(2, 'A', 10, 'STANDARD', TRUE),

-- Salle 3
(3, 'A', 1, 'STANDARD', TRUE),
(3, 'A', 2, 'STANDARD', TRUE),
(3, 'A', 3, 'STANDARD', TRUE),
(3, 'A', 4, 'STANDARD', TRUE),
(3, 'A', 5, 'STANDARD', TRUE),
(3, 'A', 6, 'STANDARD', TRUE),
(3, 'A', 7, 'STANDARD', TRUE),
(3, 'A', 8, 'STANDARD', TRUE),
(3, 'A', 9, 'STANDARD', TRUE),
(3, 'A', 10, 'STANDARD', TRUE);


-- =========================
-- 4) MOVIE (Film)
-- =========================
CREATE TABLE movie (
  movie_id      BIGSERIAL PRIMARY KEY,
  title         VARCHAR(200) NOT NULL,
  duration_min  INT NOT NULL CHECK (duration_min > 0),
  release_date  DATE,
  age_rating    VARCHAR(20),
  status        VARCHAR(10) NOT NULL DEFAULT 'ACTIVE'
                CHECK (status IN ('ACTIVE', 'ARCHIVED')),
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Pour accélérer les recherches
CREATE INDEX idx_movie_title ON movie(title);
CREATE INDEX idx_movie_status ON movie(status);

INSERT INTO movie (title, duration_min, age_rating, status)
VALUES ('Avatar', 120, '-16', 'ACTIVE');

-- =========================
-- SHOWTIME (Séance)
-- =========================
CREATE TABLE showtime (
    showtime_id  BIGSERIAL PRIMARY KEY,

    room_id      BIGINT NOT NULL,
    movie_id     BIGINT NOT NULL,

    starts_at    TIMESTAMP NOT NULL,
    ends_at      TIMESTAMP NOT NULL,


    status       VARCHAR(12) NOT NULL DEFAULT 'SCHEDULED'
                 CHECK (status IN ('SCHEDULED', 'OPEN', 'CLOSED', 'CANCELED')),

    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_showtime_room
        FOREIGN KEY (room_id) REFERENCES room(room_id),

    CONSTRAINT fk_showtime_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id),

    -- Cohérence temporelle
    CONSTRAINT ck_showtime_time
        CHECK (ends_at > starts_at)
);

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




-- ============================================================
-- Gestion de salle cinéma - Tables: client, ticket, reservation
-- Ticket = modèle (réutilisable par plusieurs réservations)
-- PostgreSQL 
-- ============================================================

-- =========================
-- 1) CLIENT
-- =========================
CREATE TABLE IF NOT EXISTS client (
    client_id  BIGSERIAL PRIMARY KEY,
    nom        VARCHAR(120) NOT NULL,
    address    VARCHAR(255),
    age        INT CHECK (age >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO client (nom, address, age) VALUES
('Client 1',  'Adresse 1',  22),
('Client 2',  'Adresse 2',  25),
('Client 3',  'Adresse 3',  30),
('Client 4',  'Adresse 4',  28),
('Client 5',  'Adresse 5',  35),
('Client 6',  'Adresse 6',  40),
('Client 7',  'Adresse 7',  18),
('Client 8',  'Adresse 8',  27),
('Client 9',  'Adresse 9',  33),
('Client 10', 'Adresse 10', 45);


-- =========================
-- 2) TICKET (modèle)
-- =========================
CREATE TABLE IF NOT EXISTS ticket (
    ticket_id   BIGSERIAL PRIMARY KEY,

    showtime_id BIGINT NOT NULL,
    seat_id     BIGINT,  -- optionnel (si tu veux associer un exemple de siège, sinon NULL)

    prix        NUMERIC(10,2) NOT NULL CHECK (prix >= 0),
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ticket_showtime
        FOREIGN KEY (showtime_id) REFERENCES showtime(showtime_id),

    CONSTRAINT fk_ticket_seat
        FOREIGN KEY (seat_id) REFERENCES seat(seat_id)
);

CREATE INDEX IF NOT EXISTS idx_ticket_showtime ON ticket(showtime_id);



INSERT INTO ticket (
    showtime_id,
    seat_id,
    prix
) VALUES (
    1,
    1,
    15000.00
);


-- =========================
-- 3) RESERVATION
-- =========================
CREATE TABLE IF NOT EXISTS reservation (
    reservation_id BIGSERIAL PRIMARY KEY,

    ticket_id  BIGINT NOT NULL,
    client_id  BIGINT NOT NULL,

    status     VARCHAR(10) NOT NULL
               CHECK (status IN ('PAYER', 'NON_PAYER')),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reservation_ticket
        FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id),

    CONSTRAINT fk_reservation_client
        FOREIGN KEY (client_id) REFERENCES client(client_id)
);

CREATE INDEX IF NOT EXISTS idx_reservation_client ON reservation(client_id);
CREATE INDEX IF NOT EXISTS idx_reservation_ticket ON reservation(ticket_id);
CREATE INDEX IF NOT EXISTS idx_reservation_status ON reservation(status);


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





