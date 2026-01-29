BEGIN;

-- Trouver l'id du tarif STANDARD
WITH std AS (
  SELECT id AS tarif_id
  FROM tarif
  WHERE nom = 'STANDARD'
  LIMIT 1
),
rows AS (
  SELECT chr(gs) AS row_label
  FROM generate_series(ascii('A'), ascii('F')) gs   -- A..F (6 rangées)
),
nums AS (
  SELECT gs AS seat_number
  FROM generate_series(1, 20) gs                    -- 1..20 (20 sièges par rangée)
)
INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active)
SELECT 1, r.row_label, n.seat_number, s.tarif_id, TRUE
FROM std s
CROSS JOIN rows r
CROSS JOIN nums n
ON CONFLICT (room_id, row_label, seat_number) DO NOTHING;

COMMIT;




BEGIN;

-- Assurer catégorie ADULTE sans casser la PK
INSERT INTO categorie (nom, prix)
SELECT 'ADULTE', NULL
WHERE NOT EXISTS (SELECT 1 FROM categorie WHERE nom='ADULTE');

-- Récupérer IDs utiles
WITH p AS (
  SELECT
    (SELECT id FROM categorie WHERE nom='ADULTE' LIMIT 1) AS cat_id,
    (SELECT id FROM tarif WHERE nom='STANDARD' LIMIT 1)   AS tarif_id,
    (SELECT prix FROM tarif WHERE nom='STANDARD' LIMIT 1) AS ticket_price
),
seats AS (
  -- 120 seats STANDARD pour room 1
  SELECT st.seat_id,
         row_number() OVER (ORDER BY st.row_label, st.seat_number) AS rn
  FROM seat st
  JOIN p ON st.seat_type = p.tarif_id
  WHERE st.room_id = 1 AND st.is_active = TRUE
  ORDER BY st.row_label, st.seat_number
  LIMIT 120
),

-- -------- Showtime 3 : 40 --------
c3 AS (
  INSERT INTO client (id_categorie, nom, address, age)
  SELECT p.cat_id, 'Adulte_ST3_'||gs, 'Adresse ST3', 25
  FROM p, generate_series(1,40) gs
  RETURNING client_id
),
t3 AS (
  INSERT INTO ticket (showtime_id, seat_id, prix)
  SELECT 3, s.seat_id, p.ticket_price
  FROM seats s, p
  WHERE s.rn BETWEEN 1 AND 40
  RETURNING ticket_id
),
r3 AS (
  INSERT INTO reservation (ticket_id, client_id, status)
  SELECT t.ticket_id, c.client_id, 'PAYER'
  FROM t3 t
  JOIN c3 c ON TRUE
  LIMIT 40
  RETURNING reservation_id
),

-- -------- Showtime 4 : 30 --------
c4 AS (
  INSERT INTO client (id_categorie, nom, address, age)
  SELECT p.cat_id, 'Adulte_ST4_'||gs, 'Adresse ST4', 25
  FROM p, generate_series(1,30) gs
  RETURNING client_id
),
t4 AS (
  INSERT INTO ticket (showtime_id, seat_id, prix)
  SELECT 4, s.seat_id, p.ticket_price
  FROM seats s, p
  WHERE s.rn BETWEEN 41 AND 70
  RETURNING ticket_id
),
r4 AS (
  INSERT INTO reservation (ticket_id, client_id, status)
  SELECT t.ticket_id, c.client_id, 'PAYER'
  FROM t4 t
  JOIN c4 c ON TRUE
  LIMIT 30
  RETURNING reservation_id
),

-- -------- Showtime 5 : 50 --------
c5 AS (
  INSERT INTO client (id_categorie, nom, address, age)
  SELECT p.cat_id, 'Adulte_ST5_'||gs, 'Adresse ST5', 25
  FROM p, generate_series(1,50) gs
  RETURNING client_id
),
t5 AS (
  INSERT INTO ticket (showtime_id, seat_id, prix)
  SELECT 5, s.seat_id, p.ticket_price
  FROM seats s, p
  WHERE s.rn BETWEEN 71 AND 120
  RETURNING ticket_id
)
INSERT INTO reservation (ticket_id, client_id, status)
SELECT t.ticket_id, c.client_id, 'PAYER'
FROM t5 t
JOIN c5 c ON TRUE
LIMIT 50;

COMMIT;


UPDATE categorie_tarif_pricing
SET fixed_price = 30000
WHERE categorie_id IN (
        SELECT id FROM categorie WHERE LOWER(nom) = 'adulte'
      )
  AND tarif_id IN (
        SELECT id FROM tarif WHERE LOWER(nom) = 'standard'
      );

