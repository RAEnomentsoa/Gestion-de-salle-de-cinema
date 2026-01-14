package servlet;

import java.io.IOException;

import cinema.Ticket;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ticketForm")
public class TicketFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Ticket ticket = new Ticket();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            ticket.setTicketId(id);
            try {
                ticket.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("ticket", ticket);
        req.setAttribute("activeMenuItem", "ticket");
        req.setAttribute("pageTitle", "Ticket");

        RequestDispatcher dispatcher = req.getRequestDispatcher("ticket-form.jsp");
        dispatcher.forward(req, resp);
    }
}
