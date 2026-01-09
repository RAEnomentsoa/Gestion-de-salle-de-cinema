<%@ page contentType="text/html; charset=UTF-8" %>
<%@include file="header.jsp"%>

<div class="container-xxl">
    <div class="row justify-content-center" style="margin-top: 80px;">
        <div class="col-md-5">
            <div class="card">
                <h5 class="card-header">Connexion</h5>
                <div class="card-body">

                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <form method="POST" action="login">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input name="username" type="text" class="form-control" required />
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input name="password" type="password" class="form-control" required />
                        </div>

                        <button type="submit" class="btn btn-primary w-100">Se connecter</button>
                    </form>
                </div>
            </div>

            <div class="text-center mt-3">
                <a href="movie">Accéder sans login (désactivé si filtre actif)</a>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
