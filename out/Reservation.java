package cinema;

import java.sql.Timestamp;

public class Reservation {

    private long reservationId;
    private long ticketId;
    private long clientId;
    private String status;
    private Timestamp createdAt;

    // Constructeur vide
    public Reservation() {
    }

    // Constructeur avec id
    public Reservation(long reservationId) {
        this.reservationId = reservationId;
    }

    // Constructeur complet
    public Reservation(long reservationId, long ticketId, long clientId, String status) {
        this.reservationId = reservationId;
        this.ticketId = ticketId;
        this.clientId = clientId;
        this.status = status;
    }

    // Getters & Setters
    public long getReservationId() {
        return reservationId;
    }

    public void setReservationId(long reservationId) {
        this.reservationId = reservationId;
    }

    public long getTicketId() {
        return ticketId;
    }

    public void setTicketId(long ticketId) {
        this.ticketId = ticketId;
    }

    public long getClientId() {
        return clientId;
    }

    public void setClientId(long clientId) {
        this.clientId = clientId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
