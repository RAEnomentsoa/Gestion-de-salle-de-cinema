package servlet;

import cinema.Paiement;
import cinema.Societe;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/PaiementFormServlet")
public class PaiementFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Charger toutes les sociétés pour la liste déroulante
            List<Societe> societes = Societe.getAll();
            req.setAttribute("societes", societes);

            req.getRequestDispatcher("/paiement-form.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Erreur chargement formulaire paiement", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            long id_societe = Long.parseLong(req.getParameter("id_societe"));
            double montant  = Double.parseDouble(req.getParameter("montant"));
            String dateStr  = req.getParameter("date");

            java.sql.Timestamp date = java.sql.Timestamp.valueOf(dateStr.replace("T", " ") + ":00");

            // Création du paiement
            Paiement paiement = new Paiement(id_societe, montant, date);
            paiement.create();

            // Redirection après ajout
            resp.sendRedirect("paiement-list.jsp"); // page listant tous les paiements
        } catch (Exception e) {
            throw new ServletException("Erreur insertion paiement", e);
        }
    }
}
