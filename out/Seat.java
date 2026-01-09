package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Seat {
    long id; // seat_id
    long roomId; // room_id
    String rowLabel;
    int seatNumber;
    String seatType; // STANDARD/VIP/PMR/LOVESEAT
    boolean isActive;

    public Seat() {
    }

    public Seat(long id) {
        setId(id);
    }

    public Seat(long id, long roomId, String rowLabel, int seatNumber, String seatType, boolean isActive) {
        setId(id);
        setRoomId(roomId);
        setRowLabel(rowLabel);
        setSeatNumber(seatNumber);
        setSeatType(seatType);
        setActive(isActive);
    }

    public Seat(long roomId, String rowLabel, int seatNumber, String seatType, boolean isActive) {
        setRoomId(roomId);
        setRowLabel(rowLabel);
        setSeatNumber(seatNumber);
        setSeatType(seatType);
        setActive(isActive);
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getRoomId() {
        return roomId;
    }

    public void setRoomId(long roomId) {
        this.roomId = roomId;
    }

    public String getRowLabel() {
        return rowLabel;
    }

    public void setRowLabel(String rowLabel) {
        this.rowLabel = rowLabel;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(int seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
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
            String sql = "INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active) VALUES (?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getRoomId());
            statement.setString(2, this.getRowLabel());
            statement.setInt(3, this.getSeatNumber());
            statement.setString(4, (this.getSeatType() == null) ? "STANDARD" : this.getSeatType());
            statement.setBoolean(5, this.isActive());
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
            String sql = "SELECT * FROM seat WHERE seat_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                this.setRoomId(resultSet.getLong("room_id"));
                this.setRowLabel(resultSet.getString("row_label"));
                this.setSeatNumber(resultSet.getInt("seat_number"));
                this.setSeatType(resultSet.getString("seat_type"));
                this.setActive(resultSet.getBoolean("is_active"));
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
            String sql = "UPDATE seat SET room_id = ?, row_label = ?, seat_number = ?, seat_type = ?, is_active = ? WHERE seat_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getRoomId());
            statement.setString(2, this.getRowLabel());
            statement.setInt(3, this.getSeatNumber());
            statement.setString(4, this.getSeatType());
            statement.setBoolean(5, this.isActive());
            statement.setLong(6, this.getId());
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
            String sql = "DELETE FROM seat WHERE seat_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

    public static List<Seat> getAll() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return getAll(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public static List<Seat> getAll(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Seat> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM seat ORDER BY seat_id";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(new Seat(
                        resultSet.getLong("seat_id"),
                        resultSet.getLong("room_id"),
                        resultSet.getString("row_label"),
                        resultSet.getInt("seat_number"),
                        resultSet.getString("seat_type"),
                        resultSet.getBoolean("is_active")));
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
