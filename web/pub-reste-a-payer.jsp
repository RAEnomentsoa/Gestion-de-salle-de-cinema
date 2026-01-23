<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Pub" %>

<%@ include file="header.jsp" %>

<%
    /*
     * On récupère l'id_showtime depuis l'URL
     * Exemple :
     * pub-reste-a-payer.jsp?showtime_id=1
     */
    long showtimeId = Long.parseLong(request.getParameter("showtime_id"));

    // Liste des pubs de cette showtime
    List<Pub> pubs = Pub.getAllPubByIdShowtime(showtimeId);

    /*
     * Pourcentage payé :
     * total payé / total à payer
     * (on prend la société de la première pub car
     * une showtime correspond à une seule société dans ton concept)
     */
    double pourcentage = 0;
    if (pubs != null && !pubs.isEmpty()) {
        pourcentage = Pub.getPourcentage(
            showtimeId,
            pubs.get(0).getId_societe()
        );
    }
%>

<div class="layout-wrapper layout-content-navbar">
<div class="layout-container">

    <%@ include file="vertical-menu.jsp" %>

    <div class="layout-page">

        <!-- NAVBAR -->
        <nav class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme">
            <div class="navbar-nav-right d-flex align-items-center ms-auto">
                <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
            </div>
        </nav>

        <!-- CONTENT -->
        <div class="content-wrapper">
        <div class="container-xxl flex-grow-1 container-p-y">

            <h4 class="fw-bold py-3 mb-4">
                <span class="text-muted fw-light">Pub /</span> Reste à payer par diffusion
            </h4>

            <div class="card">
                <h5 class="card-header">Liste des pubs</h5>

                <div class="table-responsive text-nowrap">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Showtime</th>
                            <th>Société</th>
                            <th>Date</th>
                            <th>Prix pub</th>
                            <th>Reste à payer</th>
                        </tr>
                    </thead>

                    <tbody class="table-border-bottom-0">
                    <%
                        if (pubs != null) {
                            for (Pub p : pubs) {

                                double prixPub = p.getPrixPub();
                                double montantPayeSurPub = prixPub * pourcentage;
                                double resteAPayer = prixPub - montantPayeSurPub;
                    %>
                        <tr>
                            <td><strong><%= p.getId() %></strong></td>
                            <td><%= p.getShowtime_id() %></td>
                            <td><%= p.getId_societe() %></td>
                            <td><%= p.getDates() %></td>
                            <td><%= prixPub %> Ar</td>
                            <td class="fw-bold text-danger">
                                <%= resteAPayer %> Ar
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

        <%@ include file="footer.jsp" %>

    </div>
</div>
</div>
