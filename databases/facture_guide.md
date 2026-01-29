
<!-- call fonction generate_facture  -->

long factureId;
try (Connection cn = DBConnection.getConnection();
     PreparedStatement ps = cn.prepareStatement("SELECT generate_facture(?, ?, ?)")) {
  ps.setLong(1, societeId);
  ps.setDate(2, java.sql.Date.valueOf(startDate));
  ps.setDate(3, java.sql.Date.valueOf(endDate));
  try (ResultSet rs = ps.executeQuery()) {
    rs.next();
    factureId = rs.getLong(1);
  }
}
response.sendRedirect("facture_detail.jsp?id=" + factureId);


<!-- Guide  -->

Guide (FR) — Facture & facture détaillée automatiques (mode historique)
Objectif

Mettre en place un système où :

la facture (en-tête) et la facture_detail (lignes) sont générées automatiquement depuis les tables sources (ticket/reservation/pub/paiement)

une facture est une photo (snapshot) à un instant T (historique) : une fois générée, elle ne change pas si les données de films, séances, etc. changent plus tard.

le JSP n’effectue plus de calculs “à la main” : il affiche des données déjà calculées et cohérentes.

0) Problème à corriger immédiatement (bug de calcul actuel)

Dans le code actuel, la partie :

getPourcentage_showtime(showtimeId) calcule un pourcentage avec :

totalAPayer = pubs du showtime ✅

totalPaye = paiements globaux de toutes sociétés / toutes périodes ❌

👉 Résultat : les montants “payé” et “reste à payer” deviennent faux dès qu’il y a plusieurs sociétés ou plusieurs showtimes.

✅ Conclusion : on arrête les calculs de facture dans le JSP. On calcule en base (fonction SQL) et on affiche.

1) Décision d’architecture (à appliquer)

On met en place un modèle historique :

facture : en-tête (totaux, période, société, solde, statut)

facture_detail : lignes par showtime (titre film, date séance, ticket_revenue, pub_amount, line_total)

Les factures sont générées via une fonction PostgreSQL : generate_facture(societe, date_debut, date_fin).

2) Créer les tables “snapshot” (facture / facture_detail)
2.1 Table facture (en-tête)
CREATE TABLE facture (
  id BIGSERIAL PRIMARY KEY,
  societe_id BIGINT NOT NULL,
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

CREATE INDEX idx_facture_societe_period ON facture(societe_id, period_start, period_end);

2.2 Table facture_detail (lignes)

⚠️ On stocke movie_title et starts_at en snapshot pour que la facture reste stable.

CREATE TABLE facture_detail (
  id BIGSERIAL PRIMARY KEY,
  facture_id BIGINT NOT NULL REFERENCES facture(id) ON DELETE CASCADE,

  showtime_id BIGINT NOT NULL,
  movie_title VARCHAR(200) NOT NULL,
  starts_at   TIMESTAMP NOT NULL,

  ticket_revenue NUMERIC(12,2) NOT NULL DEFAULT 0,
  pub_amount     NUMERIC(12,2) NOT NULL DEFAULT 0,
  line_total     NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE INDEX idx_facture_detail_facture ON facture_detail(facture_id);

3) Générer automatiquement : fonction PostgreSQL (la source de vérité)
3.1 Fonction generate_facture

Cette fonction :

crée la facture

calcule et insère les lignes (facture_detail)

met à jour les totaux de la facture

CREATE OR REPLACE FUNCTION generate_facture(p_societe BIGINT, p_start DATE, p_end DATE)
RETURNS BIGINT AS $$
DECLARE
  v_facture_id BIGINT;
BEGIN
  -- 1) Créer la facture (snapshot)
  INSERT INTO facture (societe_id, period_start, period_end, status)
  VALUES (p_societe, p_start, p_end, 'DRAFT')
  RETURNING id INTO v_facture_id;

  -- 2) Insérer les lignes (1 ligne = 1 showtime)
  INSERT INTO facture_detail (
    facture_id, showtime_id, movie_title, starts_at,
    ticket_revenue, pub_amount, line_total
  )
  SELECT
    v_facture_id,
    st.showtime_id,
    m.title AS movie_title,
    st.starts_at,

    -- CA Tickets (réservations payées)
    COALESCE((
      SELECT SUM(t.prix)
      FROM reservation r
      JOIN ticket t ON t.ticket_id = r.ticket_id
      WHERE r.status = 'PAYER'
        AND t.showtime_id = st.showtime_id
        AND t.created_at::date BETWEEN p_start AND p_end
    ), 0) AS ticket_revenue,

    -- Montant pub pour cette société sur ce showtime
    COALESCE((
      SELECT SUM(pt.prix)
      FROM pub p
      JOIN pub_tarif pt ON pt.id = p.id_prix
      WHERE p.id_societe = p_societe
        AND p.showtime_id = st.showtime_id
        AND p.dates::date BETWEEN p_start AND p_end
    ), 0) AS pub_amount,

    -- Total ligne
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

  -- 3) Calculer les totaux facture
  UPDATE facture f
  SET
    total_ticket = COALESCE((SELECT SUM(ticket_revenue) FROM facture_detail d WHERE d.facture_id = f.id), 0),
    total_pub    = COALESCE((SELECT SUM(pub_amount)     FROM facture_detail d WHERE d.facture_id = f.id), 0),
    total_due    = COALESCE((SELECT SUM(line_total)     FROM facture_detail d WHERE d.facture_id = f.id), 0),

    -- Paiements : version simple = paiements société dans la période
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


