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
                       COALESCE(SUM(
                           CASE
                               -- Only count tickets that have a PAID reservation
                               WHEN r.status IS NULL THEN 0
                               ELSE
                                   CASE
                                       WHEN ctp.pricing_type = 'FIXED' THEN ctp.fixed_price
                                       WHEN ctp.pricing_type = 'PERCENT' THEN ROUND(COALESCE(tr.prix, 0) * (ctp.percent_rate / 100.0), 2)
                                       ELSE COALESCE(tr.prix, 0)
                                   END
                           END
                       ), 0) AS ticket_revenue
                FROM showtime s
                JOIN movie m ON m.movie_id = s.movie_id

                LEFT JOIN ticket t ON t.showtime_id = s.showtime_id
                LEFT JOIN reservation r ON r.ticket_id = t.ticket_id
                     AND r.status = 'PAYER'
                LEFT JOIN client c ON r.client_id = c.client_id
                LEFT JOIN categorie cat ON c.id_categorie = cat.id

                LEFT JOIN seat st ON t.seat_id = st.seat_id
                LEFT JOIN tarif tr ON st.seat_type = tr.id
                LEFT JOIN categorie_tarif_pricing ctp
                    ON ctp.categorie_id = cat.id
                   AND ctp.tarif_id = tr.id

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
