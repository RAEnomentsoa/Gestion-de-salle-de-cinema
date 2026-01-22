<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Pub" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Showtime" %>
<%@ page import="cinema.PubTarif" %>
<%@ page import="cinema.Societe" %>

<%
    Pub pub = (Pub) request.getAttribute("pub");
    List<Showtime> showtimes = (List<Showtime>) request.getAttribute("showtimes");
    List<Societe> societes = (List<Societe>) request.getAttribute("societes");
    List<PubTarif> pubTarifs = (List<PubTarif>) request.getAttribute("pubTarifs");
%>

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
                        <span class="text-muted fw-light">Formulaire /</span> Pub
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Pub</h5>
                                </div>

                                <div class="card-body">
                                    <!-- IMPORTANT: action points to your servlet that saves Pub (doPost) -->
                                    <form method="POST" action="pub">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= pub != null ? pub.getId() : 0 %>">

                                        <!-- Showtime -->
                                        <div class="mb-3">
                                            <label class="form-label" for="showtimeId">Showtime</label>
                                            <select name="showtime_id" class="form-control" id="showtimeId" required>
                                                <option value="">-- Choisir un showtime --</option>
                                                <%
                                                    long selectedShowtime = (pub != null) ? pub.getShowtime_id() : 0;
                                                    if (showtimes != null) {
                                                        for (Showtime s : showtimes) {
                                                            long sid = s.getId();
                                                %>
                                                    <option value="<%= sid %>" <%= (sid == selectedShowtime ? "selected" : "") %>>
                                                        Salle <%= s.getRoomId() %> | Film <%= s.getMovieId() %> (<%= s.getStartsAt() %>)
                                                    </option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <!-- Société -->
                                        <div class="mb-3">
                                            <label class="form-label" for="societeId">Société</label>
                                            <select name="id_societe" class="form-control" id="societeId" required>
                                                <option value="">-- Choisir une société --</option>
                                                <%
                                                    long selectedSociete = (pub != null) ? pub.getId_societe() : 0;
                                                    if (societes != null) {
                                                        for (Societe so : societes) {
                                                            long soId = so.getId();
                                                %>
                                                    <option value="<%= soId %>" <%= (soId == selectedSociete ? "selected" : "") %>>
                                                        <%= so.getNum() %>
                                                    </option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <!-- Date -->
                                        <div class="mb-3">
                                            <label class="form-label" for="dates">Date</label>
                                            <%
                                                // Format Timestamp -> datetime-local value: yyyy-MM-ddTHH:mm
                                                String datesValue = "";
                                                if (pub != null && pub.getDates() != null) {
                                                    String ts = pub.getDates().toString(); // yyyy-MM-dd HH:mm:ss...
                                                    if (ts.length() >= 16) {
                                                        datesValue = ts.substring(0, 16).replace(" ", "T");
                                                    }
                                                }
                                            %>
                                            <input
                                                value="<%= datesValue %>"
                                                name="dates"
                                                type="datetime-local"
                                                class="form-control"
                                                id="dates"
                                                required />
                                        </div>

                                        <!-- Tarif Pub -->
                                        <div class="mb-3">
                                            <label class="form-label" for="prixId">Tarif Pub</label>
                                            <select name="id_prix" class="form-control" id="prixId" required>
                                                <option value="">-- Choisir un tarif --</option>
                                                <%
                                                    long selectedTarif = (pub != null) ? pub.getId_prix() : 0;
                                                    if (pubTarifs != null) {
                                                        for (PubTarif pt : pubTarifs) {
                                                            long ptId = pt.getId();
                                                %>
                                                    <option value="<%= ptId %>" <%= (ptId == selectedTarif ? "selected" : "") %>>
                                                        Tarif #<%= ptId %> — <%= pt.getPrix() %> Ar
                                                    </option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <% if ("create".equals(request.getAttribute("action"))) { %>
                                            <button type="submit" class="btn btn-success">Ajouter</button>
                                        <% } else { %>
                                            <button type="submit" class="btn btn-primary">Modifier</button>
                                        <% } %>

                                        <a href="pub" class="btn btn-outline-secondary ms-2">Annuler</a>
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
