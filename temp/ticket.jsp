<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Ticket" %>

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
                        <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                    </ul>
                </div>
            </nav>

            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">
                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">Ticket /</span> Tickets
                    </h4>

                    <div class="card">
                        <h5 class="card-header">Liste des tickets</h5>

                        <div class="card-body">
                            <a href="ticketForm" type="button" class="btn btn-success">Ajouter</a>
                        </div>

                        <div class="table-responsive text-nowrap" style="overflow-x: visible;">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Showtime</th>
                                    <th>Seat</th>
                                    <th>Prix</th>
                                    <th>Date création</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>

                                <tbody class="table-border-bottom-0">
                                <% for (Ticket t : (List<Ticket>) request.getAttribute("tickets")) { %>
                                <tr>
                                    <td><strong><%= t.getTicketId() %></strong></td>
                                    <td><%= t.getShowtimeId() %></td>
                                    <td>
                                        <%= t.getSeatId() != null ? t.getSeatId() : "—" %>
                                    </td>
                                    <td><%= t.getPrix() %></td>
                                    <td>
                                        <%= t.getCreatedAt() != null ? t.getCreatedAt() : "" %>
                                    </td>
                                    <td>
                                        <div class="dropdown">
                                            <button type="button" class="btn p-0 dropdown-toggle hide-arrow"
                                                    data-bs-toggle="dropdown">
                                                <i class="bx bx-dots-vertical-rounded"></i>
                                            </button>

                                            <div class="dropdown-menu">
                                                <a class="dropdown-item"
                                                   href="ticketForm?action=update&id=<%= t.getTicketId() %>">
                                                    <i class="bx bx-edit-alt me-1"></i> Modifier
                                                </a>
                                                <a class="dropdown-item"
                                                   href="ticket?action=delete&id=<%= t.getTicketId() %>">
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
