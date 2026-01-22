package servlet;

import cinema.Pub;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/pub")
public class PubServlet extends HttpServlet {

    // =========================
    // DELETE
    // =========================
    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Pub p = new Pub();
            p.setId(id);
            p.delete();
            resp.sendRedirect("pub");
        }
    }

    // =========================
    // LIST PAGE
    // =========================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);

            request.setAttribute("activeMenuItem", "pub");
            request.setAttribute("pageTitle", "Pubs");
            request.setAttribute("pubs", Pub.getAll()); // List all pubs

            RequestDispatcher dispatcher = request.getRequestDispatcher("pub.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // CREATE / UPDATE
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");

            long id = 0;
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isBlank()) {
                id = Long.parseLong(idStr);
            }

            long showtimeId = Long.parseLong(request.getParameter("showtime_id"));
            long societeId = Long.parseLong(request.getParameter("id_societe"));
            long prixId = Long.parseLong(request.getParameter("id_prix"));

            // Expect input type="datetime-local" => "yyyy-MM-ddTHH:mm"
            String datesStr = request.getParameter("dates");
            Timestamp dates = parseDatetimeLocalToTimestamp(datesStr);

            Pub pub = new Pub(id, showtimeId, societeId, dates, prixId);

            if (action != null && action.equals("update")) {
                pub.update();
            } else {
                pub.create();
            }

            response.sendRedirect("pub");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================
    // Utils
    // =========================
    private Timestamp parseDatetimeLocalToTimestamp(String value) {
        if (value == null || value.isBlank())
            return null;

        // datetime-local: 2026-01-22T14:30
        String v = value.replace("T", " ");

        // add seconds if missing
        if (v.length() == 16)
            v = v + ":00";

        return Timestamp.valueOf(v);
    }
}
