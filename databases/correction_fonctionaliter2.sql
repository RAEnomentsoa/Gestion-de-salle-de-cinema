CREATE OR REPLACE VIEW reservation_report_view AS
SELECT
    r.reservation_id,
    r.status AS reservation_status,
    r.created_at AS reservation_created_at,
    t.ticket_id,

    -- ✅ New price logic (PERCENT / FIXED / fallback)
    CASE
        WHEN ctp.pricing_type = 'FIXED' THEN ctp.fixed_price
        WHEN ctp.pricing_type = 'PERCENT' THEN ROUND(tr.prix * (ctp.percent_rate / 100.0), 2)
        ELSE tr.prix
    END AS prix,

    c.nom AS client_name,
    ci.name AS cinema_name,
    ro.room_id,
    ro.name AS room_name,
    m.movie_id,
    m.title AS movie_title,
    s.starts_at,
    st.row_label AS seat_row,
    st.seat_number

FROM reservation r
JOIN client c ON r.client_id = c.client_id
JOIN categorie cat ON c.id_categorie = cat.id
JOIN ticket t ON r.ticket_id = t.ticket_id
JOIN showtime s ON t.showtime_id = s.showtime_id
JOIN room ro ON s.room_id = ro.room_id
JOIN cinema ci ON ro.cinema_id = ci.cinema_id
JOIN movie m ON s.movie_id = m.movie_id

LEFT JOIN seat st ON t.seat_id = st.seat_id
LEFT JOIN tarif tr ON st.seat_type = tr.id

-- ✅ Join the new pricing rule table
LEFT JOIN categorie_tarif_pricing ctp
  ON ctp.categorie_id = cat.id
 AND ctp.tarif_id = tr.id;

--getTotalRevenue()
String sql = """
   SELECT COALESCE(SUM(
       CASE
           WHEN ctp.pricing_type = 'FIXED' THEN ctp.fixed_price
           WHEN ctp.pricing_type = 'PERCENT' THEN ROUND(tr.prix * (ctp.percent_rate / 100.0), 2)
           ELSE COALESCE(tr.prix, 0)
       END
   ), 0) AS total
   FROM reservation r
   JOIN client c ON r.client_id = c.client_id
   JOIN categorie cat ON c.id_categorie = cat.id
   JOIN ticket t ON r.ticket_id = t.ticket_id
   JOIN showtime s ON t.showtime_id = s.showtime_id
   JOIN room ro ON s.room_id = ro.room_id
   JOIN movie m ON s.movie_id = m.movie_id
   LEFT JOIN seat st ON t.seat_id = st.seat_id
   LEFT JOIN tarif tr ON st.seat_type = tr.id

   LEFT JOIN categorie_tarif_pricing ctp
     ON ctp.categorie_id = cat.id
    AND ctp.tarif_id = tr.id

   WHERE r.status = 'PAYER'
     AND (? IS NULL OR ro.room_id = ?)
     AND (? IS NULL OR m.movie_id = ?)
""";



-- Find ids (example)
-- categorie: Enfant
-- tarif: NORMAL, VIP

INSERT INTO categorie_tarif_pricing (categorie_id, tarif_id, pricing_type, percent_rate)
VALUES (
  (SELECT id FROM categorie WHERE LOWER(nom)='enfant'),
  (SELECT id FROM tarif WHERE LOWER(nom)='premium'),
  'PERCENT',
  50
);

INSERT INTO categorie_tarif_pricing (categorie_id, tarif_id, pricing_type, fixed_price)
VALUES (
  (SELECT id FROM categorie WHERE LOWER(nom)='enfant'),
  (SELECT id FROM tarif WHERE LOWER(nom)='vip'),
  'FIXED',
  5000
);

INSERT INTO categorie_tarif_pricing (categorie_id, tarif_id, pricing_type, fixed_price)
VALUES (
  (SELECT id FROM categorie WHERE LOWER(nom)='adulte'),
  (SELECT id FROM tarif WHERE LOWER(nom)='vip'),
  'FIXED',
  5000
);

INSERT INTO categorie_tarif_pricing (categorie_id, tarif_id, pricing_type, fixed_price)
VALUES (
  (SELECT id FROM categorie WHERE LOWER(nom)='adulte'),
  (SELECT id FROM tarif WHERE LOWER(nom)='standard'),
  'FIXED',
  30000
);

INSERT INTO categorie_tarif_pricing (categorie_id, tarif_id, pricing_type, fixed_price)
VALUES (
  (SELECT id FROM categorie WHERE LOWER(nom)='enfant'),
  (SELECT id FROM tarif WHERE LOWER(nom)='standard'),
  'FIXED',
  5000
);

INSERT INTO categorie_tarif_pricing (categorie_id, tarif_id, pricing_type, fixed_price)
VALUES (
  (SELECT id FROM categorie WHERE LOWER(nom)='adulte'),
  (SELECT id FROM tarif WHERE LOWER(nom)='premium'),
  'FIXED',
  5000
);






