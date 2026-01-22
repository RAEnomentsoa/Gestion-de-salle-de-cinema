<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="cinema.Room" %>

<%
    String activeMenuItem = (String) request.getAttribute("activeMenuItem");
%>

<aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme" style="position: fixed; top: 0; left: 0; height: 100%; width: 250px; overflow-y: auto;">
    <!-- App brand -->
    <div class="app-brand demo">
        <a href="produit" class="app-brand-link">
            <span class="app-brand-logo demo">
                <img width="60" src="assets/img/favicon/cinemalogo.png" alt="Cinema logo">
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

             <li class="menu-item <%= "PaiementFormServlet".equals(activeMenuItem) ? "active" : "" %>">
                <a href="PaiementFormServlet" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-money"></i>
                    <div data-i18n="PaiementFormServlet">Paiement</div>
                </a>
            </li>
        

             <!-- client -->
            <li class="menu-item <%= "client".equals(activeMenuItem) ? "active" : "" %>">
                <a href="client" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-user"></i>
                    <div data-i18n="client">Client</div>
                </a>
            </li>
            <!-- reservation -->
            <li class="menu-item <%= "reservation".equals(activeMenuItem) ? "active" : "" %>">
                <a href="reservation" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-bookmark"></i>
                    <div data-i18n="reservation">Reservation</div>
                </a>
            </li>
            <!-- pub revenue --> 
              <li class="menu-item <%= "pub".equals(activeMenuItem) ? "active" : "" %>">
                <a href="pub" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-bookmark"></i>
                    <div data-i18n="pub">Pub</div>
                </a>
            </li>
            <%-- pub reste --%>
            <li class="menu-item <%= "pubReste".equals(activeMenuItem) ? "active" : "" %>">
                <a href="pubReste" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-wallet"></i>
                    <div data-i18n="pubReste">Reste Pub</div>
                </a>
                </li>



            <li class="menu-item <%= "pubRevenueReport".equals(activeMenuItem) ? "active" : "" %>">
                <a href="pubRevenueReport" class="menu-link">
                    <i class="menu-icon tf-icons bx bx-dollar-circle"></i>
                    <div data-i18n="pubRevenueReport">Pub Revenue</div>
                </a>
            </li>

                    <!-- room revenue (dynamic from session) -->
                <li class="menu-item <%= "roomRevenue".equals(activeMenuItem) ? "active" : "" %>">
                    <a href="javascript:void(0);" class="menu-link dropdown-toggle">
                        <i class="menu-icon tf-icons bx bx-door-open"></i>
                        <div data-i18n="Salle">Salle</div>
                        <i class="bx bx-chevron-down dropdown-icon"></i>
                    </a>

                    <ul class="dropdown-menu">
                        <%
                            List<Room> menuRooms = (List<Room>) session.getAttribute("Vertical_menu_rooms");
                           if (menuRooms != null && !menuRooms.isEmpty()) {
                                       for (Room r : menuRooms) {
                        %>
                            <li class="menu-item">
                                <a href="roomRevenue?room_id=<%= r.getId() %>" class="menu-link">
                                    <i class="bx bx-circle me-2"></i>
                                    <%= (r.getName() != null && !r.getName().isBlank())
                                            ? r.getName()
                                            : ("Salle " + r.getId()) %>
                                </a>
                            </li>
                        <%
                                }
                            } else {
                        %>
                            <li class="menu-item">
                                <span class="menu-link text-muted">
                                    <i class="bx bx-circle me-2"></i>
                                    Aucune salle
                                </span>
                            </li>
                        <%
                            }
                        %>
                    </ul>
                </li>


            <!-- Report / Vente -->
            <li class="menu-item <%= "reservationReport".equals(activeMenuItem) ? "active" : "" %>">
                <a href="javascript:void(0);" class="menu-link dropdown-toggle">
                    <i class="menu-icon tf-icons bx bx-bar-chart-alt-2"></i>
                    <div data-i18n="Report">Report</div>
                    <i class="bx bx-chevron-down dropdown-icon"></i>
                </a>
                <ul class="dropdown-menu">
                    <li class="menu-item">
                        <a href="reservationReport" class="menu-link">
                            <i class="bx bx-circle me-2"></i>
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
                <i class="bx bx-chevron-down dropdown-icon"></i>
            </a>
            <ul class="dropdown-menu">
                <li class="menu-item <%= "ingredientStock".equals(activeMenuItem) ? "active" : "" %>">
                    <a href="ingredientStock" class="menu-link">
                        <i class="bx bx-circle me-2"></i>
                        Ingrédients
                    </a>
                </li>
                <li class="menu-item <%= "produitStock".equals(activeMenuItem) ? "active" : "" %>">
                    <a href="produitStock" class="menu-link">
                        <i class="bx bx-circle me-2"></i>
                        Produits
                    </a>
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
                event.preventDefault();
                const parent = this.closest('.menu-item');
                const dropdownMenu = parent.querySelector('.dropdown-menu');
                const dropdownIcon = this.querySelector('.dropdown-icon');

                // Fermer tous les sous-menus sauf celui cliqué
                document.querySelectorAll('.menu-item .dropdown-menu').forEach(menu => {
                    if (menu !== dropdownMenu) {
                        menu.style.display = 'none';
                        menu.closest('.menu-item').classList.remove('open');
                    }
                });

                // Reset all dropdown icons
                document.querySelectorAll('.dropdown-icon').forEach(icon => {
                    if (icon !== dropdownIcon) {
                        icon.style.transform = 'rotate(0deg)';
                    }
                });

                // Toggle l'affichage du menu cliqué
                if (dropdownMenu) {
                    const isOpen = dropdownMenu.style.display === 'block';
                    dropdownMenu.style.display = isOpen ? 'none' : 'block';
                    parent.classList.toggle('open', !isOpen);
                    
                    // Rotate icon
                    if (dropdownIcon) {
                        dropdownIcon.style.transform = isOpen ? 'rotate(0deg)' : 'rotate(180deg)';
                    }
                }
            });
        });
    });
