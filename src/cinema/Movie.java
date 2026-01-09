package cinema;

import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Movie {
    long id; // movie_id
    String title;
    int durationMin;
    Date releaseDate; // nullable
    String ageRating; // nullable
    String status; // ACTIVE/ARCHIVED

    public Movie() {
    }

    public Movie(long id) {
        setId(id);
    }

    public Movie(long id, String title, int durationMin, Date releaseDate, String ageRating, String status) {
        setId(id);
        setTitle(title);
        setDurationMin(durationMin);
        setReleaseDate(releaseDate);
        setAgeRating(ageRating);
        setStatus(status);
    }

    public Movie(String title, int durationMin, Date releaseDate, String ageRating, String status) {
        setTitle(title);
        setDurationMin(durationMin);
        setReleaseDate(releaseDate);
        setAgeRating(ageRating);
        setStatus(status);
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getDurationMin() {
        return durationMin;
    }

    public void setDurationMin(int durationMin) {
        this.durationMin = durationMin;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(String ageRating) {
        this.ageRating = ageRating;
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
            String sql = "INSERT INTO movie (title, duration_min, release_date, age_rating, status) VALUES (?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, this.getTitle());
            statement.setInt(2, this.getDurationMin());
            statement.setDate(3, this.getReleaseDate()); // can be null
            statement.setString(4, this.getAgeRating()); // can be null
            statement.setString(5, (this.getStatus() == null) ? "ACTIVE" : this.getStatus());
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
            String sql = "SELECT * FROM movie WHERE movie_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                this.setTitle(resultSet.getString("title"));
                this.setDurationMin(resultSet.getInt("duration_min"));
                this.setReleaseDate(resultSet.getDate("release_date"));
                this.setAgeRating(resultSet.getString("age_rating"));
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
            String sql = "UPDATE movie SET title = ?, duration_min = ?, release_date = ?, age_rating = ?, status = ? WHERE movie_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, this.getTitle());
            statement.setInt(2, this.getDurationMin());
            statement.setDate(3, this.getReleaseDate());
            statement.setString(4, this.getAgeRating());
            statement.setString(5, this.getStatus());
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
            String sql = "DELETE FROM movie WHERE movie_id = ?";
            statement = connection.prepareStatement(sql);
            statement.setLong(1, this.getId());
            statement.executeUpdate();
        } finally {
            if (statement != null)
                statement.close();
        }
    }

    public static List<Movie> getAll() throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return getAll(connection);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public static List<Movie> getAll(Connection connection) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Movie> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM movie ORDER BY movie_id";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(new Movie(
                        resultSet.getLong("movie_id"),
                        resultSet.getString("title"),
                        resultSet.getInt("duration_min"),
                        resultSet.getDate("release_date"),
                        resultSet.getString("age_rating"),
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
