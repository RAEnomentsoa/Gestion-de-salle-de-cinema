<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Room" %>
<%@ page import="cinema.Movie" %>
<%@ page import="cinema.dto.ReservationReportRow" %>

<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
    List<ReservationReportRow> rows = (List<ReservationReportRow>) request.getAttribute("rows");

    Long selectedRoomId = (Long) request.getAttribute("selectedRoomId");
    Long selectedMovieId = (Long) request.getAttribute("selectedMovieId");

    Double totalRevenue = (Double) request.getAttribute("totalRevenue");
    if (totalRevenue == null) totalRevenue = 0.0;
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
      </nav>

      <div class="content-wrapper">
        <div class="container-xxl flex-grow-1 container-p-y">

          <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold mb-0">
              <span class="text-muted fw-light">Report /</span> Réservations & Tickets
            </h4>

            <!-- Total chiffre d'affaire -->
            <div class="card px-3 py-2">
              <div class="small text-muted">Total chiffre d’affaire (PAYER)</div>
              <div class="h4 mb-0"><%= String.format("%,.2f", totalRevenue) %></div>
            </div>
          </div>

          <!-- Filters -->
          <div class="card mb-4">
            <div class="card-body">
              <form method="GET" action="reservationReport" class="row g-3 align-items-end">
                <div class="col-md-4">
                  <label class="form-label" for="roomId">Salle (Room)</label>
                  <select name="roomId" id="roomId" class="form-control">
                    <option value="">-- Toutes les salles --</option>
                    <% if (rooms != null) for (Room r : rooms) { %>
                      <option value="<%= r.getId() %>"
                        <%= (selectedRoomId != null && selectedRoomId.longValue() == r.getId()) ? "selected" : "" %>>
                        <%= r.getName() %>
                      </option>
                    <% } %>
                  </select>
                </div>

                <div class="col-md-4">
                  <label class="form-label" for="movieId">Film (Movie)</label>
                  <select name="movieId" id="movieId" class="form-control">
                    <option value="">-- Tous les films --</option>
                    <% if (movies != null) for (Movie m : movies) { %>
                      <option value="<%= m.getId() %>"
                        <%= (selectedMovieId != null && selectedMovieId.longValue() == m.getId()) ? "selected" : "" %>>
                        <%= m.getTitle() %>
                      </option>
                    <% } %>
                  </select>
                </div>

                <div class="col-md-4 d-flex gap-2">
                  <button class="btn btn-primary w-100" type="submit">Filtrer</button>
                  <a class="btn btn-outline-secondary w-100" href="reservationReport">Reset</a>
                </div>
              </form>
            </div>
          </div>

          <!-- Table -->
          <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
              <h5 class="mb-0">Liste</h5>
              <span class="text-muted small">
                <%= (rows == null ? 0 : rows.size()) %> résultat(s)
              </span>
            </div>

            <div class="table-responsive">
              <table class="table table-striped mb-0">
                <thead>
                  <tr>
                    <th>Reservation #</th>
                    <th>Ticket #</th>
                    <th>Status</th>
                    <th>Client</th>
                    <th>Cinema</th>
                    <th>Room</th>
                    <th>Movie</th>
                    <th>Starts At</th>
                    <th>Seat</th>
                    <th>Prix</th>
                    <th>Created</th>
                  </tr>
                </thead>
                <tbody>
                  <% if (rows == null || rows.isEmpty()) { %>
                    <tr><td colspan="11" class="text-center py-4 text-muted">Aucune donnée</td></tr>
                  <% } else {
                      for (ReservationReportRow r : rows) {
                        String seat = (r.getSeatRow() == null || r.getSeatNumber() == null)
                          ? "-"
                          : (r.getSeatRow() + r.getSeatNumber());
                  %>
                    <tr>
                      <td><%= r.getReservationId() %></td>
                      <td><%= r.getTicketId() %></td>
                      <td><%= r.getReservationStatus() %></td>
                      <td><%= r.getClientName() %></td>
                      <td><%= r.getCinemaName() %></td>
                      <td><%= r.getRoomName() %></td>
                      <td><%= r.getMovieTitle() %></td>
                      <td><%= r.getStartsAt() %></td>
                      <td><%= seat %></td>
                      <td><%= String.format("%,.2f", r.getPrix()) %></td>
                      <td><%= r.getReservationCreatedAt() %></td>
                    </tr>
                  <% } } %>
                </tbody>
              </table>
            </div>

          </div>

        </div>
      </div>

    </div>
  </div>
</div>

<%@include file="footer.jsp"%>
