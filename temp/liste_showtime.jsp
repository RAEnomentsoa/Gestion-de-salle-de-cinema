<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Showtime" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des Showtimes</title>

    <!-- Bootstrap (optionnel) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body>

<div class="container mt-5">

    <h3 class="mb-4">Sélectionner un Showtime</h3>

    <form method="get" action="PubResteAPayerServlet">

        <!-- LISTE DÉROULANTE -->
        <div class="mb-3">
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
                        Salle <%= s.getRoomId() %> |
                        Film <%= s.getMovieId() %> |
                        Début : <%= s.getStartsAt() %>
                    </option>
                <%
                        }
                    }
                %>
            </select>
        </div>

        <!-- BOUTON -->
        <button type="submit" class="btn btn-primary">
            Voir le reste à payer
        </button>

    </form>

</div>

</body>
</html>
