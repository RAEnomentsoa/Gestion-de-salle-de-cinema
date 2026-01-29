package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

import cinema.Showtime;

@WebServlet("/showtime")
public class ShowtimeServlet extends HttpServlet {

    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Showtime s = new Showtime();
            s.setId(id);
            s.delete();
            resp.sendRedirect("showtime");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);
            request.setAttribute("activeMenuItem", "showtime");
            request.setAttribute("pageTitle", "Séances");
            request.setAttribute("showtimes", Showtime.getAll());
            RequestDispatcher dispatcher = request.getRequestDispatcher("showtime.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
        String action = request.getParameter("action");
       // long id = Long.parseLong(request.getParameter("id"));
        long roomId = Long.parseLong(request.getParameter("room_id"));
        long movieId = Long.parseLong(request.getParameter("movie_id"));
        Timestamp startsAt = Timestamp.valueOf(request.getParameter("starts_at"));
        Timestamp endsAt = Timestamp.valueOf(request.getParameter("ends_at"));
        String status = request.getParameter("status");

        Showtime showtime = new Showtime(roomId, movieId, startsAt, endsAt, status);

        if ("update".equals(action)) {
            showtime.update();
        } else {
            showtime.create();
        }

        response.sendRedirect("showtime");
        return;

    } catch (Exception e) {
        e.printStackTrace();

        // IMPORTANT: respond with an error (or redirect), but DO NOT try to forward after output
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        return;
    }
}

}
