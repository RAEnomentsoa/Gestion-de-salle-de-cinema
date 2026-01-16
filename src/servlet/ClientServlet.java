package servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import cinema.Client;

@WebServlet("/client")
public class ClientServlet extends HttpServlet {

    // Méthode pour gérer la suppression
    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if ("delete".equals(req.getParameter("action"))) {
            long id = Long.parseLong(req.getParameter("id"));
            Client client = new Client();
            client.setId(id);
            client.delete();
            resp.sendRedirect("client");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            delete(request, response); // Gestion suppression si nécessaire

            // Charger la liste des clients
            request.setAttribute("activeMenuItem", "client");
            request.setAttribute("pageTitle", "Clients");
            request.setAttribute("clients", Client.getAll()); // Méthode getAll() dans Client.java

            RequestDispatcher dispatcher = request.getRequestDispatcher("client.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");
            String nom = request.getParameter("nom");
            String address = request.getParameter("address");
            String ageParam = request.getParameter("age");
            String CategorieParam = request.getParameter("id_categorie");

            long id = 0;
            if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                id = Long.parseLong(request.getParameter("id"));
            }

            Client client = new Client();
            client.setNom(nom);
            client.setAddress(address);
            if (ageParam != null && !ageParam.isEmpty()) {
                client.setAge(Integer.parseInt(ageParam));
            }
            client.setId(id);
            client.setId_categorie(Integer.parseInt(CategorieParam));

            if ("update".equals(action)) {
                client.update();
            } else {
                client.create();
            }

            response.sendRedirect("client");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
