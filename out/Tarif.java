package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Tarif {
    private long id;       // correspond à "id" dans la table tarif
    private String nom;
    private double prix;

    // ---------------------------
    // Constructeurs
    // ---------------------------
    public Tarif() {
    }

    public Tarif(long id) {
        setId(id);
    }

    public Tarif(long id, String nom, double prix) {
        setId(id);
        setNom(nom);
        setPrix(prix);
    }

    public Tarif(String nom, double prix) {
        setNom(nom);
        setPrix(prix);
    }

    // ---------------------------
    // Getters et Setters
    // ---------------------------
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
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
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            create(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void create(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "INSERT INTO tarif (nom, prix) VALUES (?, ?)";
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, this.getNom());
            statement.setDouble(2, this.getPrix());
            statement.executeUpdate();

            // récupérer l'id généré automatiquement
            ResultSet rs = statement.getGeneratedKeys();
            if (rs.next()) {
                this.setId(rs.getLong(1));
            }
            if (rs != null)
                rs.close();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

    // ---------------------------
    // READ by ID
    // ---------------------------
    public void getById() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            getById(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void getById(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            String sql = "SELECT * FROM tarif WHERE id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                this.setNom(resultSet.getString("nom"));
                this.setPrix(resultSet.getDouble("prix"));
            }
        } finally {
            if (resultSet != null)
                resultSet.close();
            if (statement != null)
                statement.close();
        }
    }

    // ---------------------------
    // UPDATE
    // ---------------------------
    public void update() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            update(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void update(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "UPDATE tarif SET nom = ?, prix = ? WHERE id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, this.getNom());
            statement.setDouble(2, this.getPrix());
            statement.setLong(3, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

    // ---------------------------
    // DELETE
    // ---------------------------
    public void delete() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            delete(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void delete(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "DELETE FROM tarif WHERE id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Tarif> getAll() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return getAll(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public static List<Tarif> getAll(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Tarif> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM tarif ORDER BY id";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                list.add(new Tarif(
                        resultSet.getLong("id"),
                        resultSet.getString("nom"),
                        resultSet.getDouble("prix")
                ));
            }
        } finally {
            if (resultSet != null)
                resultSet.close();
            if (statement != null)
                statement.close();
        }
        return list;
    }
}
