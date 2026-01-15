package services;

import cinema.dto.ReservationReportRow;
import dao.DBConnection;

import java.sql.*;
import java.util.*;

public class ReservationService {

    public static List<ReservationReportRow> getReport(Long roomId, Long movieId) throws Exception {

        String sql = """
            SELECT
                r.reservation_id,
                r.status AS reservation_status,
                r.created_at AS reservation_created_at,

                t.ticket_id,
                t.prix,

                c.nom AS client_name,

                ci.name AS cinema_name,
                ro.name AS room_name,

                m.title AS movie_title,

                s.starts_at,

                se.row_label AS seat_row,
                se.seat_number AS seat_number

            FROM reservation r
            JOIN ticket t       ON r.ticket_id = t.ticket_id
            JOIN showtime s     ON t.showtime_id = s.showtime_id
            JOIN movie m        ON s.movie_id = m.movie_id
            JOIN room ro        ON s.room_id = ro.room_id
            JOIN cinema ci      ON ro.cinema_id = ci.cinema_id
            JOIN client c       ON r.client_id = c.client_id
            LEFT JOIN seat se   ON t.seat_id = se.seat_id

            WHERE ( ? IS NULL OR ro.room_id = ? )
              AND ( ? IS NULL OR m.movie_id = ? )

            ORDER BY r.created_at DESC, r.reservation_id DESC
        """;

        List<ReservationReportRow> list = new ArrayList<>();

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            // room filter
            if (roomId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, roomId);
            if (roomId == null) ps.setNull(2, Types.BIGINT);
            else ps.setLong(2, roomId);

            // movie filter
            if (movieId == null) ps.setNull(3, Types.BIGINT);
            else ps.setLong(3, movieId);
            if (movieId == null) ps.setNull(4, Types.BIGINT);
            else ps.setLong(4, movieId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReservationReportRow row = new ReservationReportRow();
                    row.setReservationId(rs.getLong("reservation_id"));
                    row.setReservationStatus(rs.getString("reservation_status"));
                    row.setReservationCreatedAt(rs.getTimestamp("reservation_created_at"));

                    row.setTicketId(rs.getLong("ticket_id"));
                    row.setPrix(rs.getDouble("prix"));

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

    // Total chiffre d'affaire (I assume only PAYER counts)
    public static double getTotalRevenue(Long roomId, Long movieId) throws Exception {
        String sql = """
            SELECT COALESCE(SUM(t.prix), 0) AS total
            FROM reservation r
            JOIN ticket t   ON r.ticket_id = t.ticket_id
            JOIN showtime s ON t.showtime_id = s.showtime_id
            JOIN movie m    ON s.movie_id = m.movie_id
            JOIN room ro    ON s.room_id = ro.room_id
            WHERE r.status = 'PAYER'
              AND ( ? IS NULL OR ro.room_id = ? )
              AND ( ? IS NULL OR m.movie_id = ? )
        """;

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            if (roomId == null) ps.setNull(1, Types.BIGINT); else ps.setLong(1, roomId);
            if (roomId == null) ps.setNull(2, Types.BIGINT); else ps.setLong(2, roomId);

            if (movieId == null) ps.setNull(3, Types.BIGINT); else ps.setLong(3, movieId);
            if (movieId == null) ps.setNull(4, Types.BIGINT); else ps.setLong(4, movieId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("total");
                return 0.0;
            }
        }
    }
}
