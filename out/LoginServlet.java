package servlet;

import cinema.AppUser;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

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

            if (ok) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
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
