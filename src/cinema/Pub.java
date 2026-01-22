package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Pub {

    long id;
    long showtime_id;
    long id_societe;     // ✅ NOUVEL ATTRIBUT
    Timestamp dates;
    long id_prix;

    // ---------------------------
    // CONSTRUCTEURS
    // ---------------------------
    public Pub() {}

    public Pub(long id) {
        this.id = id;
    }

    public Pub(long id, long showtime_id, long id_societe, Timestamp dates, long id_prix) {
        this.id = id;
        this.showtime_id = showtime_id;
        this.id_societe = id_societe;
        this.dates = dates;
        this.id_prix = id_prix;
    }

    public Pub(long showtime_id, long id_societe, Timestamp dates, long id_prix) {
        this.showtime_id = showtime_id;
        this.id_societe = id_societe;
        this.dates = dates;
        this.id_prix = id_prix;
    }

    // ---------------------------
    // GETTERS / SETTERS
    // ---------------------------
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getShowtime_id() { return showtime_id; }
    public void setShowtime_id(long showtime_id) { this.showtime_id = showtime_id; }

    public long getId_societe() { return id_societe; }
    public void setId_societe(long id_societe) { this.id_societe = id_societe; }

    public Timestamp getDates() { return dates; }
    public void setDates(Timestamp dates) { this.dates = dates; }

    public long getId_prix() { return id_prix; }
    public void setId_prix(long id_prix) { this.id_prix = id_prix; }

    // ---------------------------
    // CREATE
    // ---------------------------
    public void create() throws Exception {
        try (Connection cn = DBConnection.getConnection()) {
            String sql = """
                INSERT INTO pub (showtime_id, id_societe, dates, id_prix)
                VALUES (?, ?, ?, ?)
            """;

            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setLong(1, showtime_id);
                ps.setLong(2, id_societe);
                ps.setTimestamp(3, dates);
                ps.setLong(4, id_prix);
                ps.executeUpdate();
            }
        }
    }

    // ---------------------------
    // READ BY ID
    // ---------------------------
    public void getById() throws Exception {
        try (Connection cn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM pub WHERE id = ?";
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        showtime_id = rs.getLong("showtime_id");
                        id_societe  = rs.getLong("id_societe");
                        dates       = rs.getTimestamp("dates");
                        id_prix     = rs.getLong("id_prix");
                    }
                }
            }
        }
    }

    // ---------------------------
    // UPDATE
    // ---------------------------
    public void update() throws Exception {
        try (Connection cn = DBConnection.getConnection()) {
            String sql = """
                UPDATE pub
                SET showtime_id = ?, id_societe = ?, dates = ?, id_prix = ?
                WHERE id = ?
            """;

            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setLong(1, showtime_id);
                ps.setLong(2, id_societe);
                ps.setTimestamp(3, dates);
                ps.setLong(4, id_prix);
                ps.setLong(5, id);
                ps.executeUpdate();
            }
        }
    }

    // ---------------------------
    // DELETE
    // ---------------------------
    public void delete() throws Exception {
        try (Connection cn = DBConnection.getConnection()) {
            String sql = "DELETE FROM pub WHERE id = ?";
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setLong(1, id);
                ps.executeUpdate();
            }
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Pub> getAll() throws Exception {
        List<Pub> list = new ArrayList<>();

        try (Connection cn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM pub ORDER BY id";
            try (PreparedStatement ps = cn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(new Pub(
                        rs.getLong("id"),
                        rs.getLong("showtime_id"),
                        rs.getLong("id_societe"),
                        rs.getTimestamp("dates"),
                        rs.getLong("id_prix")
                    ));
                }
            }
        }
        return list;
    }

    // ---------------------------
    // TOTAL CHIFFRE D'AFFAIRE PUB
    // ---------------------------
    public static double getTotalChiffreAffairePub(
            Long showtimeId,
            Integer year,
            Integer month
    ) throws Exception {

        StringBuilder sql = new StringBuilder("""
            SELECT COALESCE(SUM(
                COALESCE(s.prix, pt.prix)
            ), 0) AS total_ca
            FROM pub p
            JOIN pub_tarif pt ON p.id_prix = pt.id
            LEFT JOIN societe s ON p.id_societe = s.id
            WHERE 1 = 1
        """);

        if (showtimeId != null) {
            sql.append(" AND p.showtime_id = ?");
        }
        if (year != null && month != null) {
            sql.append(" AND EXTRACT(YEAR FROM p.dates) = ?");
            sql.append(" AND EXTRACT(MONTH FROM p.dates) = ?");
        }

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {

            int i = 1;
            if (showtimeId != null) ps.setLong(i++, showtimeId);
            if (year != null && month != null) {
                ps.setInt(i++, year);
                ps.setInt(i++, month);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("total_ca");
            }
        }
        return 0;
    }

     public static double resteAPayerParSociete(long societeId) throws SQLException {
        double totalPub = 0;
        double totalPaye = 0;

        String sqlTotalPub = """
            SELECT COALESCE(SUM(COALESCE(s.prix, pt.prix)), 0) AS total_pub
            FROM pub p
            JOIN pub_tarif pt ON p.id_prix = pt.id
            LEFT JOIN societe s ON p.id_societe = s.id
            WHERE p.id_societe = ?
        """;

        String sqlTotalPaye = """
            SELECT COALESCE(SUM(montant), 0) AS total_paye
            FROM paiement
            WHERE id_societe = ?
        """;

        try (Connection cn = DBConnection.getConnection()) {
            // Montant total des pubs
            try (PreparedStatement ps = cn.prepareStatement(sqlTotalPub)) {
                ps.setLong(1, societeId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalPub = rs.getDouble("total_pub");
                    }
                }
            }

            // Montant total payé
            try (PreparedStatement ps = cn.prepareStatement(sqlTotalPaye)) {
                ps.setLong(1, societeId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalPaye = rs.getDouble("total_paye");
                    }
                }
            }
        }

        // Retourne le reste à payer
        return totalPub - totalPaye;
    }
}
