package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

import cinema.Movie;

@WebServlet("/movie")
public class MovieServlet extends HttpServlet {

    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Movie m = new Movie();
            m.setId(id);
            m.delete();
            resp.sendRedirect("movie");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);
            request.setAttribute("activeMenuItem", "movie");
            request.setAttribute("pageTitle", "Films");
            request.setAttribute("movies", Movie.getAll());
            RequestDispatcher dispatcher = request.getRequestDispatcher("movie.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");
            long id = Long.parseLong(request.getParameter("id"));
            String title = request.getParameter("title");
            int durationMin = Integer.parseInt(request.getParameter("duration_min"));
            Date releaseDate = request.getParameter("release_date") == null
                    || request.getParameter("release_date").isEmpty()
                            ? null
                            : Date.valueOf(request.getParameter("release_date"));
            String ageRating = request.getParameter("age_rating");
            String status = request.getParameter("status");

            Movie movie = new Movie(id, title, durationMin, releaseDate, ageRating, status);

            if (action != null && action.equals("update")) {
                movie.update();
            } else {
                movie.create();
            }

            response.sendRedirect("movie");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
