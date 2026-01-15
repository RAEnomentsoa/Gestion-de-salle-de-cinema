<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String activeMenuItem = (String) request.getAttribute("activeMenuItem");
%>

<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme" style="position: fixed; top: 0; left: 0; height: 100%; width: 250px; overflow-y: auto;">
    <!-- App brand -->
    <div class="app-brand demo">
        <a href="produit" class="app-brand-link">
            <span class="app-brand-logo demo">
                <img width="60" src="assets/img/favicon/cinemalogo.png" alt="Boulangerie logo">
            </span>
            <span class="app-brand-text demo menu-text fw-bolder ms-2">cinema</span>
        </a>

        <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto d-block d-xl-none">
            <i class="bx bx-chevron-left bx-sm align-middle"></i>
        </a>
    </div>
    <!-- / App brand -->

    <ul class="menu-inner py-1">
            <!-- cinema -->
            <li class="menu-item <%= "cinema".equals(activeMenuItem) ? "active" : "" %>">
                <a href="cinema" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-movie-play"></i>
                    <div data-i18n="cinema">Cinema</div>
                </a>
            </li>

            <!-- room -->
            <li class="menu-item <%= "room".equals(activeMenuItem) ? "active" : "" %>">
                <a href="room" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-buildings"></i>
                    <div data-i18n="room">Room</div>
                </a>
            </li>

            <!-- seat -->
            <li class="menu-item <%= "seat".equals(activeMenuItem) ? "active" : "" %>">
                <a href="seat" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-chair"></i>
                    <div data-i18n="seat">Seat</div>
                </a>
            </li>

            <!-- movie -->
            <li class="menu-item <%= "movie".equals(activeMenuItem) ? "active" : "" %>">
                <a href="movie" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-film"></i>
                    <div data-i18n="movie">Movie</div>
                </a>
            </li>

            <!-- showtime -->
            <li class="menu-item <%= "showtime".equals(activeMenuItem) ? "active" : "" %>">
                <a href="showtime" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-time"></i>
                    <div data-i18n="showtime">Showtime</div>
                </a>
            </li>

            <!-- ticket -->
            <li class="menu-item <%= "ticket".equals(activeMenuItem) ? "active" : "" %>">
                <a href="ticket" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-receipt"></i>
                    <div data-i18n="ticket">Ticket</div>
                </a>
            </li>

             <!-- client -->
            <li class="menu-item <%= "client".equals(activeMenuItem) ? "active" : "" %>">
                <a href="client" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-bookmark"></i>
                    <div data-i18n="client">client</div>
                </a>
            </li>

            <!-- reservation -->
            <li class="menu-item <%= "reservation".equals(activeMenuItem) ? "active" : "" %>">
                <a href="reservation" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-bookmark"></i>
                    <div data-i18n="reservation">Reservation</div>
                </a>
            </li>

             <!-- reservation -->
            <li class="menu-item <%= "roomRevenue".equals(activeMenuItem) ? "active" : "" %>">
                 <a href="javascript:void(0);" class="menu-link dropdown-toggle">
                <i class="menu-icon tf-icons bx bx-box"></i>
                <div data-i18n="Stock">salle</div>
            </a>
                 <ul class="dropdown-menu">
                    <li class="menu-item <%= "reservationReport".equals(activeMenuItem) ? "active" : "" %>">
                        <a href="roomRevenue?room_id=1" class="menu-link">
                            <i class="bx bx-file me-2"></i>
                            salle 1
                        </a>
                    </li>
                    <li class="menu-item <%= "reservationReport".equals(activeMenuItem) ? "active" : "" %>">
                        <a href="roomRevenue?room_id=2" class="menu-link">
                            <i class="bx bx-file me-2"></i>
                            salle 2
                        </a>
                    </li>
                    <li class="menu-item <%= "reservationReport".equals(activeMenuItem) ? "active" : "" %>">
                        <a href="roomRevenue?room_id=3" class="menu-link">
                            <i class="bx bx-file me-2"></i>
                            salle 3
                        </a>
                    </li>
                </ul>
                
                
            </li>
        

            <!-- Report / Vente -->
            <li class="menu-item <%= "reservationReport".equals(activeMenuItem) ? "active" : "" %>">
                <a href="javascript:void(0);" class="menu-link dropdown-toggle">
                    <i class="menu-icon tf-icons bx bx-bar-chart-alt-2"></i>
                    <div data-i18n="Report">Report</div>
                </a>
                <ul class="dropdown-menu">
                    <li class="menu-item <%= "reservationReport".equals(activeMenuItem) ? "active" : "" %>">
                        <a href="reservationReport" class="menu-link">
                            <i class="bx bx-file me-2"></i>
                            Rapport Réservations
                        </a>
                    </li>
                </ul>
            </li>

        <!-- Stocks avec sous-menu -->
        <li class="menu-item <%= "stock".equals(activeMenuItem) || "ingredientStock".equals(activeMenuItem) || "produitStock".equals(activeMenuItem) ? "active" : "" %>">
            <a href="javascript:void(0);" class="menu-link dropdown-toggle">
                <i class="menu-icon tf-icons bx bx-box"></i>
                <div data-i18n="Stock">Stocks</div>
            </a>
            <ul class="dropdown-menu">
                <li class="menu-item <%= "ingredientStock".equals(activeMenuItem) ? "active" : "" %>">
                    <a href="ingredientStock" class="menu-link">Ingrédients</a>
                </li>
                <li class="menu-item <%= "produitStock".equals(activeMenuItem) ? "active" : "" %>">
                    <a href="produitStock" class="menu-link">Produits</a>
                </li>
            </ul>
        </li>

      

    </ul>
</aside>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const dropdownToggles = document.querySelectorAll('.menu-link.dropdown-toggle');

        dropdownToggles.forEach(toggle => {
            toggle.addEventListener('click', function (event) {
                event.preventDefault(); // Empêche le comportement par défaut
                const parent = this.closest('.menu-item');
                const dropdownMenu = parent.querySelector('.dropdown-menu');

                // Fermer tous les sous-menus sauf celui cliqué
                document.querySelectorAll('.menu-item .dropdown-menu').forEach(menu => {
                    if (menu !== dropdownMenu) {
                        menu.style.display = 'none';
                    }
                });

                // Toggle l'affichage du menu cliqué
                if (dropdownMenu) {
                    dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
                }
            });
        });
    });
</script>

<style>
    body {
        padding-left: 250px; /* Largeur du menu */
    }

    .menu-item {
        position: relative;
    } 

    .menu-link {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px 15px;
        text-decoration: none;
        font-size: 14px;
        color: #333;
        transition: background-color 0.3s ease;
    }

    .menu-item.active > .menu-link,
    .menu-link:hover {
        background-color: #eaeaea;
        border-radius: 5px;
    }

    .dropdown-menu {
        position: absolute;
        top: 100%;
        left: 0;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 5px;
        display: none;
        z-index: 1000;
    }

    .dropdown-menu .menu-item {
        padding: 0;
    }

    .dropdown-menu .menu-link {
        padding: 10px 20px;
        font-size: 13px;
        color: #555;
    }

    .dropdown-menu .menu-link:hover {
        background-color: #f0f0f0;
        color: #333;
    }
</style>