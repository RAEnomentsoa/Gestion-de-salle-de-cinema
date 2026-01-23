package services;

import cinema.Pub;
import cinema.ShowtimeRevenueRow;
import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShowtimeRevenueService {

    public static List<ShowtimeRevenueRow> getReport() throws Exception {
        List<ShowtimeRevenueRow> list = new ArrayList<>();

        String sql = """
            SELECT s.showtime_id, s.starts_at, m.title,
                   COALESCE(SUM(t.prix), 0) AS ticket_revenue
            FROM showtime s
            JOIN movie m ON m.movie_id = s.movie_id
            LEFT JOIN ticket t ON t.showtime_id = s.showtime_id
            LEFT JOIN reservation r ON r.ticket_id = t.ticket_id
                 AND r.status = 'PAYER'
            GROUP BY s.showtime_id, s.starts_at, m.title
            ORDER BY s.starts_at
        """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ShowtimeRevenueRow row = new ShowtimeRevenueRow();
                long showtimeId = rs.getLong("showtime_id");

                row.setShowtimeId(showtimeId);
                row.setMovieTitle(rs.getString("title"));
                row.setStartsAt(rs.getTimestamp("starts_at"));

                double ticketRevenue = rs.getDouble("ticket_revenue");
                double pubRevenue = Pub.getTotalChiffreAffairePub(showtimeId, null, null);

                row.setTicketRevenue(ticketRevenue);
                row.setPubRevenue(pubRevenue);
                row.setTotalRevenue(ticketRevenue + pubRevenue);

                list.add(row);
            }
        }
        return list;
    }
}
