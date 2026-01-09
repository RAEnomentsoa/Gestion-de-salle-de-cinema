package servlet;

import java.io.IOException;

import cinema.Cinema;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cinemaForm")
public class CinemaFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Cinema cinema = new Cinema();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            cinema.setId(id);
            try {
                cinema.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("cinema", cinema);
        req.setAttribute("activeMenuItem", "cinema");
        req.setAttribute("pageTitle", "Cinéma");

        RequestDispatcher dispatcher = req.getRequestDispatcher("cinema-form.jsp");
        dispatcher.forward(req, resp);
    }
}
