<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Societe" %>

<%@ include file="header.jsp" %>

<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        <%@ include file="vertical-menu.jsp" %>

        <div class="layout-page">
            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">

                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">Formulaire /</span> Paiement
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="mb-0">Ajouter Paiement</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="PaiementFormServlet">

                                        <!-- Société -->
                                        <div class="mb-3">
                                            <label class="form-label">Société</label>
                                            <select name="id_societe" class="form-control" required>
                                                <option value="">-- Sélectionner --</option>
                                                <%
                                                    List<Societe> societes = (List<Societe>) request.getAttribute("societes");
                                                    for (Societe s : societes) {
                                                %>
                                                    <option value="<%= s.getId() %>"><%= s.getNum() %></option>
                                                <% } %>
                                            </select>
                                        </div>

                                        <!-- Montant -->
                                        <div class="mb-3">
                                            <label class="form-label">Montant</label>
                                            <input type="number" step="0.01" min="0" name="montant" class="form-control" placeholder="Ex: 250000" required>
                                        </div>

                                        <!-- Date -->
                                        <div class="mb-3">
                                            <label class="form-label">Date et Heure</label>
                                            <input type="datetime-local" name="date" class="form-control" required>
                                        </div>

                                        <button type="submit" class="btn btn-success">Ajouter</button>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                </div>
                <%@ include file="footer.jsp" %>
            </div>
        </div>
    </div>
</div>
