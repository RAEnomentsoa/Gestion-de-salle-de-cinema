package cinema;

import dao.DBConnection;

import java.sql.*;

public class AppUser {
    long id;
    String username;
    String passwordHash;
    String fullName;
    String role;
    String status;

    public AppUser() {
    }

    public AppUser(long id) {
        setId(id);
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Authenticate: returns true if ok + fills user fields
    public boolean login(String username, String plainPassword) throws Exception {
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            return login(connection, username, plainPassword);
        } finally {
            if (connection != null)
                connection.close();
        }
    }

    public boolean login(Connection connection, String username, String plainPassword) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            String sql = "SELECT * FROM app_user " +
                    "WHERE username = ? AND password_hash = ? AND status = 'ACTIVE'";

            statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, plainPassword);

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                this.setId(resultSet.getLong("id"));
                this.setUsername(resultSet.getString("username"));
                this.setPasswordHash(resultSet.getString("password_hash"));
                this.setFullName(resultSet.getString("full_name"));
                this.setRole(resultSet.getString("role"));
                this.setStatus(resultSet.getString("status"));
                return true;
            }
            return false;
        } finally {
            if (resultSet != null)
                resultSet.close();
            if (statement != null)
                statement.close();
        }
    }
}
