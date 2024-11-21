<%-- 
    Document   : UserController
    Created on : 17/11/2024, 7:05:38 p. m.
    Author     : María Fernanda Ochoa
--%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="Bussines.Exceptions.DuplicateUserException"%>
<%@page import="java.io.IOException"%> <!-- IMPORTACIÓN DE IOException -->
<%@page import="jakarta.servlet.*"%> <!-- IMPORTACIÓN DE ServletException -->
<%@page import="Bussines.Service.UserService"%>
<%@page import="Domain.Model.User"%>
<%@page import="Bussines.Exceptions.UserNotFoundException"%>
<%@page import="Bussines.Exceptions.DuplicateUserException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UserService userService = new UserService();
    String action = request.getParameter("action");

    if (action == null) {
        action = "list";
    }

    switch (action) {
        case "login":
            handleLogin(request, response, session);
            break;
        case "authenticate":
            handleAuthenticate(request, response, session, userService);
            break;
        case "showCreateForm":
            showCreateUserForm(request, response);
            break;
        case "create":
            handleCreateUser(request, response, userService);
            break;
        case "showFindForm":
            showFindForm(request, response, session, userService);
            break;
        case "search":
            handleSearch(request, response, session, userService);
            break;
        case "update":
            handleUpdateUser(request, response, session, userService);
            break;
        case "delete":
            handleDeleteUser(request, response, session, userService);
            break;
        case "deletefl":
            handleDeleteUserFromList(request, response, session, userService);
            break;
        case "listAll":
            handleListAllUsers(request, response, userService);
            break;
        case "logout":
            handleLogout(request, response, session);
            break;
        default:
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            break;
    }
%>
<%!
    // Metodo para mostrar el formulario de login
    private void handleLogin(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        session.invalidate();  // Cerramos la sesión existente
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/login.jsp");
    }

    // Método para autenticar el usuario
    private void handleAuthenticate(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User loggedInUser = userService.loginUser(email, password);
            session.setAttribute("loggedInUser", loggedInUser);  // Guardamos el usuario en la sesión
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/login.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos. Inténtelo de nuevo." + e.getMessage() );
            request.getRequestDispatcher("/Views/Forms/Users/login.jsp").forward(request, response);
        }
    }

// Mostrar el formulario para crear un usuario
    private void showCreateUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/create.jsp");
    }

// Método para crear un nuevo usuario (después de enviar el formulario)
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response, UserService userService)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String rol = request.getParameter("rol");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        String estado = request.getParameter("estado");
        String fecha_registro = request.getParameter("fecha_registro");

        try {
            userService.createUser(id, password, nombre, apellidos, rol, email, telefono, estado, fecha_registro);
            request.setAttribute("successMessage", "Usuario creado exitosamente.");
            handleListAllUsers(request, response, userService);
        } catch (DuplicateUserException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/create.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos. Inténtelo de nuevo.");
            request.getRequestDispatcher("/Views/Forms/Users/create.jsp").forward(request, response);
        }
    }

// Mostrar el formulario para editar un usuario
    private void showFindForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
    }

// Método para buscar un usuario
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        String searchId = request.getParameter("id");

        try {
            User user = userService.getUserById(searchId);
            session.setAttribute("searchedUser", user);  // Guardamos el usuario en la sesión
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            session.removeAttribute("searchedUser"); // Limpiamos la sesión si no se encuentra el usuario
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        }
    }

// Mostrar el formulario para editar un usuario
    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        try {
            User user = userService.getUserById(id);
            session.setAttribute("userToEdit", user);  // Guardamos el usuario en sesión
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos.");
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        }
    }

    // Método para actualizar los datos del usuario
    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        User searchedUser = (User) session.getAttribute("searchedUser");

        if (searchedUser == null) {
            request.setAttribute("errorMessage", "Primero debe buscar un usuario para editar.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
            return;
        }

        String id = searchedUser.getId();
        String password = request.getParameter("password");
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String rol = request.getParameter("rol");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        String estado = request.getParameter("estado");
        String fecha_registro = request.getParameter("fecha_registro");

        try {
            userService.updateUser(id, password, nombre, apellidos, rol, email, telefono, estado, fecha_registro);
            request.setAttribute("successMessage", "Usuario actualizado exitosamente.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        }
    }

    private void handleDeleteUserFromList(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            request.setAttribute("errorMessage", "El código es requerido");
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
            return;
        }
        try {
            userService.deleteUser(id);
            session.removeAttribute("searchedUser");
            request.setAttribute("successMessage", "Usuario eliminado exitosamente.");
            handleListAllUsers(request, response, userService);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            handleListAllUsers(request, response, userService);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos.");
            handleListAllUsers(request, response, userService);
        }
    }

// Método para eliminar un usuario
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, UserService userService)
            throws ServletException, IOException {
        User searchedUser = (User) session.getAttribute("searchedUser");
        if (searchedUser == null) {
            request.setAttribute("errorMessage", "Primero debe buscar un usuario para eliminar.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
            return;
        }

        String id = searchedUser.getId();  // Usamos el código del usuario buscado

        try {
            userService.deleteUser(id);
            session.removeAttribute("searchedUser");
            request.setAttribute("successMessage", "Usuario eliminado exitosamente.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
        }
    }

    // Método para listar todos los usuarios
    private void handleListAllUsers(HttpServletRequest request, HttpServletResponse response, UserService userService)
            throws ServletException, IOException {
        try {
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos al listar usuarios.");
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        }
    }

    // Método para cerrar sesión
    private void handleLogout(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        session.invalidate();  // Invalida la sesión actual
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/login.jsp");
    }
%>