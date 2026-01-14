package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Ticket {
    private long ticketId;
    private long showtimeId;
    private Long seatId;
    private double prix;
    private Timestamp createdAt;

    // ---------------------------
    // Constructors
    // ---------------------------
    public Ticket() {
    }

    public Ticket(long ticketId) {
        this.ticketId = ticketId;
    }

    public Ticket(long ticketId, long showtimeId, Long seatId, double prix) {
        this.ticketId = ticketId;
        this.showtimeId = showtimeId;
        this.seatId = seatId;
        this.prix = prix;
    }

    // ---------------------------
    // Getters & Setters
    // ---------------------------
    public long getTicketId() {
        return ticketId;
    }

    public void setTicketId(long ticketId) {
        this.ticketId = ticketId;
    }

    public long getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(long showtimeId) {
        this.showtimeId = showtimeId;
    }

    public Long getSeatId() {
        return seatId;
    }

    public void setSeatId(Long seatId) {
        this.seatId = seatId;
    }

    public double getPrix() {
        return prix;
    }

    public void setPrix(double prix) {
        this.prix = prix;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
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
        String sql = "INSERT INTO ticket (showtime_id, seat_id, prix) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getShowtimeId());
            if (this.getSeatId() != null) {
                statement.setLong(2, this.getSeatId());
            } else {
                statement.setNull(2, Types.BIGINT);
            }
            statement.setDouble(3, this.getPrix());
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
        String sql = "SELECT * FROM ticket WHERE ticket_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getTicketId());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    this.setShowtimeId(resultSet.getLong("showtime_id"));
                    long seat = resultSet.getLong("seat_id");
                    this.setSeatId(resultSet.wasNull() ? null : seat);
                    this.setPrix(resultSet.getDouble("prix"));
                    this.setCreatedAt(resultSet.getTimestamp("created_at"));
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
        String sql = "UPDATE ticket SET showtime_id = ?, seat_id = ?, prix = ? WHERE ticket_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getShowtimeId());
            if (this.getSeatId() != null) {
                statement.setLong(2, this.getSeatId());
            } else {
                statement.setNull(2, Types.BIGINT);
            }
            statement.setDouble(3, this.getPrix());
            statement.setLong(4, this.getTicketId());
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
        String sql = "DELETE FROM ticket WHERE ticket_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getTicketId());
            statement.executeUpdate();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Ticket> getAll() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            return getAll(connection);
        }
    }

    public static List<Ticket> getAll(Connection connection) throws SQLException {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT * FROM ticket ORDER BY ticket_id";
        try (PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Ticket t = new Ticket(
                        resultSet.getLong("ticket_id"),
                        resultSet.getLong("showtime_id"),
                        resultSet.getObject("seat_id") == null ? null : resultSet.getLong("seat_id"),
                        resultSet.getDouble("prix"));
                t.setCreatedAt(resultSet.getTimestamp("created_at"));
                list.add(t);
            }
        }
        return list;
    }
}