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
    int seatType; // STANDARD/VIP/PMR/LOVESEAT
    boolean isActive;

    public Seat() {
    }

    public Seat(long id) {
        setId(id);
    }

    public Seat(long id, long roomId, String rowLabel, int seatNumber, int seatType, boolean isActive) {
        setId(id);
        setRoomId(roomId);
        setRowLabel(rowLabel);
        setSeatNumber(seatNumber);
        setSeatType(seatType);
        setActive(isActive);
    }

    public Seat(long roomId, String rowLabel, int seatNumber, int seatType, boolean isActive) {
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

    public int getSeatType() {
        return seatType;
    }

    public void setSeatType(int seatType) {
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
        PreparedStatement stmtRoom = null;
        PreparedStatement stmtCount = null;
        PreparedStatement stmtInsert = null;
        ResultSet rsRoom = null;
        ResultSet rsCount = null;

        try {
            // 1) Verrouille la ligne room pour éviter 2 insertions concurrentes qui
            // dépassent la capacité
            String sqlRoom = "SELECT capacity FROM room WHERE room_id = ? FOR UPDATE";
            stmtRoom = connection.prepareStatement(sqlRoom);
            stmtRoom.setLong(1, this.getRoomId());
            rsRoom = stmtRoom.executeQuery();

            if (!rsRoom.next()) {
                throw new SQLException("Room not found: room_id=" + this.getRoomId());
            }

            int capacity = rsRoom.getInt("capacity");

            // 2) Compte les sièges existants (choisis active seulement ou tous selon ton
            // besoin)
            String sqlCount = "SELECT COUNT(*) AS seat_count FROM seat WHERE room_id = ? AND is_active = TRUE";
            stmtCount = connection.prepareStatement(sqlCount);
            stmtCount.setLong(1, this.getRoomId());
            rsCount = stmtCount.executeQuery();

            rsCount.next();
            int currentSeats = rsCount.getInt("seat_count");

            if (currentSeats >= capacity) {
                throw new SQLException(
                        "Capacity reached for room_id=" + this.getRoomId() +
                                " (capacity=" + capacity + ", current=" + currentSeats + ")");
            }

            // 3) Insert
            String sqlInsert = "INSERT INTO seat (room_id, row_label, seat_number, seat_type, is_active) " +
                    "VALUES (?, ?, ?, ?, ?)";
            stmtInsert = connection.prepareStatement(sqlInsert);
            stmtInsert.setLong(1, this.getRoomId());
            stmtInsert.setString(2, this.getRowLabel());
            stmtInsert.setInt(3, this.getSeatNumber());
            stmtInsert.setLong(4, this.getSeatType()); // seat_type = tarif.id (BIGINT)
            stmtInsert.setBoolean(5, this.isActive());

            stmtInsert.executeUpdate();

        } finally {
            if (rsCount != null)
                rsCount.close();
            if (rsRoom != null)
                rsRoom.close();
            if (stmtInsert != null)
                stmtInsert.close();
            if (stmtCount != null)
                stmtCount.close();
            if (stmtRoom != null)
                stmtRoom.close();
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
                this.setSeatType(resultSet.getInt("seat_type"));
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
            statement.setInt(4, this.getSeatType());
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
                        resultSet.getInt("seat_type"),
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

    public static double getSumPrixSeatByRoomId(long roomId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(t.prix), 0) AS total " +
                "FROM seat s " +
                "JOIN tarif t ON s.seat_type = t.id " +
                "WHERE s.room_id = ? AND s.is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
        }
        return 0.0;
    }

    public static List<Seat> getSeatsByRoomId(long roomId) throws SQLException {
        String sql = "SELECT s.seat_id, s.row_label, s.seat_number, s.seat_type, s.is_active, t.nom AS seat_type_name "
                +
                "FROM seat s " +
                "JOIN tarif t ON s.seat_type = t.id " +
                "WHERE s.room_id = ? AND s.is_active = TRUE " +
                "ORDER BY s.row_label, s.seat_number";

        List<Seat> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Seat s = new Seat();
                    s.setId(rs.getLong("seat_id"));
                    s.setRowLabel(rs.getString("row_label"));
                    s.setSeatNumber(rs.getInt("seat_number"));
                    s.setSeatType(rs.getInt("seat_type"));
                    s.setActive(rs.getBoolean("is_active"));
                    list.add(s);
                }
            }
        }
        return list;
    }
}
