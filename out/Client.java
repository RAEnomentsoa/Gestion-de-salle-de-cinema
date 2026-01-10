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

    public Client() { }

    public Client(long id) {
        setId(id);
    }

    public Client(long id, String nom, String address, int age) {
        setId(id);
        setNom(nom);
        setAddress(address);
        setAge(age);
    }

    public Client(String nom, String address, int age) {
        setNom(nom);
        setAddress(address);
        setAge(age);
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

    // ---------------------------
    // CREATE
    // ---------------------------
    public void create() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            create(connection);
        } finally {
            if (connection != null) connection.close();
        }
    }

    public void create(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "INSERT INTO client (nom, address, age) VALUES (?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, this.getNom());
            statement.setString(2, this.getAddress());
            statement.setInt(3, this.getAge());
            statement.executeUpdate();
        } finally {
            if (statement != null) statement.close();
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
            if (connection != null) connection.close();
        }
    }

    public void getById(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            String sql = "SELECT * FROM client WHERE client_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                this.setNom(resultSet.getString("nom"));
                this.setAddress(resultSet.getString("address"));
                this.setAge(resultSet.getInt("age"));
            }
        } finally {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
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
            if (connection != null) connection.close();
        }
    }

    public void update(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "UPDATE client SET nom = ?, address = ?, age = ? WHERE client_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, this.getNom());
            statement.setString(2, this.getAddress());
            statement.setInt(3, this.getAge());
            statement.setLong(4, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null) statement.close();
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
            if (connection != null) connection.close();
        }
    }

    public void delete(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "DELETE FROM client WHERE client_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null) statement.close();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Client> getAll() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return getAll(connection);
        } finally {
            if (connection != null) connection.close();
        }
    }

    public static List<Client> getAll(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Client> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM client ORDER BY client_id";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                list.add(new Client(
                        resultSet.getLong("client_id"),
                        resultSet.getString("nom"),
                        resultSet.getString("address"),
                        resultSet.getInt("age")
                ));
            }
        } finally {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
        }
        return list;
    }
}
