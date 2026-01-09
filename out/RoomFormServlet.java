package servlet;

import java.io.IOException;

import cinema.Room;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/roomForm")
public class RoomFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Room room = new Room();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            room.setId(id);
            try {
                room.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("room", room);
        req.setAttribute("activeMenuItem", "room");
        req.setAttribute("pageTitle", "Salle");

        RequestDispatcher dispatcher = req.getRequestDispatcher("room-form.jsp");
        dispatcher.forward(req, resp);
    }
}
