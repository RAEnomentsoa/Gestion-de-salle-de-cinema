package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import cinema.Reservation;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {

    // ---------------------------
    // DELETE
    // ---------------------------
    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Reservation r = new Reservation();
            r.setReservationId(id);
            r.delete();
            resp.sendRedirect("reservation");
        }
    }

    // ---------------------------
    // GET
    // ---------------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);
            request.setAttribute("activeMenuItem", "reservation");
            request.setAttribute("pageTitle", "Réservations");
            request.setAttribute("reservations", Reservation.getAll());
            RequestDispatcher dispatcher = request.getRequestDispatcher("reservation.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ---------------------------
    // POST (Create / Update)
    // ---------------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");
            long id = Long.parseLong(request.getParameter("id"));
            long ticketId = Long.parseLong(request.getParameter("ticketId"));
            long clientId = Long.parseLong(request.getParameter("clientId"));
            String status = request.getParameter("status");

            Reservation reservation = new Reservation(id, ticketId, clientId, status);

            if (action != null && action.equals("update")) {
                reservation.update();
            } else {
                reservation.create();
            }

            response.sendRedirect("reservation");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}