✅ À ce stade, la facture et ses lignes sont générées automatiquement à partir des vraies données.

4) Intégration côté Java (Servlet/Service)
4.1 Endpoint “Générer facture”

Créer une action (ex: /facture/generate) qui reçoit :

societeId

startDate

endDate

Puis appelle la fonction DB.

Exemple JDBC (simple) :

long factureId;

try (Connection cn = DBConnection.getConnection();
     PreparedStatement ps = cn.prepareStatement("SELECT generate_facture(?, ?, ?)")) {

  ps.setLong(1, societeId);
  ps.setDate(2, java.sql.Date.valueOf(startDate));
  ps.setDate(3, java.sql.Date.valueOf(endDate));

  try (ResultSet rs = ps.executeQuery()) {
    rs.next();
    factureId = rs.getLong(1);
  }
}

response.sendRedirect("facture_detail.jsp?id=" + factureId);

5) Modifier les JSP (important : plus de calculs)
5.1 Avant

Le JSP calcule : pourcentage, payé, reste à payer, etc. → source d’erreur

5.2 Après

Le JSP fait juste :

SELECT facture (header)

SELECT facture_detail (lignes)

affiche

Plus de Pub.getPourcentage_showtime() dans la vue.

6) Pages à prévoir (minimum)

facture_list.jsp : liste des factures par société / période

facture_detail.jsp?id=... : affiche en-tête + lignes

7) Règles de validation (tests obligatoires)

Votre dev doit tester ces cas :

Test A : 1 société / 1 showtime

pub tarif = 10000

tickets payés = 30000
✅ facture_detail.line_total = 40000

Test B : 2 sociétés / même showtime

société 1 pub = 10000

société 2 pub = 20000
✅ chaque facture de société contient uniquement ses pubs.

Test C : paiements hors période

paiement fait en dehors [start,end]
✅ ne doit pas impacter total_paid de la facture période.

Test D : historique

changer movie.title après génération
✅ facture_detail.movie_title ne change pas.

8) Amélioration recommandée (si vous voulez du “vrai” paiement par showtime)

⚠️ Aujourd’hui, paiement n’a pas de showtime_id → on ne sait pas précisément quel showtime est payé.

Solution propre :

créer paiement_detail(paiement_id, showtime_id, montant)

calculer total_paid à partir de paiement_detail.

👉 À faire si vous voulez un “reste à payer” exact par séance.

Résumé exécutable (checklist dev)

✅ 1. Créer tables facture, facture_detail
✅ 2. Créer fonction generate_facture(societe, start, end)
✅ 3. Créer endpoint Java POST /facture/generate
✅ 4. Modifier JSP : afficher facture + lignes, zéro calcul métier
✅ 5. Ajouter tests A/B/C/D

Si tu veux, je peux aussi te donner :

le DAO Facture / FactureDetail en Java (CRUD + readById)

les requêtes SQL pour lister les factures et afficher le détail

une version “regenerate facture” (supprime anciennes lignes si on régénère la même période).

ChatG


