<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Room" %>
<% Room room = (Room) request.getAttribute("room"); %>

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
                        <span class="text-muted fw-light">Formulaire /</span> Salle
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Salle</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="room">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= room.getId() %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="roomCinemaId">Cinéma ID</label>
                                            <input value="<%= room.getCinemaId() %>"
                                                   name="cinema_id" type="number" class="form-control" id="roomCinemaId"
                                                   placeholder="Ex: 1" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="roomName">Nom</label>
                                            <input value="<%= room.getName() != null ? room.getName() : "" %>"
                                                   name="name" type="text" class="form-control" id="roomName"
                                                   placeholder="Ex: Salle 1" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="roomScreenType">Type écran</label>
                                            <input value="<%= room.getScreenType() != null ? room.getScreenType() : "" %>"
                                                   name="screen_type" type="text" class="form-control" id="roomScreenType"
                                                   placeholder="Ex: STANDARD, IMAX" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="roomStatus">Status</label>
                                            <select name="status" class="form-control" id="roomStatus" required>
                                                <option value="ACTIVE" <%= "ACTIVE".equals(room.getStatus()) || room.getStatus() == null ? "selected" : "" %>>ACTIVE</option>
                                                <option value="MAINTENANCE" <%= "MAINTENANCE".equals(room.getStatus()) ? "selected" : "" %>>MAINTENANCE</option>
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
