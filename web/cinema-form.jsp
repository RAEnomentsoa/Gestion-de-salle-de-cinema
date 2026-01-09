<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Cinema" %>
<% Cinema cinema = (Cinema) request.getAttribute("cinema"); %>

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
                        <span class="text-muted fw-light">Formulaire /</span> Cinéma
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Cinéma</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="cinema">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= cinema.getId() %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="cinemaName">Nom</label>
                                            <input value="<%= cinema.getName() != null ? cinema.getName() : "" %>"
                                                   name="name" type="text" class="form-control" id="cinemaName"
                                                   placeholder="Nom du cinéma" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="cinemaAddress">Adresse</label>
                                            <input value="<%= cinema.getAddress() != null ? cinema.getAddress() : "" %>"
                                                   name="address" type="text" class="form-control" id="cinemaAddress"
                                                   placeholder="Adresse" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="cinemaCity">Ville</label>
                                            <input value="<%= cinema.getCity() != null ? cinema.getCity() : "" %>"
                                                   name="city" type="text" class="form-control" id="cinemaCity"
                                                   placeholder="Ville" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="cinemaStatus">Status</label>
                                            <select name="status" class="form-control" id="cinemaStatus" required>
                                                <option value="ACTIVE" <%= "ACTIVE".equals(cinema.getStatus()) || cinema.getStatus() == null ? "selected" : "" %>>ACTIVE</option>
                                                <option value="INACTIVE" <%= "INACTIVE".equals(cinema.getStatus()) ? "selected" : "" %>>INACTIVE</option>
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
