package servlet;

import java.io.IOException;

import cinema.Movie;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/movieForm")
public class MovieFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Movie movie = new Movie();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            movie.setId(id);
            try {
                movie.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("movie", movie);
        req.setAttribute("activeMenuItem", "movie");
        req.setAttribute("pageTitle", "Film");

        RequestDispatcher dispatcher = req.getRequestDispatcher("movie-form.jsp");
        dispatcher.forward(req, resp);
    }
}
