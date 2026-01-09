<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Room" %>
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
                        <span class="text-muted fw-light">Cinéma /</span> Salles
                    </h4>

                    <div class="card">
                        <h5 class="card-header">Liste des salles</h5>
                        <div class="card-body">
                            <a href="roomForm" type="button" class="btn btn-success">Ajouter</a>
                        </div>

                        <div class="table-responsive text-nowrap" style="overflow-x: visible;">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Cinéma ID</th>
                                    <th>Nom</th>
                                    <th>Type écran</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>

                                <tbody class="table-border-bottom-0">
                                <% for (Room r : (List<Room>) request.getAttribute("rooms")) { %>
                                <tr>
                                    <td><strong><%= r.getId() %></strong></td>
                                    <td><%= r.getCinemaId() %></td>
                                    <td><%= r.getName() %></td>
                                    <td><%= r.getScreenType() %></td>
                                    <td><%= r.getStatus() %></td>
                                    <td>
                                        <div class="dropdown">
                                            <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
                                                <i class="bx bx-dots-vertical-rounded"></i>
                                            </button>
                                            <div class="dropdown-menu">
                                                <a class="dropdown-item" href="roomForm?action=update&id=<%= r.getId() %>">
                                                    <i class="bx bx-edit-alt me-1"></i> Modifier
                                                </a>
                                                <a class="dropdown-item" href="room?action=delete&id=<%= r.getId() %>">
                                                    <i class="bx bx-trash me-1"></i> Supprimer
                                                </a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
