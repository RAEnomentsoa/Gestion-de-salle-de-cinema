package servlet;

import cinema.Societe;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/societeForm")
public class SocieteFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        Societe soc = new Societe();

        if (action != null && action.equals("update")) {
            long id = Long.parseLong(req.getParameter("id"));
            soc.setId(id);
            try {
                soc.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("societe", soc);
        req.setAttribute("activeMenuItem", "societe");
        req.setAttribute("pageTitle", "Société");

        RequestDispatcher dispatcher = req.getRequestDispatcher("societe-form.jsp");
        dispatcher.forward(req, resp);
    }
}
