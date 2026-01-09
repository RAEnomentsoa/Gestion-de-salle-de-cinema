package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Cinema {
    long id; // cinema_id
    String name;
    String address;
    String city;
    String status;

    public Cinema() {
    }

    public Cinema(long id) {
        setId(id);
    }

    public Cinema(long id, String name, String address, String city, String status) {
        setId(id);
        setName(name);
        setAddress(address);
        setCity(city);
        setStatus(status);
    }

    public Cinema(String name, String address, String city, String status) {
        setName(name);
        setAddress(address);
        setCity(city);
        setStatus(status);
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ---------------------------
    // CREATE
    // ---------------------------
    public void create() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            create(connection);
        } catch (Exception e) {
            throw e;
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void create(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "INSERT INTO cinema (name, address, city, status) VALUES (?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, this.getName());
            statement.setString(2, this.getAddress());
            statement.setString(3, this.getCity());
            statement.setString(4, (this.getStatus() == null) ? "ACTIVE" : this.getStatus());
            statement.executeUpdate();
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
        } catch (Exception e) {
            throw e;
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void getById(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            String sql = "SELECT * FROM cinema WHERE cinema_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                this.setName(resultSet.getString("name"));
                this.setAddress(resultSet.getString("address"));
                this.setCity(resultSet.getString("city"));
                this.setStatus(resultSet.getString("status"));
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
        } catch (Exception e) {
            throw e;
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void update(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "UPDATE cinema SET name = ?, address = ?, city = ?, status = ? WHERE cinema_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, this.getName());
            statement.setString(2, this.getAddress());
            statement.setString(3, this.getCity());
            statement.setString(4, this.getStatus());
            statement.setLong(5, this.getId());
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
        } catch (Exception e) {
            throw e;
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public void delete(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        try {
            String sql = "DELETE FROM cinema WHERE cinema_id = ?";
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
    public static List<Cinema> getAll() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return getAll(connection);
        } catch (Exception e) {
            throw e;
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public static List<Cinema> getAll(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Cinema> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM cinema ORDER BY cinema_id";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                list.add(new Cinema(
                        resultSet.getLong("cinema_id"),
                        resultSet.getString("name"),
                        resultSet.getString("address"),
                        resultSet.getString("city"),
                        resultSet.getString("status")));
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
