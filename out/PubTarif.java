package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PubTarif {

    private long id;
    private double prix;

    // ---------------------------
    // CONSTRUCTORS
    // ---------------------------
    public PubTarif() {}

    public PubTarif(long id) {
        this.id = id;
    }

    public PubTarif(long id, double prix) {
        this.id = id;
        this.prix = prix;
    }

    public PubTarif(double prix) {
        this.prix = prix;
    }

    // ---------------------------
    // GETTERS / SETTERS
    // ---------------------------
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public double getPrix() { return prix; }
    public void setPrix(double prix) { this.prix = prix; }

    // ---------------------------
    // CREATE
    // ---------------------------
    public void create() throws Exception {
        String sql = "INSERT INTO pub_tarif (prix) VALUES (?)";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setDouble(1, prix);
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // READ BY ID
    // ---------------------------
    public void getById() throws Exception {
        String sql = "SELECT * FROM pub_tarif WHERE id = ?";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setLong(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    prix = rs.getDouble("prix");
                }
            }
        }
    }

    // ---------------------------
    // UPDATE
    // ---------------------------
    public void update() throws Exception {
        String sql = "UPDATE pub_tarif SET prix = ? WHERE id = ?";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setDouble(1, prix);
            ps.setLong(2, id);
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // DELETE
    // ---------------------------
    public void delete() throws Exception {
        String sql = "DELETE FROM pub_tarif WHERE id = ?";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<PubTarif> getAll() throws Exception {
        List<PubTarif> list = new ArrayList<>();

        String sql = "SELECT * FROM pub_tarif ORDER BY id";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new PubTarif(
                        rs.getLong("id"),
                        rs.getDouble("prix")
                ));
            }
        }
        return list;
    }
}
