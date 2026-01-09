package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import cinema.Cinema;

@WebServlet("/cinema")
public class CinemaServlet extends HttpServlet {

    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Cinema c = new Cinema();
            c.setId(id);
            c.delete();
            resp.sendRedirect("cinema");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);
            request.setAttribute("activeMenuItem", "cinema");
            request.setAttribute("pageTitle", "Cinémas");
            request.setAttribute("cinemas", Cinema.getAll());
            RequestDispatcher dispatcher = request.getRequestDispatcher("cinema.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String status = request.getParameter("status");
            long id = Long.parseLong(request.getParameter("id"));

            Cinema cinema = new Cinema(id, name, address, city, status);

            if (action != null && action.equals("update")) {
                cinema.update();
            } else {
                cinema.create();
            }

            response.sendRedirect("cinema");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
