<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Reservation" %>
<%@ page import="cinema.Ticket" %>
<%@ page import="cinema.Room" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    Map<Long, String> ticketLabels = (Map<Long, String>) request.getAttribute("ticketLabels");
    Long selectedRoomId = (Long) request.getAttribute("selectedRoomId");

    String action = (String) request.getAttribute("action");
    if (action == null) action = "create";
%>

<%@include file="header.jsp"%>

<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        <%@include file="vertical-menu.jsp"%>

        <div class="layout-page">
            <nav class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
                 id="layout-navbar">
                <div class="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
                    <a class="nav-item nav-link px-0 me-xl-4" href="javascript:void(0)">
                        <i class="bx bx-menu bx-sm"></i>
                    </a>
                </div>

                <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">
                    <ul class="navbar-nav flex-row align-items-center ms-auto">
                        <%-- <%@ include file="user.jsp" %> --%>
                    </ul>
                </div>
            </nav>

            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">

                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">Formulaire /</span> Réservation
                    </h4>

                    <div class="row">
                        <div class="col-lg-8 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Réservation</h5>
                                </div>

                                <div class="card-body">

                                    <!-- ==========================
                                         FILTER (Room -> tickets)
                                         ========================== -->
                                    <form method="GET" action="reservationForm" class="mb-4">
                                        <input type="hidden" name="action" value="<%= action %>">
                                        <input type="hidden" name="id" value="<%= (reservation != null ? reservation.getReservationId() : 0) %>">

                                        <div class="row g-3 align-items-end">
                                            <div class="col-md-8">
                                                <label class="form-label" for="roomId">Filtrer par salle</label>
                                                <select name="roomId" id="roomId" class="form-control" onchange="this.form.submit()">
                                                    <option value="">-- Toutes les salles --</option>
                                                    <% if (rooms != null) {
                                                        for (Room r : rooms) { %>
                                                            <option value="<%= r.getId() %>"
                                                                <%= (selectedRoomId != null && selectedRoomId.longValue() == r.getId()) ? "selected" : "" %>>
                                                                <%= r.getName() %>
                                                            </option>
                                                    <%  } } %>
                                                </select>
                                            </div>

                                            <div class="col-md-4">
                                                <button type="submit" class="btn btn-outline-primary w-100">
                                                    Appliquer filtre
                                                </button>
                                            </div>
                                        </div>
                                    </form>

                                    <!-- ==========================
                                         MAIN FORM (create/update)
                                         ========================== -->
                                    <form method="POST" action="reservation">
                                        <input type="hidden" name="action" value="<%= action %>">
                                        <input type="hidden" name="id" value="<%= (reservation != null ? reservation.getReservationId() : 0) %>">

                                        <!-- keep selected room when POST (optional but useful) -->
                                        <input type="hidden" name="roomId" value="<%= (selectedRoomId != null ? selectedRoomId : "") %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="ticketId">Ticket</label>
                                            <select name="ticketId" class="form-control" id="ticketId" required>
                                                <option value="">-- Choisir un ticket --</option>

                                                <% if (tickets != null && ticketLabels != null) {
                                                    for (Ticket t : tickets) {
                                                        long tid = t.getTicketId();
                                                        boolean isSelected = (reservation != null && reservation.getTicketId() == tid);
                                                        String label = ticketLabels.get(tid);
                                                        if (label == null) label = "Showtime: -";
                                                %>
                                                    <option value="<%= tid %>" <%= isSelected ? "selected" : "" %>>
                                                        Ticket #<%= tid %> | <%= label %>
                                                        | Seat: <%= (t.getSeatId() != null ? t.getSeatId() : "-") %>
                                                        | Prix: <%= t.getPrix() %>
                                                    </option>
                                                <%  } } %>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="clientId">Client ID</label>
                                            <input
                                                value="<%= (reservation != null && reservation.getClientId() != 0) ? reservation.getClientId() : "" %>"
                                                name="clientId"
                                                type="number"
                                                class="form-control"
                                                id="clientId"
                                                placeholder="ID du client"
                                                required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="reservationStatus">Status</label>
                                            <select name="status" class="form-control" id="reservationStatus" required>
                                                <option value="PAYER"
                                                    <%= (reservation != null && "PAYER".equals(reservation.getStatus())) ? "selected" : "" %>>
                                                    PAYER
                                                </option>
                                                <option value="NON_PAYER"
                                                    <%= (reservation == null || reservation.getStatus() == null || "NON_PAYER".equals(reservation.getStatus())) ? "selected" : "" %>>
                                                    NON_PAYER
                                                </option>
                                            </select>
                                        </div>

                                        <div class="d-flex gap-2">
                                            <% if ("create".equals(action)) { %>
                                                <button type="submit" class="btn btn-success">Ajouter</button>
                                            <% } else { %>
                                                <button type="submit" class="btn btn-primary">Modifier</button>
                                            <% } %>

                                            <a href="reservationList" class="btn btn-outline-secondary">Annuler</a>
                                        </div>

                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
