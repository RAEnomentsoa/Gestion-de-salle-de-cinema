<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Seat" %>
<% Seat seat = (Seat) request.getAttribute("seat"); %>

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
                        <span class="text-muted fw-light">Formulaire /</span> Siège
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Siège</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="seat">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= seat.getId() %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="seatRoomId">Salle ID</label>
                                            <input value="<%= seat.getRoomId() %>"
                                                   name="room_id" type="number" class="form-control" id="seatRoomId"
                                                   placeholder="Ex: 1" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="seatRow">Rangée</label>
                                            <input value="<%= seat.getRowLabel() != null ? seat.getRowLabel() : "" %>"
                                                   name="row_label" type="text" class="form-control" id="seatRow"
                                                   placeholder="Ex: A, B, C..." required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="seatNumber">Numéro</label>
                                            <input value="<%= seat.getSeatNumber() %>"
                                                   name="seat_number" type="number" class="form-control" id="seatNumber"
                                                   placeholder="Ex: 1" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="seatType">Type</label>
                                            <select name="seat_type" class="form-control" id="seatType" required>
                                                <option value="STANDARD" <%= "STANDARD".equals(seat.getSeatType()) || seat.getSeatType() == null ? "selected" : "" %>>STANDARD</option>
                                                <option value="VIP" <%= "VIP".equals(seat.getSeatType()) ? "selected" : "" %>>VIP</option>
                                                <option value="PMR" <%= "PMR".equals(seat.getSeatType()) ? "selected" : "" %>>PMR</option>
                                                <option value="LOVESEAT" <%= "LOVESEAT".equals(seat.getSeatType()) ? "selected" : "" %>>LOVESEAT</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Actif</label>
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="is_active" id="seatActive"
                                                       <%= seat.isActive() ? "checked" : "" %>>
                                                <label class="form-check-label" for="seatActive">Oui</label>
                                            </div>
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
