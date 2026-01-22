package servlet;

import cinema.Pub;
import dao.DBConnection;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/pubReste")
public class PubResteServlet extends HttpServlet {

    // Small DTO for display
    public static class SocieteResteRow {
        private long id;
        private String nom;
        private double reste;

        public SocieteResteRow(long id, String nom, double reste) {
            this.id = id;
            this.nom = nom;
            this.reste = reste;
        }

        public long getId() {
            return id;
        }

        public String getNom() {
            return nom;
        }

        public double getReste() {
            return reste;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Long selectedSocieteId = null;
        String sid = req.getParameter("societeId");
        if (sid != null && !sid.isBlank()) {
            try {
                selectedSocieteId = Long.parseLong(sid);
            } catch (Exception ignored) {
            }
        }

        try (Connection cn = DBConnection.getConnection()) {

            // 1) Load societes list for dropdown
            List<long[]> societes = new ArrayList<>();
            List<String> societesNames = new ArrayList<>();

            String sqlSoc = "SELECT id, num FROM societe ORDER BY num";
            try (PreparedStatement ps = cn.prepareStatement(sqlSoc);
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    societes.add(new long[] { rs.getLong("id") });
                    societesNames.add(rs.getString("num"));
                }
            }

            // 2) Compute reste(s) using ONLY Pub.resteAPayerParSociete
            List<SocieteResteRow> rows = new ArrayList<>();

            if (selectedSocieteId != null) {
                // only selected societe
                String socName = findSocieteName(cn, selectedSocieteId);
                double reste = Pub.resteAPayerParSociete(selectedSocieteId);
                rows.add(new SocieteResteRow(selectedSocieteId, socName, reste));
            } else {
                // all societes
                String sqlAll = "SELECT id, num FROM societe ORDER BY num";
                try (PreparedStatement ps = cn.prepareStatement(sqlAll);
                        ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        long id = rs.getLong("id");
                        String nom = rs.getString("num");
                        double reste = Pub.resteAPayerParSociete(id);
                        rows.add(new SocieteResteRow(id, nom, reste));
                    }
                }
            }

            // 3) attributes for JSP
            req.setAttribute("activeMenuItem", "pubReste");
            req.setAttribute("pageTitle", "Reste à payer - Pub");

            req.setAttribute("selectedSocieteId", selectedSocieteId);
            req.setAttribute("rows", rows);

            // dropdown list: better send as rows too
            req.setAttribute("societesList", loadSocietesForDropdown(cn));

            RequestDispatcher dispatcher = req.getRequestDispatcher("pub-reste.jsp");
            dispatcher.forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Erreur chargement reste à payer", e);
        }
    }

    private String findSocieteName(Connection cn, long societeId) throws SQLException {
        String sql = "SELECT num FROM societe WHERE id = ?";
        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setLong(1, societeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getString("num");
            }
        }
        return "Societe #" + societeId;
    }

    private List<Object[]> loadSocietesForDropdown(Connection cn) throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT id, num FROM societe ORDER BY num";
        try (PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Object[] { rs.getLong("id"), rs.getString("num") });
            }
        }
        return list;
    }
}
