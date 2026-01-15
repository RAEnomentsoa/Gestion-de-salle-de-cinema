package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import cinema.Seat;

@WebServlet("/seat")
public class SeatServlet extends HttpServlet {

    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Seat s = new Seat();
            s.setId(id);
            s.delete();
            resp.sendRedirect("seat");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);
            request.setAttribute("activeMenuItem", "seat");
            request.setAttribute("pageTitle", "Sièges");
            request.setAttribute("seats", Seat.getAll());
            RequestDispatcher dispatcher = request.getRequestDispatcher("seat.jsp");
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
            long roomId = Long.parseLong(request.getParameter("room_id"));
            String rowLabel = request.getParameter("row_label");
            int seatNumber = Integer.parseInt(request.getParameter("seat_number"));
            int seatType = Integer.parseInt(request.getParameter("seat_type"));
            boolean isActive = request.getParameter("is_active") != null;

            Seat seat = new Seat(id, roomId, rowLabel, seatNumber, seatType, isActive);

            if (action != null && action.equals("update")) {
                seat.update();
            } else {
                seat.create();
            }

            response.sendRedirect("seat");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
