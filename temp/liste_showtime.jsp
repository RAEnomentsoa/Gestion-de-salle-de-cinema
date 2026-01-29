<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Showtime" %>
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
                        <span class="text-muted fw-light">Cinéma /</span> Pub - Reste à payer
                    </h4>

                    <div class="card">
                        <h5 class="card-header">Sélectionner un showtime</h5>

                        <div class="card-body">
                            <form method="get" action="PubResteAPayerServlet" class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label">Showtime</label>

                                    <select name="showtime_id" class="form-select" required>
                                        <option value="">-- Choisir un showtime --</option>

                                        <%
                                            List<Showtime> showtimes =
                                                (List<Showtime>) request.getAttribute("showtimes");

                                            if (showtimes != null) {
                                                for (Showtime s : showtimes) {
                                        %>
                                            <option value="<%= s.getId() %>">
                                                Showtime #<%= s.getId() %> |
                                                Salle <%= s.getRoomId() %> |
                                                Film <%= s.getMovieId() %> |
                                                Début : <%= s.getStartsAt() %> |
                                                Fin : <%= s.getEndsAt() %> |
                                                Statut : <%= s.getStatus() %>
                                            </option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </div>

                                <div class="col-md-4 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">
                                        Voir le reste à payer
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
