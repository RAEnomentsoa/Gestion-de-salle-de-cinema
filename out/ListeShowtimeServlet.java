package servlet;

import cinema.Showtime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/ListeShowtimeServlet")
public class ListeShowtimeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // Récupérer tous les showtimes
            List<Showtime> showtimes = Showtime.getAll();

            // Envoyer vers le JSP
            req.setAttribute("showtimes", showtimes);

            req.getRequestDispatcher("/liste_showtime.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(
                "Erreur chargement liste showtime",
                e
            );
        }
    }
}
