package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Showtime {
    long id; // showtime_id
    long roomId;
    long movieId;
    Timestamp startsAt;
    Timestamp endsAt;
    String status; // SCHEDULED/OPEN/CLOSED/CANCELED

    public Showtime() {
    }

    public Showtime(long id) {
        setId(id);
    }

    public Showtime(long id, long roomId, long movieId, Timestamp startsAt, Timestamp endsAt, String status) {
        setId(id);
        setRoomId(roomId);
        setMovieId(movieId);
        setStartsAt(startsAt);
        setEndsAt(endsAt);
        setStatus(status);
    }

    public Showtime(long roomId, long movieId, Timestamp startsAt, Timestamp endsAt,
            String status) {
        setRoomId(roomId);
        setMovieId(movieId);
        setStartsAt(startsAt);
        setEndsAt(endsAt);
        setStatus(status);
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

    public long getMovieId() {
        return movieId;
    }

    public void setMovieId(long movieId) {
        this.movieId = movieId;
    }

    public Timestamp getStartsAt() {
        return startsAt;
    }

    public void setStartsAt(Timestamp startsAt) {
        this.startsAt = startsAt;
    }

    public Timestamp getEndsAt() {
        return endsAt;
    }

    public void setEndsAt(Timestamp endsAt) {
        this.endsAt = endsAt;
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
            String sql = "INSERT INTO showtime ( room_id, movie_id, starts_at, ends_at, status) "
                    +
                    "VALUES (?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setLong(2, this.getRoomId());
            statement.setLong(3, this.getMovieId());
            statement.setTimestamp(4, this.getStartsAt());
            statement.setTimestamp(5, this.getEndsAt());
            statement.setString(7, (this.getStatus() == null) ? "SCHEDULED" : this.getStatus());
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
            String sql = "SELECT * FROM showtime WHERE showtime_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                this.setRoomId(resultSet.getLong("room_id"));
                this.setMovieId(resultSet.getLong("movie_id"));
                this.setStartsAt(resultSet.getTimestamp("starts_at"));
                this.setEndsAt(resultSet.getTimestamp("ends_at"));
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
            String sql = "UPDATE showtime SET cinema_id = ?, room_id = ?, movie_id = ?, starts_at = ?, ends_at = ?, base_price = ?, status = ? "
                    +
                    "WHERE showtime_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(2, this.getRoomId());
            statement.setLong(3, this.getMovieId());
            statement.setTimestamp(4, this.getStartsAt());
            statement.setTimestamp(5, this.getEndsAt());
            statement.setString(7, this.getStatus());
            statement.setLong(8, this.getId());
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
            String sql = "DELETE FROM showtime WHERE showtime_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

    public static List<Showtime> getAll() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return getAll(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public static List<Showtime> getAll(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Showtime> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM showtime ORDER BY showtime_id";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(new Showtime(
                        resultSet.getLong("showtime_id"),
                        resultSet.getLong("room_id"),
                        resultSet.getLong("movie_id"),
                        resultSet.getTimestamp("starts_at"),
                        resultSet.getTimestamp("ends_at"),
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
