package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import cinema.Ticket;

@WebServlet("/ticket")
public class TicketServlet extends HttpServlet {

    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Ticket t = new Ticket();
            t.setTicketId(id);
            t.delete();
            resp.sendRedirect("ticket");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);
            request.setAttribute("activeMenuItem", "ticket");
            request.setAttribute("pageTitle", "Tickets");
            request.setAttribute("tickets", Ticket.getAll());

            RequestDispatcher dispatcher = request.getRequestDispatcher("ticket.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");

            long ticketId = Long.parseLong(request.getParameter("ticketId")); // hidden input
            long showtimeId = Long.parseLong(request.getParameter("showtimeId")); // select/input
            String seatIdStr = request.getParameter("seatId"); // can be empty
            double prix = Double.parseDouble(request.getParameter("prix"));

            Long seatId = null;
            if (seatIdStr != null && !seatIdStr.trim().isEmpty()) {
                seatId = Long.parseLong(seatIdStr);
            }

            Ticket ticket = new Ticket(ticketId, showtimeId, seatId, prix);

            if (action != null && action.equals("update")) {
                ticket.update();
            } else {
                ticket.create();
            }

            response.sendRedirect("ticket");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
