package servlet;

import java.io.IOException;

import cinema.Seat;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/seatForm")
public class SeatFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Seat seat = new Seat();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            seat.setId(id);
            try {
                seat.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("seat", seat);
        req.setAttribute("activeMenuItem", "seat");
        req.setAttribute("pageTitle", "Siège");

        RequestDispatcher dispatcher = req.getRequestDispatcher("seat-form.jsp");
        dispatcher.forward(req, resp);
    }
}
