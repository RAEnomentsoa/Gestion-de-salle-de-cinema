<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="cinema.Societe" %>
<%
    Societe societe = (Societe) request.getAttribute("societe");
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
                    <ul class="navbar-nav flex-row align-items-center ms-auto"></ul>
                </div>
            </nav>

            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">
                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">Formulaire /</span> Société
                    </h4>

                    <div class="row">
                        <div class="col-lg-6 mx-auto">
                            <div class="card mb-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Société</h5>
                                </div>

                                <div class="card-body">
                                    <form method="POST" action="societe">
                                        <input type="hidden" name="action" value="<%= request.getAttribute("action") %>">
                                        <input type="hidden" name="id" value="<%= societe != null ? societe.getId() : 0 %>">

                                        <div class="mb-3">
                                            <label class="form-label" for="socNum">Num</label>
                                            <input
                                                value="<%= (societe != null && societe.getNum() != null) ? societe.getNum() : "" %>"
                                                name="num"
                                                type="text"
                                                class="form-control"
                                                id="socNum"
                                                placeholder="Num société"
                                                required />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label" for="socPrix">Prix (Ar)</label>
                                            <input
                                              value="<%= (societe != null && societe.getPrix() != null) ? societe.getPrix() : "" %>"

                                                name="prix"
                                                type="number"
                                                step="0.01"
                                                min="0"
                                                class="form-control"
                                                id="socPrix"
                                                placeholder="Prix"
                                                 />
                                        </div>

                                        <% if ("create".equals(request.getAttribute("action"))) { %>
                                            <button type="submit" class="btn btn-success">Ajouter</button>
                                        <% } else { %>
                                            <button type="submit" class="btn btn-primary">Modifier</button>
                                        <% } %>

                                        <a href="societe" class="btn btn-outline-secondary ms-2">Annuler</a>
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
