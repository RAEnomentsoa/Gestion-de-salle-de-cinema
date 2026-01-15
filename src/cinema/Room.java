package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Room {
    long id; // room_id
    long cinemaId; // cinema_id
    String name;
    long capacity;
    String status;

    public Room() {
    }

    public Room(long id) {
        setId(id);
    }

    public Room(long id, long cinemaId, String name, long capacity, String status) {
        setId(id);
        setCinemaId(cinemaId);
        setName(name);
        setCapacity(capacity);
        setStatus(status);
    }

    public Room(long cinemaId, String name, long capacity, String status) {
        setCinemaId(cinemaId);
        setName(name);
        setCapacity(capacity);
        setStatus(status);
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getCinemaId() {
        return cinemaId;
    }

    public void setCinemaId(long cinemaId) {
        this.cinemaId = cinemaId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getCapacity() {
        return capacity;
    }

    public void setCapacity(long capacity) {
        this.capacity = capacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

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
            String sql = "INSERT INTO room (cinema_id, name, capacity, status) VALUES (?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getCinemaId());
            statement.setString(2, this.getName());
            statement.setLong(3, this.getCapacity()); // can be null
            statement.setString(4, (this.getStatus() == null) ? "ACTIVE" : this.getStatus());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

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
            String sql = "SELECT * FROM room WHERE room_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                this.setCinemaId(resultSet.getLong("cinema_id"));
                this.setName(resultSet.getString("name"));
                this.setCapacity(resultSet.getLong("capacity"));
                this.setStatus(resultSet.getString("status"));
            }
        } finally {
            if (resultSet != null)
                resultSet.close();
            if (statement != null)
                statement.close();
        }
    }

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
            String sql = "UPDATE room SET cinema_id = ?, name = ?, capacity = ?, status = ? WHERE room_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getCinemaId());
            statement.setString(2, this.getName());
            statement.setLong(3, this.getCapacity());
            statement.setString(4, this.getStatus());
            statement.setLong(5, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

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
            String sql = "DELETE FROM room WHERE room_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

    public static List<Room> getAll() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return getAll(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public static List<Room> getAll(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Room> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM room ORDER BY room_id";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(new Room(
                        resultSet.getLong("room_id"),
                        resultSet.getLong("cinema_id"),
                        resultSet.getString("name"),
                        resultSet.getLong("capacity"),
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
