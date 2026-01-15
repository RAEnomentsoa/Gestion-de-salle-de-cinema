package servlet;

import java.io.IOException;

import cinema.Showtime;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/showtimeForm")
public class ShowtimeFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Showtime showtime = new Showtime();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            showtime.setId(id);
            try {
                showtime.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("showtime", showtime);
        req.setAttribute("activeMenuItem", "showtime");
        req.setAttribute("pageTitle", "Séance");

        RequestDispatcher dispatcher = req.getRequestDispatcher("showtime-form.jsp");
        dispatcher.forward(req, resp);
    }
}

