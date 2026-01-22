package servlet;

import cinema.Pub;
import cinema.Showtime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/pubRevenueReport")
public class PubRevenueReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // ----------------------
            // 1. Récupérer filtres
            // ----------------------
            Long selectedShowtimeId = null;
            String showtimeIdParam = req.getParameter("showtimeId");
            if (showtimeIdParam != null && !showtimeIdParam.isBlank()) {
                try {
                    selectedShowtimeId = Long.parseLong(showtimeIdParam);
                } catch (NumberFormatException e) {
                    selectedShowtimeId = null;
                }
            }

            Integer year = null;
            Integer month = null;
            String monthParam = req.getParameter("month"); // format attendu : "YYYY-MM"
            if (monthParam != null && !monthParam.isBlank()) {
                String[] yearMonth = monthParam.split("-");
                if (yearMonth.length == 2) {
                    try {
                        year = Integer.parseInt(yearMonth[0]);
                        month = Integer.parseInt(yearMonth[1]);
                    } catch (NumberFormatException e) {
                        year = null;
                        month = null;
                    }
                }
            }

            // ----------------------
            // 2. Récupérer données showtime pour la liste déroulante
            // ----------------------
            List<Showtime> showtimes = Showtime.getAll();
            req.setAttribute("showtimes", showtimes);
            req.setAttribute("selectedShowtimeId", selectedShowtimeId);
            req.setAttribute("selectedMonth", monthParam);

            // ----------------------
            // 3. Calcul du chiffre d'affaire total
            // ----------------------
            double totalCA = Pub.getTotalChiffreAffairePub(selectedShowtimeId, year, month);
            req.setAttribute("totalCA", totalCA);

            // ----------------------
            // 4. Forward vers JSP
            // ----------------------
            req.getRequestDispatcher("/pub-revenue-report.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace(); // pour debug
            throw new ServletException("Erreur chargement rapport chiffre affaire pub", e);
        }
    }
}
