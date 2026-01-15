package servlet;

import cinema.Movie;
import cinema.Room;
import services.ReservationService;
import services.ReservationService;
import cinema.dto.ReservationReportRow;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/reservationReport")
public class ReservationReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            // Filters
            Long roomId = parseLongOrNull(req.getParameter("roomId"));
            Long movieId = parseLongOrNull(req.getParameter("movieId"));

            // Dropdown data
            req.setAttribute("rooms", Room.getAll());
            req.setAttribute("movies", Movie.getAll());

            // Report rows
            List<ReservationReportRow> rows = ReservationService.getReport(roomId, movieId);
            req.setAttribute("rows", rows);

            // Total revenue (paid only)
            double total = ReservationService.getTotalRevenue(roomId, movieId);
            req.setAttribute("totalRevenue", total);

            // Selected
            req.setAttribute("selectedRoomId", roomId);
            req.setAttribute("selectedMovieId", movieId);
            req.setAttribute("activeMenuItem", "reservationReport");

            req.getRequestDispatcher("/reservation-report.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading reservation report", e);
        }
    }

    private Long parseLongOrNull(String s) {
        if (s == null || s.isBlank())
            return null;
        return Long.parseLong(s);
    }
}
