package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import cinema.Room;

@WebServlet("/room")
public class RoomServlet extends HttpServlet {

    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if (req.getParameter("action") != null && req.getParameter("action").equals("delete")) {
            long id = Long.parseLong(req.getParameter("id"));
            Room r = new Room();
            r.setId(id);
            r.delete();
            resp.sendRedirect("room");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response);
            request.setAttribute("activeMenuItem", "room");
            request.setAttribute("pageTitle", "Salles");
            request.setAttribute("rooms", Room.getAll());
            RequestDispatcher dispatcher = request.getRequestDispatcher("room.jsp");
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
            long cinemaId = Long.parseLong(request.getParameter("cinema_id"));
            String name = request.getParameter("name");
            long capacity = Long.parseLong(request.getParameter("capacity"));
            String status = request.getParameter("status");

            Room room = new Room(id, cinemaId, name, capacity, status);

            if (action != null && action.equals("update")) {
                room.update();
            } else {
                room.create();
            }

            response.sendRedirect("room");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
