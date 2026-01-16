-- ============================================================
-- BASE "Gestion de salle cinéma" (PostgreSQL)
-- Core tables: cinema, room, seat, movie
-- ============================================================
CREATE DATABASE cinema_managements;

\c cinema_managements


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
  capacity    INT NOT NULL DEFAULT 0 CHECK (capacity >= 0),
  status      VARCHAR(15) NOT NULL DEFAULT 'ACTIVE'
              CHECK (status IN ('ACTIVE', 'MAINTENANCE')),
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_room_cinema
    FOREIGN KEY (cinema_id) REFERENCES cinema(cinema_id),

  CONSTRAINT uq_room_cinema_name
    UNIQUE (cinema_id, name)
);

CREATE INDEX idx_room_cinema_id ON room(cinema_id);

-- =========================
-- tarif
-- =========================
CREATE TABLE tarif (
  id BIGSERIAL PRIMARY KEY,
  nom      VARCHAR(50) NOT NULL,
  prix     NUMERIC(10,2) NOT NULL CHECK (prix >= 0)
);


-- =========================
-- 3) SEAT (Siège)
-- =========================


CREATE TABLE seat (
  seat_id     BIGSERIAL PRIMARY KEY,
  room_id     BIGINT NOT NULL,
  row_label   VARCHAR(10) NOT NULL,
  seat_number INT NOT NULL CHECK (seat_number > 0),
  seat_type   BIGINT NOT NULL,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,

  CONSTRAINT fk_seat_room
    FOREIGN KEY (room_id) REFERENCES room(room_id),

  CONSTRAINT uq_seat_room_row_number
    UNIQUE (room_id, row_label, seat_number),

   CONSTRAINT fk_seat_tarif
    FOREIGN KEY (seat_type) REFERENCES tarif(id)
);


CREATE INDEX idx_seat_room_id ON seat(room_id);
CREATE INDEX idx_seat_room_active ON seat(room_id, is_active);



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




-- ============================================================
-- Gestion de salle cinéma - Tables: client, ticket, reservation
-- Ticket = modèle (réutilisable par plusieurs réservations)
-- PostgreSQL 
-- ============================================================

-- Categorie --

CREATE TABLE IF NOT EXISTS categorie (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prix INTEGER
);

-- =========================
-- 1) CLIENT
-- =========================
CREATE TABLE IF NOT EXISTS client (
    client_id     BIGSERIAL PRIMARY KEY,
    id_categorie  BIGINT NOT NULL,
    nom           VARCHAR(120) NOT NULL,
    address       VARCHAR(255),
    age           INT CHECK (age >= 0),
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_client_categorie
        FOREIGN KEY (id_categorie)
        REFERENCES categorie(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


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


CREATE TABLE app_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL
);





