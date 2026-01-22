package cinema;

import dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Paiement {

    long id;
    long id_societe;
    double montant;
    Timestamp date;

    public Paiement() {}

    public Paiement(long id) { this.id = id; }

    public Paiement(long id_societe, double montant, Timestamp date) {
        this.id_societe = id_societe;
        this.montant   = montant;
        this.date      = date;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getId_societe() { return id_societe; }
    public void setId_societe(long id_societe) { this.id_societe = id_societe; }
    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }
    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }

    // CREATE
    public void create() throws Exception {
        try (Connection cn = DBConnection.getConnection()) {
            String sql = "INSERT INTO paiement (id_societe, montant, date) VALUES (?, ?, ?)";
            try (PreparedStatement ps = cn.prepareStatement(sql)) {
                ps.setLong(1, id_societe);
                ps.setDouble(2, montant);
                ps.setTimestamp(3, date);
                ps.executeUpdate();
            }
        }
    }

    // GET ALL
    public static List<Paiement> getAll() throws Exception {
        List<Paiement> list = new ArrayList<>();
        try (Connection cn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM paiement ORDER BY date DESC";
            try (PreparedStatement ps = cn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Paiement p = new Paiement(
                        rs.getLong("id_societe"),
                        rs.getDouble("montant"),
                        rs.getTimestamp("date")
                    );
                    p.setId(rs.getLong("id"));
                    list.add(p);
                }
            }
        }
        return list;
    }
}
