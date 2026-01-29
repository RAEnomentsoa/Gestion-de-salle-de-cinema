CREATE TABLE paiement_detail (
  id BIGSERIAL PRIMARY KEY,
  paiement_id BIGINT NOT NULL REFERENCES paiement(id) ON DELETE CASCADE,
  showtime_id BIGINT NOT NULL REFERENCES showtime(showtime_id) ON DELETE RESTRICT,
  montant NUMERIC(12,2) NOT NULL CHECK (montant >= 0),
  UNIQUE (paiement_id, showtime_id)
);

CREATE TABLE facture (
  id BIGSERIAL PRIMARY KEY,
  societe_id BIGINT NOT NULL,          -- can be FK or just stored as history
  period_start DATE NOT NULL,
  period_end   DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),

  total_ticket NUMERIC(12,2) NOT NULL DEFAULT 0,
  total_pub    NUMERIC(12,2) NOT NULL DEFAULT 0,
  total_due    NUMERIC(12,2) NOT NULL DEFAULT 0,
  total_paid   NUMERIC(12,2) NOT NULL DEFAULT 0,
  balance      NUMERIC(12,2) NOT NULL DEFAULT 0,

  status VARCHAR(12) NOT NULL DEFAULT 'DRAFT'
    CHECK (status IN ('DRAFT','SENT','PAID','CANCELED'))
);

CREATE TABLE facture_detail (
  id BIGSERIAL PRIMARY KEY,
  facture_id BIGINT NOT NULL REFERENCES facture(id) ON DELETE CASCADE,

  showtime_id BIGINT NOT NULL,               -- history (optional FK)
  movie_title VARCHAR(200) NOT NULL,         -- snapshot
  starts_at   TIMESTAMP NOT NULL,            -- snapshot

  ticket_revenue NUMERIC(12,2) NOT NULL DEFAULT 0,
  pub_amount     NUMERIC(12,2) NOT NULL DEFAULT 0,
  line_total     NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE INDEX idx_facture_societe_period ON facture(societe_id, period_start, period_end);
CREATE INDEX idx_facture_detail_facture ON facture_detail(facture_id);





-- Fonction generer facture 

CREATE OR REPLACE FUNCTION generate_facture(p_societe BIGINT, p_start DATE, p_end DATE)
RETURNS BIGINT AS $$
DECLARE
  v_facture_id BIGINT;
BEGIN
  -- 1) create facture row (or reuse existing)
  INSERT INTO facture (societe_id, period_start, period_end, status)
  VALUES (p_societe, p_start, p_end, 'DRAFT')
  RETURNING id INTO v_facture_id;

  -- 2) insert lines (facture_detail)
  INSERT INTO facture_detail (
    facture_id, showtime_id, movie_title, starts_at,
    ticket_revenue, pub_amount, line_total
  )
  SELECT
    v_facture_id,
    st.showtime_id,
    m.title AS movie_title,
    st.starts_at,

    -- ticket revenue (paid reservations only)
    COALESCE((
      SELECT SUM(t.prix)
      FROM reservation r
      JOIN ticket t ON t.ticket_id = r.ticket_id
      WHERE r.status = 'PAYER'
        AND t.showtime_id = st.showtime_id
        AND t.created_at::date BETWEEN p_start AND p_end
    ), 0) AS ticket_revenue,

    -- pub amount for this societe + showtime in the period
    COALESCE((
      SELECT SUM(pt.prix)
      FROM pub p
      JOIN pub_tarif pt ON pt.id = p.id_prix
      WHERE p.id_societe = p_societe
        AND p.showtime_id = st.showtime_id
        AND p.dates::date BETWEEN p_start AND p_end
    ), 0) AS pub_amount,

    -- line_total = tickets + pub
    (
      COALESCE((
        SELECT SUM(t.prix)
        FROM reservation r
        JOIN ticket t ON t.ticket_id = r.ticket_id
        WHERE r.status = 'PAYER'
          AND t.showtime_id = st.showtime_id
          AND t.created_at::date BETWEEN p_start AND p_end
      ), 0)
      +
      COALESCE((
        SELECT SUM(pt.prix)
        FROM pub p
        JOIN pub_tarif pt ON pt.id = p.id_prix
        WHERE p.id_societe = p_societe
          AND p.showtime_id = st.showtime_id
          AND p.dates::date BETWEEN p_start AND p_end
      ), 0)
    ) AS line_total

  FROM showtime st
  JOIN movie m ON m.movie_id = st.movie_id
  WHERE st.starts_at::date BETWEEN p_start AND p_end
    AND EXISTS (
      SELECT 1
      FROM pub p
      WHERE p.id_societe = p_societe
        AND p.showtime_id = st.showtime_id
        AND p.dates::date BETWEEN p_start AND p_end
    );

  -- 3) update totals (invoice header)
  UPDATE facture f
  SET
    total_ticket = COALESCE((SELECT SUM(ticket_revenue) FROM facture_detail d WHERE d.facture_id = f.id), 0),
    total_pub    = COALESCE((SELECT SUM(pub_amount)     FROM facture_detail d WHERE d.facture_id = f.id), 0),
    total_due    = COALESCE((SELECT SUM(line_total)     FROM facture_detail d WHERE d.facture_id = f.id), 0),

    -- total_paid: simplest version = all payments by societe in period
    total_paid = COALESCE((
      SELECT SUM(pa.montant)
      FROM paiement pa
      WHERE pa.id_societe = p_societe
        AND pa.date::date BETWEEN p_start AND p_end
    ), 0),

    balance = COALESCE((SELECT SUM(line_total) FROM facture_detail d WHERE d.facture_id = f.id), 0)
              - COALESCE((
                SELECT SUM(pa.montant)
                FROM paiement pa
                WHERE pa.id_societe = p_societe
                  AND pa.date::date BETWEEN p_start AND p_end
              ), 0)

  WHERE f.id = v_facture_id;

  RETURN v_facture_id;
END;
$$ LANGUAGE plpgsql;
