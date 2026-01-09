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
  screen_type VARCHAR(30),
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


CREATE TABLE showtime (
  showtime_id  BIGSERIAL PRIMARY KEY,
  cinema_id    BIGINT NOT NULL,
  room_id      BIGINT NOT NULL,
  movie_id     BIGINT NOT NULL,

  starts_at    TIMESTAMP NOT NULL,
  ends_at      TIMESTAMP NOT NULL,
  base_price   NUMERIC(10,2) NOT NULL CHECK (base_price >= 0),

  status       VARCHAR(10) NOT NULL DEFAULT 'SCHEDULED'
               CHECK (status IN ('SCHEDULED', 'OPEN', 'CLOSED', 'CANCELED')),

  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_showtime_cinema
    FOREIGN KEY (cinema_id) REFERENCES cinema(cinema_id),

  CONSTRAINT fk_showtime_room
    FOREIGN KEY (room_id) REFERENCES room(room_id),

  CONSTRAINT fk_showtime_movie
    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),

  -- Assure une cohérence minimale des dates
  CONSTRAINT ck_showtime_time
    CHECK (ends_at > starts_at)
);

-- Index demandé : (room_id, starts_at)
CREATE INDEX idx_showtime_room_starts_at ON showtime(room_id, starts_at);

-- Index utiles pour les recherches (optionnels mais pratiques)
CREATE INDEX idx_showtime_cinema_starts_at ON showtime(cinema_id, starts_at);
CREATE INDEX idx_showtime_movie_starts_at  ON showtime(movie_id, starts_at);

