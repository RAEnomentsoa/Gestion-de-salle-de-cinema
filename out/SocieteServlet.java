// ===============================
// FILE: src/main/java/servlet/SocieteServlet.java
// ===============================
package servlet;

import cinema.Societe;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/societe")
public class SocieteServlet extends HttpServlet {

    // Delete helper (redirects)
    protected void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        if ("delete".equals(req.getParameter("action"))) {
            long id = Long.parseLong(req.getParameter("id"));
            Societe s = new Societe();
            s.setId(id);
            s.delete();
            resp.sendRedirect("societe"); // response committed
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            delete(request, response);
            if (response.isCommitted())
                return; // ✅ IMPORTANT: stop after redirect

            request.setAttribute("activeMenuItem", "societe");
            request.setAttribute("pageTitle", "Sociétés");
            request.setAttribute("societes", Societe.getAll());

            RequestDispatcher dispatcher = request.getRequestDispatcher("societe.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erreur chargement sociétés", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            String action = request.getParameter("action");
            String num = request.getParameter("num");

            // prix: EMPTY -> NULL
            String prixStr = request.getParameter("prix");
            Double prix = null;
            if (prixStr != null && !prixStr.isBlank()) {
                prix = Double.parseDouble(prixStr);
            }

            long id = 0;
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isBlank()) {
                id = Long.parseLong(idStr);
            }

            Societe soc = new Societe(id, num, prix);

            if ("update".equals(action)) {
                soc.update();
            } else {
                soc.create();
            }

            response.sendRedirect("societe");

        } catch (Exception e) {
            throw new ServletException("Erreur sauvegarde société", e);
        }
    }
}
