package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Categorie {

    int id;
    String nom;
    Integer prix; // Peut être null

    // ---------------------------
    // CONSTRUCTEURS
    // ---------------------------
    public Categorie() { }

    public Categorie(int id) {
        setId(id);
    }

    public Categorie(int id, String nom, Integer prix) {
        setId(id);
        setNom(nom);
        setPrix(prix);
    }

    public Categorie(String nom, Integer prix) {
        setNom(nom);
        setPrix(prix);
    }

    // ---------------------------
    // GETTERS / SETTERS
    // ---------------------------
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Integer getPrix() {
        return prix;
    }

    public void setPrix(Integer prix) {
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
        String sql = "INSERT INTO categorie (nom, prix) VALUES (?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, this.getNom());
            if (this.getPrix() != null) {
                statement.setInt(2, this.getPrix());
            } else {
                statement.setNull(2, Types.INTEGER);
            }
            statement.executeUpdate();
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
        String sql = "SELECT * FROM categorie WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, this.getId());

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    this.setNom(resultSet.getString("nom"));
                    int p = resultSet.getInt("prix");
                    if (resultSet.wasNull()) {
                        this.setPrix(null);
                    } else {
                        this.setPrix(p);
                    }
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
        String sql = "UPDATE categorie SET nom = ?, prix = ? WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, this.getNom());
            if (this.getPrix() != null) {
                statement.setInt(2, this.getPrix());
            } else {
                statement.setNull(2, Types.INTEGER);
            }
            statement.setInt(3, this.getId());
            statement.executeUpdate();
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
        String sql = "DELETE FROM categorie WHERE id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, this.getId());
            statement.executeUpdate();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Categorie> getAll() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            return getAll(connection);
        }
    }

    public static List<Categorie> getAll(Connection connection) throws SQLException {
        List<Categorie> list = new ArrayList<>();
        String sql = "SELECT * FROM categorie ORDER BY id";

        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                int p = resultSet.getInt("prix");
                Integer prixVal = resultSet.wasNull() ? null : p;
                list.add(new Categorie(
                        resultSet.getInt("id"),
                        resultSet.getString("nom"),
                        prixVal
                ));
            }
        }
        return list;
    }
}
