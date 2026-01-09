<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Showtime" %>
<% Showtime showtime = (Showtime) request.getAttribute("showtime"); %>

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
                        <span class="text-muted fw-light">Formulaire /</span> Séance
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Séance</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="showtime">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= showtime.getId() %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="stCinema">Cinéma ID</label>
                                            <input value="<%= showtime.getCinemaId() %>"
                                                   name="cinema_id" type="number" class="form-control" id="stCinema"
                                                   placeholder="Ex: 1" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="stRoom">Salle ID</label>
                                            <input value="<%= showtime.getRoomId() %>"
                                                   name="room_id" type="number" class="form-control" id="stRoom"
                                                   placeholder="Ex: 1" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="stMovie">Film ID</label>
                                            <input value="<%= showtime.getMovieId() %>"
                                                   name="movie_id" type="number" class="form-control" id="stMovie"
                                                   placeholder="Ex: 1" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="stStarts">Début (timestamp)</label>
                                            <input value="<%= showtime.getStartsAt() != null ? showtime.getStartsAt() : "" %>"
                                                   name="starts_at" type="text" class="form-control" id="stStarts"
                                                   placeholder="YYYY-MM-DD HH:MM:SS" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="stEnds">Fin (timestamp)</label>
                                            <input value="<%= showtime.getEndsAt() != null ? showtime.getEndsAt() : "" %>"
                                                   name="ends_at" type="text" class="form-control" id="stEnds"
                                                   placeholder="YYYY-MM-DD HH:MM:SS" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="stPrice">Prix de base</label>
                                            <input value="<%= showtime.getBasePrice() %>"
                                                   name="base_price" type="number" step="0.01" class="form-control" id="stPrice"
                                                   placeholder="Ex: 15000" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="stStatus">Status</label>
                                            <select name="status" class="form-control" id="stStatus" required>
                                                <option value="SCHEDULED" <%= "SCHEDULED".equals(showtime.getStatus()) || showtime.getStatus() == null ? "selected" : "" %>>SCHEDULED</option>
                                                <option value="OPEN" <%= "OPEN".equals(showtime.getStatus()) ? "selected" : "" %>>OPEN</option>
                                                <option value="CLOSED" <%= "CLOSED".equals(showtime.getStatus()) ? "selected" : "" %>>CLOSED</option>
                                                <option value="CANCELED" <%= "CANCELED".equals(showtime.getStatus()) ? "selected" : "" %>>CANCELED</option>
                                            </select>
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
