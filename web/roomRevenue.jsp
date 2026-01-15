<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Seat" %>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>

<%
    // Récupérer le paramètre room_id depuis l'URL
    String roomIdParam = request.getParameter("room_id");
    if (roomIdParam == null) {
%>
        <h3>Erreur : paramètre "room_id" manquant</h3>
<%
        return;
    }

    long roomId = 0;
    try {
        roomId = Long.parseLong(roomIdParam);
    } catch (NumberFormatException e) {
%>
        <h3>Erreur : room_id doit être un nombre</h3>
<%
        return;
    }

    // --- Calcul du revenu maximal ---
    double maxRevenue = 0.0;
    List<Seat> seatList = null;

    try {
        maxRevenue = Seat.getSumPrixSeatByRoomId(roomId);
        seatList = Seat.getSeatsByRoomId(roomId); // méthode à créer pour lister les sièges
    } catch (SQLException e) {
%>
        <h3>Erreur SQL : <%= e.getMessage() %></h3>
<%
        e.printStackTrace();
        return;
    }
%>

<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">Salle /</span> Revenu potentiel et liste des sièges
    </h4>

    <div class="card mb-4">
        <h5 class="card-header">Revenu maximum potentiel</h5>
        <div class="card-body">
            <p>Revenu maximal pour la salle <strong><%= roomId %></strong> : 
               <strong><%= String.format("%,.2f", maxRevenue) %> FCFA</strong>
            </p>
        </div>
    </div>

    <div class="card">
        <h5 class="card-header">Liste des sièges actifs</h5>
        <div class="table-responsive text-nowrap">
            <table class="table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Rangée</th>
                        <th>Numéro</th>
                        <th>Type de siège</th>
                        <th>Actif</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (seatList != null && !seatList.isEmpty()) {
                        for (Seat s : seatList) { %>
                        <tr>
                            <td><%= s.getId() %></td>
                            <td><%= s.getRowLabel() %></td>
                            <td><%= s.getSeatNumber() %></td>
                            <td><%= s.getSeatType() %></td> <!-- méthode pour récupérer le nom du tarif -->
                            <td><%= s.isActive() ? "Oui" : "Non" %></td>
                        </tr>
                    <%  } 
                       } else { %>
                        <tr>
                            <td colspan="5">Aucun siège actif dans cette salle.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
