package cinema.servlet;

import cinema.Seat;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// @WebServlet(name = "RoomRevenueServlet", urlPatterns = {"/roomRevenue"})
@WebServlet("/roomRevenue")
public class RoomRevenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdParam = request.getParameter("room_id");
        if (roomIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Paramètre room_id manquant");
            return;
        }

        long roomId = 1;
        try {
            roomId = Long.parseLong(roomIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Paramètre room_id invalide");
            return;
        }

        try {
            // Récupération du revenu maximal
            double maxRevenue = Seat.getSumPrixSeatByRoomId(roomId);

            // Récupération de la liste des sièges actifs
            List<Seat> seatList = Seat.getSeatsByRoomId(roomId);

            // Transmettre les données au JSP
            request.setAttribute("roomId", roomId);
            request.setAttribute("maxRevenue", maxRevenue);
            request.setAttribute("seatList", seatList);
            request.setAttribute("activeMenuItem", "roomRevenue");

            // Redirection vers le JSP
            request.getRequestDispatcher("roomRevenue.jsp").forward(request, response);

        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur SQL : " + ex.getMessage());
        }
    }

    // Optionnel : gérer POST si besoin
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
