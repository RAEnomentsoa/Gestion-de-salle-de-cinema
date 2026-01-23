package servlet;

import cinema.Pub;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/PubResteAPayerServlet")
public class PubResteAPayerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // 1. Récupération du paramètre showtime_id
            String showtimeParam = req.getParameter("showtime_id");

            if (showtimeParam == null || showtimeParam.isBlank()) {
                throw new ServletException("showtime_id manquant");
            }

            long showtimeId = Long.parseLong(showtimeParam);

            // 2. Charger les pubs de cette showtime
            List<Pub> pubs = Pub.getAllPubByIdShowtime(showtimeId);

            // 3. Envoyer les données à la JSP
            req.setAttribute("pubs", pubs);
            req.setAttribute("showtimeId", showtimeId);

            // 4. Redirection vers la JSP
            req.getRequestDispatcher("/pub-reste-a-payer.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(
                "Erreur chargement reste à payer par pub",
                e
            );
        }
    }
}
