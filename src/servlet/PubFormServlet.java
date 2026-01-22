package servlet;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import cinema.Pub;
import cinema.Showtime;
// If you have these models:
import cinema.Societe; // <-- adapt package/class name
import cinema.PubTarif; // <-- adapt package/class name

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;

@WebServlet("/pubForm")
public class PubFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        Pub pub = new Pub();

        // 1) Update mode: load Pub by id
        if ("update".equalsIgnoreCase(action)) {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isBlank()) {
                throw new ServletException("Missing id for update action");
            }

            try {
                long id = Long.parseLong(idStr);
                pub.setId(id);
                pub.getById();
            } catch (Exception e) {
                throw new ServletException("Error loading Pub by id", e);
            }
        } else {
            action = "create";
        }

        // 2) Load dropdown data (showtimes, societes, tarifs)
        try {
            // Adapt these calls to your real methods
            List<Showtime> showtimes = Showtime.getAll(); // if exists
            req.setAttribute("showtimes", showtimes);
        } catch (Exception e) {
            // not fatal for form rendering
            req.setAttribute("showtimes", Collections.emptyList());
        }

        try {
            List<Societe> societes = Societe.getAll(); // if exists
            req.setAttribute("societes", societes);
        } catch (Exception e) {
            req.setAttribute("societes", Collections.emptyList());
        }

        try {
            List<PubTarif> pubTarifs = PubTarif.getAll(); // if exists
            req.setAttribute("pubTarifs", pubTarifs);
        } catch (Exception e) {
            req.setAttribute("pubTarifs", Collections.emptyList());
        }

        // 3) Send to JSP
        req.setAttribute("action", action);
        req.setAttribute("pub", pub);

        // UI
        req.setAttribute("activeMenuItem", "pub");
        req.setAttribute("pageTitle", "Pub");

        RequestDispatcher dispatcher = req.getRequestDispatcher("pub-form.jsp");
        dispatcher.forward(req, resp);
    }

    // Optional: handle submit (create/update)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        Pub pub = new Pub();

        try {
            // read fields from form
            long showtimeId = Long.parseLong(req.getParameter("showtime_id"));
            long societeId = Long.parseLong(req.getParameter("id_societe"));
            long prixId = Long.parseLong(req.getParameter("id_prix"));

            // dates can be passed as datetime-local: "2026-01-22T14:30"
            String datesStr = req.getParameter("dates");
            Timestamp dates = Timestamp.valueOf(datesStr.replace("T", " ") + ":00");

            pub.setShowtime_id(showtimeId);
            pub.setId_societe(societeId);
            pub.setId_prix(prixId);
            pub.setDates(dates);

            if ("update".equalsIgnoreCase(action)) {
                long id = Long.parseLong(req.getParameter("id"));
                pub.setId(id);
                pub.update();
            } else {
                pub.create();
            }

            // redirect to list page (change to your route)
            resp.sendRedirect("pub");
        } catch (Exception e) {
            throw new ServletException("Error saving Pub", e);
        }
    }
}
