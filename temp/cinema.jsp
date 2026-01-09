<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Cinema" %>
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
                        <span class="text-muted fw-light">Cinéma /</span> Cinémas
                    </h4>

                    <div class="card">
                        <h5 class="card-header">Liste des cinémas</h5>
                        <div class="card-body">
                            <a href="cinemaForm" type="button" class="btn btn-success">Ajouter</a>
                        </div>

                        <div class="table-responsive text-nowrap" style="overflow-x: visible;">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Nom</th>
                                    <th>Adresse</th>
                                    <th>Ville</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>

                                <tbody class="table-border-bottom-0">
                                <% for (Cinema c : (List<Cinema>) request.getAttribute("cinemas")) { %>
                                <tr>
                                    <td><strong><%= c.getId() %></strong></td>
                                    <td><%= c.getName() %></td>
                                    <td><%= c.getAddress() %></td>
                                    <td><%= c.getCity() %></td>
                                    <td><%= c.getStatus() %></td>
                                    <td>
                                        <div class="dropdown">
                                            <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
                                                <i class="bx bx-dots-vertical-rounded"></i>
                                            </button>
                                            <div class="dropdown-menu">
                                                <a class="dropdown-item" href="cinemaForm?action=update&id=<%= c.getId() %>">
                                                    <i class="bx bx-edit-alt me-1"></i> Modifier
                                                </a>
                                                <a class="dropdown-item" href="cinema?action=delete&id=<%= c.getId() %>">
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
