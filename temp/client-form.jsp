<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Client" %>
<%@ page import="cinema.Categorie" %>
<%@ page import="java.util.List" %>
<% Client client = (Client) request.getAttribute("client"); %>
<% List<Categorie> listeCategorie = (List<Categorie>) request.getAttribute("listeCategorie"); %>

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
                        <span class="text-muted fw-light">Formulaire /</span> Client
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Client</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="clientForm">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= client.getId() %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="clientName">Nom</label>
                                            <input
                                                  name="nom" type="text" class="form-control" id="clientName"
                                                  placeholder="Ex: John Doe" required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="clientAddress">Adresse</label>
                                            <input
                                                  name="address" type="text" class="form-control" id="clientAddress"
                                                  placeholder="Ex: 123 rue du Cinéma"  />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="clientAge">Age</label>
                                            <input
                                                  name="age" type="number" class="form-control" id="clientAge"
                                                  placeholder="Ex: 25"/>
                                        </div>

                                        <<div class="mb-3">
                                            <label class="form-label" for="clientCategorie">Catégorie</label>
                                            <select name="id_categorie" class="form-control" id="clientCategorie" required>
                                                <option value="">-- Catégorie --</option>
                                                <% if (listeCategorie != null) {
                                                    for (Categorie c : listeCategorie) { %>
                                                        <option value="<%= c.getId() %>">
                                                            <%= c.getNom() %>
                                                        </option>
                                                <%  }
                                                } %>
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
