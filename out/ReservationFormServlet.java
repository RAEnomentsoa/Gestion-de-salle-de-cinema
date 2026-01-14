package servlet;

import java.io.IOException;

import cinema.Reservation;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reservationForm")
public class ReservationFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Reservation reservation = new Reservation();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            reservation.setReservationId(id);
            try {
                reservation.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("reservation", reservation);
        req.setAttribute("activeMenuItem", "reservation");
        req.setAttribute("pageTitle", "Réservation");

        RequestDispatcher dispatcher = req.getRequestDispatcher("reservation-form.jsp");
        dispatcher.forward(req, resp);
    }
}