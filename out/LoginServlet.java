package servlet;

import cinema.AppUser;
import cinema.Room;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher dispatcher = req.getRequestDispatcher("login.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            AppUser user = new AppUser();
            boolean ok = user.login(username, password);

            List<Room> rooms = Room.getAll();

            if (ok) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("Vertical_menu_rooms", rooms);
                resp.sendRedirect("movie"); // default after login
            } else {
                req.setAttribute("error", "Identifiants incorrects.");
                RequestDispatcher dispatcher = req.getRequestDispatcher("login.jsp");
                dispatcher.forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
