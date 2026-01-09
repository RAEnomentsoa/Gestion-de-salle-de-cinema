<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Movie" %>
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
                        <span class="text-muted fw-light">Cinéma /</span> Films
                    </h4>

                    <div class="card">
                        <h5 class="card-header">Liste des films</h5>

                        <!-- Controls (Add + filters) -->
                        <div class="card-body">
                            <div class="row g-2 align-items-end">
                                <div class="col-md-4">
                                    <label class="form-label" for="searchMovie">Recherche</label>
                                    <input type="text" id="searchMovie" class="form-control"
                                           placeholder="Rechercher par titre, âge, status...">
                                </div>

                                <div class="col-md-3">
                                    <label class="form-label" for="filterStatus">Status</label>
                                    <select id="filterStatus" class="form-control">
                                        <option value="">Tous</option>
                                        <option value="ACTIVE">ACTIVE</option>
                                        <option value="ARCHIVED">ARCHIVED</option>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <label class="form-label" for="filterAge">Âge</label>
                                    <input type="text" id="filterAge" class="form-control" placeholder="Ex: PG-13, 16+...">
                                </div>

                                <div class="col-md-2 d-flex gap-2">
                                    <a href="movieForm" type="button" class="btn btn-success mt-4">Ajouter</a>
                                    <button type="button" id="resetFilters" class="btn btn-secondary mt-4">Reset</button>
                                </div>
                            </div>
                        </div>

                        <div class="table-responsive text-nowrap" style="overflow-x: visible;">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Titre</th>
                                    <th>Durée (min)</th>
                                    <th>Date sortie</th>
                                    <th>Âge</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>

                                <tbody class="table-border-bottom-0" id="movieTableBody">
                                <%
                                    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
                                    if (movies != null) {
                                        for (Movie m : movies) {
                                %>
                                <tr class="movie-row"
                                    data-title="<%= m.getTitle() != null ? m.getTitle().toLowerCase() : "" %>"
                                    data-status="<%= m.getStatus() != null ? m.getStatus().toLowerCase() : "" %>"
                                    data-age="<%= m.getAgeRating() != null ? m.getAgeRating().toLowerCase() : "" %>">
                                    <td><strong><%= m.getId() %></strong></td>
                                    <td><%= m.getTitle() %></td>
                                    <td><%= m.getDurationMin() %></td>
                                    <td><%= m.getReleaseDate() %></td>
                                    <td><%= m.getAgeRating() %></td>
                                    <td><%= m.getStatus() %></td>
                                    <td>
                                        <div class="dropdown">
                                            <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
                                                <i class="bx bx-dots-vertical-rounded"></i>
                                            </button>
                                            <div class="dropdown-menu">
                                                <a class="dropdown-item" href="movieForm?action=update&id=<%= m.getId() %>">
                                                    <i class="bx bx-edit-alt me-1"></i> Modifier
                                                </a>
                                                <a class="dropdown-item" href="movie?action=delete&id=<%= m.getId() %>">
                                                    <i class="bx bx-trash me-1"></i> Supprimer
                                                </a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                                </tbody>

                            </table>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<!-- FILTER SCRIPT (must be after HTML) -->
<script>
    document.addEventListener("DOMContentLoaded", function () {

        var searchInput = document.getElementById("searchMovie");
        var statusSelect = document.getElementById("filterStatus");
        var ageInput = document.getElementById("filterAge");
        var resetBtn = document.getElementById("resetFilters");

        function applyMovieFilters() {
            var q = (searchInput.value || "").toLowerCase().trim();
            var status = (statusSelect.value || "").toLowerCase().trim();
            var age = (ageInput.value || "").toLowerCase().trim();

            var rows = document.querySelectorAll(".movie-row");

            rows.forEach(function (row) {
                var title = row.getAttribute("data-title") || "";
                var rStatus = row.getAttribute("data-status") || "";
                var rAge = row.getAttribute("data-age") || "";

                var matchSearch = (q === "") || (title.includes(q) || rAge.includes(q) || rStatus.includes(q));
                var matchStatus = (status === "") || (rStatus === status);
                var matchAge = (age === "") || (rAge.includes(age));

                row.style.display = (matchSearch && matchStatus && matchAge) ? "" : "none";
            });
        }

        if (searchInput) searchInput.addEventListener("input", applyMovieFilters);
        if (statusSelect) statusSelect.addEventListener("change", applyMovieFilters);
        if (ageInput) ageInput.addEventListener("input", applyMovieFilters);

        if (resetBtn) {
            resetBtn.addEventListener("click", function () {
                searchInput.value = "";
                statusSelect.value = "";
                ageInput.value = "";
                applyMovieFilters();
            });
        }

        // initial apply (optional)
        applyMovieFilters();
    });
</script>

<%@include file="footer.jsp" %>
