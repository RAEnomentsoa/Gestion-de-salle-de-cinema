<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="servlet.PubResteServlet.SocieteResteRow" %>

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
            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
          </ul>
        </div>
      </nav>

      <div class="content-wrapper">
        <div class="container-xxl flex-grow-1 container-p-y">

          <h4 class="fw-bold py-3 mb-4">
            <span class="text-muted fw-light">Pub /</span> Reste à payer par société
          </h4>

          <!-- FILTER -->
          <div class="card mb-4">
            <div class="card-body">
              <form method="GET" action="pubReste" class="row g-3">

                <div class="col-md-6">
                  <label class="form-label">Société</label>
                  <select name="societeId" class="form-control">
                    <option value="">-- Toutes les sociétés --</option>
                    <%
                      List<Object[]> societesList = (List<Object[]>) request.getAttribute("societesList");
                      Long selectedSocieteId = (Long) request.getAttribute("selectedSocieteId");

                      if (societesList != null) {
                        for (Object[] s : societesList) {
                          Long id = (Long) s[0];
                          String nom = (String) s[1];
                    %>
                      <option value="<%= id %>" <%= (selectedSocieteId != null && selectedSocieteId.equals(id)) ? "selected" : "" %>>
                        <%= nom %>
                      </option>
                    <%
                        }
                      }
                    %>
                  </select>
                </div>

                <div class="col-md-6 d-flex align-items-end">
                  <button type="submit" class="btn btn-primary">Filtrer</button>
                  <a href="pubReste" class="btn btn-outline-secondary ms-2">Reset</a>
                </div>

              </form>
            </div>
          </div>

          <!-- TABLE -->
          <div class="card">
            <h5 class="card-header">Reste à payer</h5>

            <div class="table-responsive text-nowrap" style="overflow-x: visible;">
              <table class="table">
                <thead>
                <tr>
                  <th>#</th>
                  <th>Société</th>
                  <th>Reste à payer</th>
                </tr>
                </thead>

                <tbody class="table-border-bottom-0">
                <%
                  List<SocieteResteRow> rows = (List<SocieteResteRow>) request.getAttribute("rows");
                  if (rows != null && !rows.isEmpty()) {
                    for (SocieteResteRow r : rows) {
                %>
                <tr>
                  <td><strong><%= r.getId() %></strong></td>
                  <td><%= r.getNom() %></td>
                  <td>
                    <span class="badge bg-warning text-dark">
                      <%= r.getReste() %> Ar
                    </span>
                  </td>
                </tr>
                <%
                    }
                  } else {
                %>
                <tr>
                  <td colspan="3" class="text-center text-muted">Aucune donnée</td>
                </tr>
                <%
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

<%@include file="footer.jsp"%>