</script>

<style>
:root {
    --primary-color: #f5af0b;        /* Amber / Orange */
    --primary-hover: #d97706;        /* Darker amber */
    --primary-light: #fff7ed;        /* Soft orange background */

    --sidebar-bg: #ffffff;
    --sidebar-text: #585353da;         /* Warm brown text */
    --sidebar-text-hover: #dcb126;   /* Dark orange/brown */

    --sidebar-active: #f59e0b;
    --sidebar-hover-bg: #fffbeb;     /* Light yellow hover */
    --sidebar-border: #fde68a;       /* Soft yellow border */

    --card-shadow: 0 2px 8px 0 rgba(245, 158, 11, 0.25);
}


    body {
        padding-left: 250px;
        margin: 0;
        font-family: 'Public Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        background-color: #f5f5f9;
    }

    #layout-menu {
        background: var(--sidebar-bg);
        box-shadow: 0 0 20px 0 rgba(67, 89, 113, 0.1);
        border-right: 1px solid rgba(67, 89, 113, 0.1);
    }

    #layout-menu::-webkit-scrollbar {
        width: 6px;
    }

    #layout-menu::-webkit-scrollbar-track {
        background: transparent;
    }

    #layout-menu::-webkit-scrollbar-thumb {
        background: rgba(243, 201, 33, 0.61);
        border-radius: 3px;
    }

    #layout-menu::-webkit-scrollbar-thumb:hover {
        background: rgba(237, 235, 81, 0.94);
    }

    .app-brand {
        padding: 24px 20px;
        border-bottom: 1px solid rgba(67, 89, 113, 0.1);
        background: linear-gradient(180deg, #ffffff 0%, #fafaff 100%);
    }

    .app-brand-link {
        display: flex;
        align-items: center;
        text-decoration: none;
        transition: transform 0.2s ease;
    }

    .app-brand-link:hover {
        transform: translateX(3px);
    }

    .app-brand-logo img {
        transition: all 0.3s ease;
    }

    .app-brand-link:hover .app-brand-logo img {
        transform: scale(1.05);
        filter: brightness(1.1);
    }

    .app-brand-text {
        color: #566a7f;
        font-size: 24px;
        font-weight: 700;
        letter-spacing: 0.5px;
    }

    .menu-inner {
        padding: 12px 0;
    }

    .menu-item {
        position: relative;
        margin: 2px 12px;
        transition: all 0.2s ease;
    }

    .menu-link {
        display: flex;
        align-items: center;
        padding: 11px 16px;
        text-decoration: none;
        font-size: 15px;
        font-weight: 400;
        color: var(--sidebar-text);
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        border-radius: 6px;
        position: relative;
        line-height: 1.5;
    }

    .menu-link:hover {
        background: var(--sidebar-hover-bg);
        color: var(--sidebar-text-hover);
        padding-left: 20px;
    }

  /* ACTIVE MENU = left bar indicator */
.menu-item.active > .menu-link {
    background: rgba(255, 183, 0, 0.12);        /* light amber background */
    color: #92400e;                              /* warm dark text */
    font-weight: 600;
    box-shadow: none;
    padding-left: 20px;                          /* little shift to feel selected */
    position: relative;
}

/* The left vertical bar */
.menu-item.active > .menu-link::before {
    content: "";
    position: absolute;
    left: 0;
    top: 10%;
    height: 80%;
    width: 5px;
    border-radius: 6px;
    background: linear-gradient(180deg, #ffb700cc, rgba(214, 184, 49, 0.9));
    box-shadow: 0 0 10px rgba(255, 183, 0, 0.35);
}

/* Icon color when active */
.menu-item.active > .menu-link .menu-icon {
    color: var(--primary-color);
}

/* Hover on active (keep it subtle) */
.menu-item.active > .menu-link:hover {
    background: rgba(255, 183, 0, 0.18);
    padding-left: 20px;
}


    .menu-icon {
        font-size: 22px;
        margin-right: 12px;
        transition: all 0.2s ease;
        width: 22px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .menu-link:hover .menu-icon {
        color: var(--primary-color);
        transform: scale(1.1);
    }

    .menu-item.active > .menu-link .menu-icon {
        color: #ffffff;
    }

    .dropdown-toggle {
        position: relative;
    }

    .dropdown-icon {
        margin-left: auto;
        font-size: 18px;
        transition: transform 0.3s ease;
        opacity: 0.6;
    }

    .menu-link:hover .dropdown-icon {
        opacity: 1;
    }

    .menu-item.open > .menu-link {
        background: var(--sidebar-hover-bg);
        color: var(--sidebar-text-hover);
    }

        .dropdown-menu {
            display: none;
            padding: 6px 0;
            margin-top: 6px;
            margin-left: 16px;

            background: #ffffff;                 /* SOLID background */
            border-left: 4px solid #f5af0b;       /* orange accent bar */
            border-radius: 6px;

            box-shadow: 0 6px 18px rgba(245, 158, 11, 0.25); /* floating panel */
        }


    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-5px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .dropdown-menu .menu-item {
        margin: 2px 0;
    }

    .dropdown-menu .menu-link {
        padding: 10px 14px;
        font-size: 14px;
        color: #7a5c2e;          
        border-radius: 4px;
    }


        .dropdown-menu .menu-link:hover {
        background: #fff7ed;
        color: #d97706;
        padding-left: 18px;
    }


    .dropdown-menu .menu-link i.bx-circle {
        font-size: 6px;
        opacity: 0.5;
        transition: all 0.2s ease;
    }

    .dropdown-menu .menu-link:hover i.bx-circle {
        color: var(--primary-color);
        opacity: 1;
        transform: scale(1.3);
    }

   .dropdown-menu .menu-item.active > .menu-link {
    background: #fffbeb;
    color: #92400e;
    font-weight: 600;
    position: relative;
}

    .dropdown-menu .menu-item.active > .menu-link::before {
        content: "";
        position: absolute;
        left: 0;
        top: 20%;
        width: 4px;
        height: 60%;
        background: #f5af0b;
        border-radius: 4px;
    }


    /* Mobile responsive */
    @media (max-width: 1200px) {
        body {
            padding-left: 0;
        }
        
        #layout-menu {
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }
        
        #layout-menu.active {
            transform: translateX(0);
        }
    }

    /* Smooth transitions */
    .menu-link, .menu-icon, .dropdown-icon {
        will-change: transform, background, color;
    }

    /* Additional polish */
    .menu-item:first-child {
        margin-top: 0;
    }

    .app-brand-link:focus,
    .menu-link:focus {
        outline: 2px solid var(--primary-color);
        outline-offset: 2px;
    }
</style>