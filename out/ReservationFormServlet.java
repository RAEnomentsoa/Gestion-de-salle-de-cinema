package servlet;

import java.io.IOException;
import java.util.List;

import cinema.Reservation;
import cinema.Room;
import cinema.Ticket;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import cinema.Showtime;
import cinema.Movie;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/reservationForm")
public class ReservationFormServlet extends HttpServlet {

@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String action = req.getParameter("action");
    Reservation reservation = new Reservation();

    try {
        // Rooms list (for filter)
        List<Room> rooms = Room.getAll();
        req.setAttribute("rooms", rooms);

        // --- Filter param ---
        String roomIdParam = req.getParameter("roomId");
        Long selectedRoomId = null;

        List<Ticket> tickets;
        if (roomIdParam != null && !roomIdParam.isBlank()) {
            selectedRoomId = Long.parseLong(roomIdParam);
            tickets = Ticket.getByRoomId(selectedRoomId); // ✅ your function
        } else {
            tickets = Ticket.getAll(); // fallback
        }

        req.setAttribute("tickets", tickets);
        req.setAttribute("selectedRoomId", selectedRoomId);

        // --- Build labels for tickets (so JSP does NOT call DB) ---
        Map<Long, String> ticketLabels = new HashMap<>();

        for (Ticket t : tickets) {
            Showtime s = new Showtime();
            s.setId(t.getShowtimeId());
            s.getById();

            Movie m = new Movie();
            m.setId(s.getMovieId());
            m.getById();

            Room r = new Room();
            r.setId(s.getRoomId());
            r.getById();

            String label = m.getTitle() + " - " + s.getStartsAt() + " - Room: " + r.getName();
            ticketLabels.put(t.getTicketId(), label);
        }

        req.setAttribute("ticketLabels", ticketLabels);

        // update / create
        if ("update".equals(action)) {
            long id = Long.parseLong(req.getParameter("id"));
            reservation.setReservationId(id);
            reservation.getById();
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("reservation", reservation);
         req.setAttribute("activeMenuItem", "reservation");
        req.setAttribute("pageTitle", "Réservation");
        
        RequestDispatcher rd = req.getRequestDispatcher("/reservation-form.jsp");
        rd.forward(req, resp);

    } catch (Exception e) {
        throw new ServletException("Error processing reservation form", e);
    }
}

}