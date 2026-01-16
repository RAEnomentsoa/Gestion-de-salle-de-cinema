package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Client {

    long id; // client_id
    String nom;
    String address;
    int age;
    int id_categorie;

    // ---------------------------
    // CONSTRUCTEURS
    // ---------------------------
    public Client() { }

    public Client(long id) {
        setId(id);
    }

    public Client(long id, String nom, String address, int age, int id_categorie) {
        setId(id);
        setNom(nom);
        setAddress(address);
        setAge(age);
        setId_categorie(id_categorie);
    }

    public Client(String nom, String address, int age, int id_categorie) {
        setNom(nom);
        setAddress(address);
        setAge(age);
        setId_categorie(id_categorie);
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

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public int getId_categorie() {
        return id_categorie;
    }

    public void setId_categorie(int id_categorie) {
        this.id_categorie = id_categorie;
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
            INSERT INTO client (id_categorie, nom, address, age)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, this.getId_categorie());
            statement.setString(2, this.getNom());
            statement.setString(3, this.getAddress());
            statement.setInt(4, this.getAge());
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
        String sql = "SELECT * FROM client WHERE client_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getId());

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    this.setNom(resultSet.getString("nom"));
                    this.setAddress(resultSet.getString("address"));
                    this.setAge(resultSet.getInt("age"));
                    this.setId_categorie(resultSet.getInt("id_categorie"));
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
            UPDATE client
            SET nom = ?, address = ?, age = ?, id_categorie = ?
            WHERE client_id = ?
        """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, this.getNom());
            statement.setString(2, this.getAddress());
            statement.setInt(3, this.getAge());
            statement.setInt(4, this.getId_categorie());
            statement.setLong(5, this.getId());
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
        String sql = "DELETE FROM client WHERE client_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getId());
            statement.executeUpdate();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Client> getAll() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            return getAll(connection);
        }
    }

    public static List<Client> getAll(Connection connection) throws SQLException {
        List<Client> list = new ArrayList<>();
        String sql = "SELECT * FROM client ORDER BY client_id";

        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                list.add(new Client(
                        resultSet.getLong("client_id"),
                        resultSet.getString("nom"),
                        resultSet.getString("address"),
                        resultSet.getInt("age"),
                        resultSet.getInt("id_categorie")
                ));
            }
        }
        return list;
    }
}
