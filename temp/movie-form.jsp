<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Movie" %>
<% Movie movie = (Movie) request.getAttribute("movie"); %>

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
                        <span class="text-muted fw-light">Formulaire /</span> Film
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Film</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="movie">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= movie.getId() %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="movieTitle">Titre</label>
                                            <input value="<%= movie.getTitle() != null ? movie.getTitle() : "" %>"
                                                   name="title" type="text" class="form-control" id="movieTitle"
                                                   placeholder="Titre du film" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="movieDuration">Durée (minutes)</label>
                                            <input value="<%= movie.getDurationMin() %>"
                                                   name="duration_min" type="number" class="form-control" id="movieDuration"
                                                   placeholder="Ex: 120" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="movieRelease">Date de sortie</label>
                                            <input value="<%= movie.getReleaseDate() != null ? movie.getReleaseDate() : "" %>"
                                                   name="release_date" type="date" class="form-control" id="movieRelease" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="movieAge">Âge / Rating</label>
                                            <input value="<%= movie.getAgeRating() != null ? movie.getAgeRating() : "" %>"
                                                   name="age_rating" type="text" class="form-control" id="movieAge"
                                                   placeholder="Ex: PG-13, -12..." />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="movieStatus">Status</label>
                                            <select name="status" class="form-control" id="movieStatus" required>
                                                <option value="ACTIVE" <%= "ACTIVE".equals(movie.getStatus()) || movie.getStatus() == null ? "selected" : "" %>>ACTIVE</option>
                                                <option value="ARCHIVED" <%= "ARCHIVED".equals(movie.getStatus()) ? "selected" : "" %>>ARCHIVED</option>
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
