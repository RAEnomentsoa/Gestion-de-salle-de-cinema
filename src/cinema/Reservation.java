package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Reservation {
    private long reservationId;
    private long ticketId;
    private long clientId;
    private String status;
    private Timestamp createdAt;

    // ---------------------------
    // Constructors
    // ---------------------------
    public Reservation() {
    }

    public Reservation(long reservationId) {
        this.reservationId = reservationId;
    }

    public Reservation(long reservationId, long ticketId, long clientId, String status) {
        this.reservationId = reservationId;
        this.ticketId = ticketId;
        this.clientId = clientId;
        this.status = status;
    }

    // ---------------------------
    // Getters & Setters
    // ---------------------------
    public long getReservationId() {
        return reservationId;
    }

    public void setReservationId(long reservationId) {
        this.reservationId = reservationId;
    }

    public long getTicketId() {
        return ticketId;
    }

    public void setTicketId(long ticketId) {
        this.ticketId = ticketId;
    }

    public long getClientId() {
        return clientId;
    }

    public void setClientId(long clientId) {
        this.clientId = clientId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
        String sql = "INSERT INTO reservation (ticket_id, client_id, status) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getTicketId());
            statement.setLong(2, this.getClientId());
            statement.setString(3, (this.getStatus() == null) ? "NON_PAYER" : this.getStatus());
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
        String sql = "SELECT * FROM reservation WHERE reservation_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getReservationId());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    this.setTicketId(resultSet.getLong("ticket_id"));
                    this.setClientId(resultSet.getLong("client_id"));
                    this.setStatus(resultSet.getString("status"));
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
        String sql = "UPDATE reservation SET ticket_id = ?, client_id = ?, status = ? WHERE reservation_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getTicketId());
            statement.setLong(2, this.getClientId());
            statement.setString(3, this.getStatus());
            statement.setLong(4, this.getReservationId());
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
        String sql = "DELETE FROM reservation WHERE reservation_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, this.getReservationId());
            statement.executeUpdate();
        }
    }

    // ---------------------------
    // GET ALL
    // ---------------------------
    public static List<Reservation> getAll() throws Exception {
        try (Connection connection = DBConnection.getConnection()) {
            return getAll(connection);
        }
    }

    public static List<Reservation> getAll(Connection connection) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservation ORDER BY reservation_id";
        try (PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Reservation r = new Reservation(
                        resultSet.getLong("reservation_id"),
                        resultSet.getLong("ticket_id"),
                        resultSet.getLong("client_id"),
                        resultSet.getString("status"));
                r.setCreatedAt(resultSet.getTimestamp("created_at"));
                list.add(r);
            }
        }
        return list;
    }
}