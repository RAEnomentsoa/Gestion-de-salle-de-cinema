package servlet;

import java.io.IOException;

import cinema.Client;  // Assure-toi que tu as créé la classe Client avec getById(), create(), update()
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/clientForm")
public class ClientFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Client client = new Client();

        if (action != null && action.equals("update")) {
            // Si action = update, on récupère l'id et on charge le client
            long id = Long.parseLong(req.getParameter("id"));
            client.setId(id);
            try {
                client.getById();
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } else {
            // Sinon, action = create
            action = "create";
        }

        req.setAttribute("action", action);
        req.setAttribute("client", client);
        req.setAttribute("activeMenuItem", "client");
        req.setAttribute("pageTitle", "Client");

        RequestDispatcher dispatcher = req.getRequestDispatcher("client-form.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Client client = new Client();

        client.setNom(req.getParameter("nom"));
        client.setAddress(req.getParameter("address"));

        String ageParam = req.getParameter("age");
        if (ageParam != null && !ageParam.isEmpty()) {
            client.setAge(Integer.parseInt(ageParam));
        }

        try {
            if ("update".equals(action)) {
                long id = Long.parseLong(req.getParameter("id"));
                client.setId(id);
                client.update();
            } else {
                client.create();
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        // Après l'ajout/mise à jour, redirection vers la liste des clients
        resp.sendRedirect("client");
    }
}
