package cinema;

import java.sql.Timestamp;

public class ShowtimeRevenueRow {

    private long showtimeId;
    private long societeId;          // ID de la société
    private String movieTitle;
    private Timestamp startsAt;
    private double ticketRevenue;     // CA tickets
    private double pubRevenue;        // CA publicité
    private double totalRevenue;      // CA total (ticket + pub)
    private double montantPaye;       // Montant déjà payé
    private double resteAPayer;       // Montant restant à payer

    // Constructeur
    public ShowtimeRevenueRow() {}

    public ShowtimeRevenueRow(long showtimeId, long societeId, String movieTitle, Timestamp startsAt,
                              double ticketRevenue, double pubRevenue,
                              double montantPaye, double resteAPayer) {
        this.showtimeId = showtimeId;
        this.societeId = societeId;
        this.movieTitle = movieTitle;
        this.startsAt = startsAt;
        this.ticketRevenue = ticketRevenue;
        this.pubRevenue = pubRevenue;
        this.montantPaye = montantPaye;
        this.resteAPayer = resteAPayer;
        this.totalRevenue = ticketRevenue + pubRevenue;
    }

    // Getters & Setters
    public long getShowtimeId() { return showtimeId; }
    public void setShowtimeId(long showtimeId) { this.showtimeId = showtimeId; }

    public long getSocieteId() { return societeId; }
    public void setSocieteId(long societeId) { this.societeId = societeId; }

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }

    public Timestamp getStartsAt() { return startsAt; }
    public void setStartsAt(Timestamp startsAt) { this.startsAt = startsAt; }

    public double getTicketRevenue() { return ticketRevenue; }
    public void setTicketRevenue(double ticketRevenue) { this.ticketRevenue = ticketRevenue; }

    public double getPubRevenue() { return pubRevenue; }
    public void setPubRevenue(double pubRevenue) { this.pubRevenue = pubRevenue; }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

    public double getMontantPaye() { return montantPaye; }
    public void setMontantPaye(double montantPaye) { this.montantPaye = montantPaye; }

    public double getResteAPayer() { return resteAPayer; }
    public void setResteAPayer(double resteAPayer) { this.resteAPayer = resteAPayer; }
}
