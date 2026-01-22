package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Societe {

    long id;
    String num;
    double prix;

    // ---------------------------
    // CONSTRUCTEURS
    // ---------------------------
    public Societe() {}

    public Societe(long id) {
        setId(id);
    }

    public Societe(long id, String num, double prix) {
        setId(id);
        setNum(num);
        setPrix(prix);
    }

    public Societe(String num, double prix) {
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

    public double getPrix() {
        return prix;
    }

    public void setPrix(double prix) {
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
        String sql = """
            INSERT INTO societe (num, prix)
            VALUES (?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, getNum());
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
                    setPrix(rs.getDouble("prix"));
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
        String sql = """
            UPDATE societe
            SET num = ?, prix = ?
            WHERE id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, getNum());
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
                list.add(new Societe(
                        rs.getLong("id"),
                        rs.getString("num"),
                        rs.getDouble("prix")
                ));
            }
        }
        return list;
    }
}
