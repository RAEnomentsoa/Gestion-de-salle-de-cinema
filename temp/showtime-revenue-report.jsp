<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.ShowtimeRevenueRow" %>
<%@ page import="cinema.Pub" %>

<%
    List<ShowtimeRevenueRow> rows =
        (List<ShowtimeRevenueRow>) request.getAttribute("rows");

    Double totalRevenue =
        (Double) request.getAttribute("totalRevenue");
    if (totalRevenue == null) totalRevenue = 0.0;
%>

<%@ include file="header.jsp" %>

<div class="layout-wrapper layout-content-navbar">
  <div class="layout-container">
    <%@ include file="vertical-menu.jsp" %>

    <div class="layout-page">
      <div class="content-wrapper">
        <div class="container-xxl container-p-y">

          <div class="d-flex justify-content-between mb-3">
            <h4 class="fw-bold">
              <span class="text-muted fw-light">Report /</span>
              Chiffre d’affaires par diffusion
            </h4>

            <div class="card px-3 py-2">
              <div class="small text-muted">CA TOTAL</div>
              <div class="h4 mb-0">
                <%= String.format("%,.2f", totalRevenue) %> Ar
              </div>
            </div>
          </div>

          <div class="card">
            <div class="table-responsive">
              <table class="table table-striped mb-0">
                <thead>
                  <tr>
                    <th>Film</th>
                    <th>Date & Heure</th>
                    <th>CA Tickets</th>
                    <th>Reste à payer</th>
                    <th>Montant payé</th>
                    
                    <th>CA Total</th>
                  </tr>
                </thead>
                <tbody>
                <% if (rows == null || rows.isEmpty()) { %>
                  <tr>
                    <td colspan="6" class="text-center text-muted py-4">
                      Aucune donnée
                    </td>
                  </tr>
                <% } else {
                     for (ShowtimeRevenueRow r : rows) { 
                         long showtimeId = r.getShowtimeId();
                         long societeId = r.getSocieteId(); // Assure-toi que cette propriété existe dans ShowtimeRevenueRow
                         double montantPaye = 0.0;
                         try {
                             montantPaye = Pub.getTotalMontantPayeByIdShowtime(showtimeId, societeId);
                         } catch (Exception e) {
                             montantPaye = 0.0;
                         }
                         double resteAPayer = r.getTotalRevenue() - montantPaye;
                %>
                  <tr>
                    <td><%= r.getMovieTitle() %></td>
                    <td><%= r.getStartsAt() %></td>
                    <td><%= String.format("%,.2f", r.getTicketRevenue()) %> Ar</td>
                    <td><%= String.format("%,.2f", montantPaye) %> Ar</td>
                    <td><%= String.format("%,.2f", resteAPayer) %> Ar</td>
                    <td class="fw-bold text-success">
                        <%= String.format("%,.2f", r.getTotalRevenue()) %> Ar
                    </td>
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

<%@ include file="footer.jsp" %>
