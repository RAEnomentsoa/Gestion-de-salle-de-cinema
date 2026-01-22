// ===============================
// FILE: src/main/java/cinema/Societe.java
// ===============================
package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Societe {

    long id;
    String num;
    Double prix; // ✅ can be NULL

    // ---------------------------
    // CONSTRUCTEURS
    // ---------------------------
    public Societe() {
    }

    public Societe(long id) {
        setId(id);
    }

    // ✅ Constructor that accepts NULL
    public Societe(long id, String num, Double prix) {
        setId(id);
        setNum(num);
        setPrix(prix);
    }

    public Societe(String num, Double prix) {
        setNum(num);
        setPrix(prix);
    }

    // ---------------------------
    // GETTERS / SETTERS
    // ---------------------------
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNum() {
        return num;
    }

    public void setNum(String num) {
        this.num = num;
    }

    public Double getPrix() {
        return prix;
    }

    public void setPrix(Double prix) {
        this.prix = prix;
    }

    // ---------------------------
    // CREATE
    // ---------------------------
    public void create() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            create(connection);
        }
    }

    public void create(Connection connection) throws SQLException {
        String sql = "INSERT INTO societe (num, prix) VALUES (?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, getNum());

            if (getPrix() == null)
                ps.setNull(2, Types.NUMERIC);
            else
                ps.setDouble(2, getPrix());

            ps.executeUpdate();
        }
    }

    // ---------------------------
    // READ by ID
    // ---------------------------
    public void getById() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            getById(connection);
        }
    }

    public void getById(Connection connection) throws SQLException {
        String sql = "SELECT * FROM societe WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, getId());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    setNum(rs.getString("num"));

                    double p = rs.getDouble("prix");
                    if (rs.wasNull())
                        setPrix(null);
                    else
                        setPrix(p);
                }
            }
        }
    }

    // ---------------------------
    // UPDATE
    // ---------------------------
    public void update() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            update(connection);
        }
    }

    public void update(Connection connection) throws SQLException {
        String sql = "UPDATE societe SET num = ?, prix = ? WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, getNum());

            if (getPrix() == null)
                ps.setNull(2, Types.NUMERIC);
            else
                ps.setDouble(2, getPrix());

            ps.setLong(3, getId());
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // DELETE
    // ---------------------------
    public void delete() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            delete(connection);
        }
    }

    public void delete(Connection connection) throws SQLException {
        String sql = "DELETE FROM societe WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setLong(1, getId());
            ps.executeUpdate();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Societe> getAll() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            return getAll(connection);
        }
    }

    public static List<Societe> getAll(Connection connection) throws SQLException {
        List<Societe> list = new ArrayList<>();
        String sql = "SELECT * FROM societe ORDER BY id";

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Double prix = null;
                double p = rs.getDouble("prix");
                if (!rs.wasNull())
                    prix = p;

                list.add(new Societe(
                        rs.getLong("id"),
                        rs.getString("num"),
                        prix));
            }
        }
        return list;
    }
}
