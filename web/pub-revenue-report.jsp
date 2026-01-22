<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Showtime" %>

<%@ include file="header.jsp" %>

<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">

        <%@ include file="vertical-menu.jsp" %>

        <div class="layout-page">

            <!-- NAVBAR -->
            <nav class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme">
                <div class="navbar-nav-right d-flex align-items-center ms-auto"></div>
            </nav>

            <!-- CONTENT -->
            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">

                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">Rapport /</span> Chiffre d'affaire Pub
                    </h4>

                    <!-- FILTRES -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" action="pubRevenueReport" class="row g-3">

                                <!-- SHOWTIME -->
                                <div class="col-md-4">
                                    <label class="form-label">Showtime</label>
                                    <select name="showtimeId" class="form-control">
                                        <option value="">-- Tous les showtimes --</option>
                                        <%
                                            List<Showtime> showtimes = (List<Showtime>) request.getAttribute("showtimes");
                                            Long selectedShowtimeId = (Long) request.getAttribute("selectedShowtimeId");

                                            if (showtimes != null) {
                                                for (Showtime s : showtimes) {
                                        %>
                                            <option value="<%= s.getId() %>"
                                                <%= (selectedShowtimeId != null &&
                                                     selectedShowtimeId.equals(s.getId()))
                                                     ? "selected" : "" %>>
                                                Salle <%= s.getRoomId() %> | Film <%= s.getMovieId() %>
                                                (<%= s.getStartsAt() %>)
                                            </option>
                                        <%      }
                                            }
                                        %>
                                    </select>
                                </div>

                               <!-- MOIS -->
<div class="col-md-4">
    <label class="form-label">Mois</label>
    <select name="month" class="form-control">
        <option value="">-- Tous les mois --</option>
        <%
            String selectedMonth = (String) request.getAttribute("selectedMonth");
            for (int m = 1; m <= 12; m++) {
                String monthValue = String.format("%02d", m); // 01, 02, ..., 12
                String monthName;
                switch(m) {
                    case 1: monthName = "Janvier"; break;
                    case 2: monthName = "Février"; break;
                    case 3: monthName = "Mars"; break;
                    case 4: monthName = "Avril"; break;
                    case 5: monthName = "Mai"; break;
                    case 6: monthName = "Juin"; break;
                    case 7: monthName = "Juillet"; break;
                    case 8: monthName = "Août"; break;
                    case 9: monthName = "Septembre"; break;
                    case 10: monthName = "Octobre"; break;
                    case 11: monthName = "Novembre"; break;
                    case 12: monthName = "Décembre"; break;
                    default: monthName = ""; break;
                }
        %>
            <option value="<%= monthValue %>"
                <%= (selectedMonth != null && selectedMonth.equals(monthValue)) ? "selected" : "" %>>
                <%= monthName %>
            </option>
        <% } %>
    </select>
</div>

<div class="container mt-4">
    <h4>Reste à payer par société</h4>

    <%
        // ID de la société dont on veut afficher le reste
        long societeId = 1; // par exemple la société avec ID = 1

        double reste = 0;
        try {
            reste = Pub.resteAPayerParSociete(societeId);
        } catch (Exception e) {
            reste = 0;
            out.println("<div class='alert alert-danger'>Erreur lors du calcul du reste à payer</div>");
        }
    %>

    <div class="alert alert-info">
        <strong>Reste à payer : </strong> <%= reste %> Ar
    </div>
</div>


                                <!-- BOUTON FILTRER -->
                                <div class="col-md-4 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary">
                                        Filtrer
                                    </button>
                                </div>

                            </form>
                        </div>
                    </div>

                    <!-- RESULTAT -->
                    <div class="card">
                        <div class="card-body text-center">
                            <h5 class="mb-2">Chiffre d'affaire total des pubs</h5>

                            <h2 class="text-success fw-bold">
                                <%= request.getAttribute("totalCA") != null
                                    ? request.getAttribute("totalCA") : "0" %> Ar
                            </h2>
                        </div>
                    </div>

                </div>

                <%@ include file="footer.jsp" %>

            </div>
        </div>
    </div>
</div>
