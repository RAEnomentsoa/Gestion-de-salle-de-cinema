package services;

import cinema.dto.ReservationReportRow;
import dao.DBConnection;

import java.sql.*;
import java.util.*;

public class ReservationService {

    // ===========================
    // Get Report
    // ===========================
    public static List<ReservationReportRow> getReport(Long roomId, Long movieId) throws Exception {

        String sql = "SELECT * FROM reservation_report_view "
                   + "WHERE (? IS NULL OR room_id = ?) "
                   + "AND (? IS NULL OR movie_id = ?) "
                   + "ORDER BY reservation_created_at DESC";

        List<ReservationReportRow> list = new ArrayList<>();

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            // Room filter
            if (roomId == null) { ps.setNull(1, Types.BIGINT); ps.setNull(2, Types.BIGINT); }
            else { ps.setLong(1, roomId); ps.setLong(2, roomId); }

            // Movie filter
            if (movieId == null) { ps.setNull(3, Types.BIGINT); ps.setNull(4, Types.BIGINT); }
            else { ps.setLong(3, movieId); ps.setLong(4, movieId); }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReservationReportRow row = new ReservationReportRow();

                    row.setReservationId(rs.getLong("reservation_id"));
                    row.setReservationStatus(rs.getString("reservation_status"));
                    row.setReservationCreatedAt(rs.getTimestamp("reservation_created_at"));

                    row.setTicketId(rs.getLong("ticket_id"));
                    row.setPrix(rs.getDouble("prix")); // déjà calculé dans la vue

                    row.setClientName(rs.getString("client_name"));
                    row.setCinemaName(rs.getString("cinema_name"));
                    row.setRoomName(rs.getString("room_name"));
                    row.setMovieTitle(rs.getString("movie_title"));
                    row.setStartsAt(rs.getTimestamp("starts_at"));

                    row.setSeatRow(rs.getString("seat_row"));
                    Object sn = rs.getObject("seat_number");
                    row.setSeatNumber(sn == null ? null : rs.getInt("seat_number"));

                    list.add(row);
                }
            }
        }
        return list;
    }

    // ===========================
    // Total revenue (paid only)
    // ===========================
    public static double getTotalRevenue(Long roomId, Long movieId) throws Exception {

        String sql = """
           SELECT COALESCE(SUM(
               CASE
                   WHEN cat.prix IS NOT NULL THEN 
                        ROUND(COALESCE(se_prix.prix, 0) * cat.prix / 100.0, 2)
                   ELSE
                        COALESCE(se_prix.prix, 0)
               END
           ), 0) AS total
           FROM reservation r
           JOIN client c ON r.client_id = c.client_id
           JOIN categorie cat ON c.id_categorie = cat.id
           JOIN ticket t ON r.ticket_id = t.ticket_id
           JOIN showtime s ON t.showtime_id = s.showtime_id
           JOIN room ro ON s.room_id = ro.room_id
           JOIN movie m ON s.movie_id = m.movie_id
           LEFT JOIN seat se ON t.seat_id = se.seat_id
           LEFT JOIN tarif se_prix ON se.seat_type = se_prix.id
           WHERE r.status = 'PAYER'
             AND (? IS NULL OR ro.room_id = ?)
             AND (? IS NULL OR m.movie_id = ?)
        """;

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            // Room filter
            if (roomId == null) { ps.setNull(1, Types.BIGINT); ps.setNull(2, Types.BIGINT); }
            else { ps.setLong(1, roomId); ps.setLong(2, roomId); }

            // Movie filter
            if (movieId == null) { ps.setNull(3, Types.BIGINT); ps.setNull(4, Types.BIGINT); }
            else { ps.setLong(3, movieId); ps.setLong(4, movieId); }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("total");
                return 0.0;
            }
        }
    }

}
