<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Ticket" %>
<% Ticket ticket = (Ticket) request.getAttribute("ticket"); %>

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
                        <span class="text-muted fw-light">Formulaire /</span> Ticket
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Ticket</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="ticket">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">

                                        <!-- IMPORTANT: in create, ticketId should be 0 -->
                                        <input type="hidden" name="ticketId" value="<%= ticket != null ? ticket.getTicketId() : 0 %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="showtimeId">Showtime ID</label>
                                            <input
                                                    value="<%= (ticket != null && ticket.getShowtimeId() > 0) ? ticket.getShowtimeId() : "" %>"
                                                    name="showtimeId"
                                                    type="number"
                                                    class="form-control"
                                                    id="showtimeId"
                                                    placeholder="ID de la séance"
                                                    required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="seatId">Seat ID (optionnel)</label>
                                            <input
                                                    value="<%= (ticket != null && ticket.getSeatId() != null) ? ticket.getSeatId() : "" %>"
                                                    name="seatId"
                                                    type="number"
                                                    class="form-control"
                                                    id="seatId"
                                                    placeholder="ID du siège (laisser vide si non assigné)" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="prix">Prix</label>
                                            <input
                                                    value="<%= (ticket != null && ticket.getPrix() > 0) ? ticket.getPrix() : "" %>"
                                                    name="prix"
                                                    type="number"
                                                    step="0.01"
                                                    min="0"
                                                    class="form-control"
                                                    id="prix"
                                                    placeholder="Prix du ticket"
                                                    required />
                                        </div>

                                        <% if (request.getAttribute("action").equals("create")) { %>
                                        <button type="submit" class="btn btn-success">Ajouter</button>
                                        <% } else { %>
                                        <button type="submit" class="btn btn-primary">Modifier</button>
                                        <% } %>
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
