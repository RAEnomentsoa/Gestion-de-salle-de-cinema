package servlet;

import cinema.ShowtimeRevenueRow;
import services.ShowtimeRevenueService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/ShowtimeRevenueReportServlet")
public class ShowtimeRevenueReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<ShowtimeRevenueRow> rows = ShowtimeRevenueService.getReport();
            req.setAttribute("rows", rows);

            double total = rows.stream()
                    .mapToDouble(ShowtimeRevenueRow::getTotalRevenue)
                    .sum();
            req.setAttribute("totalRevenue", total);

            req.getRequestDispatcher("/showtime-revenue-report.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Erreur chargement rapport CA par showtime", e);
        }
    }
}
