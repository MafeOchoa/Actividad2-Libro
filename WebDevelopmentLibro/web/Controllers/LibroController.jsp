<%-- 
    Document   : UserController
    Created on : 17/11/2024, 7:05:38 p. m.
    Author     : María Fernanda Ochoa
--%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="Bussines.Exceptions.DuplicateLibroException"%>
<%@page import="java.io.IOException"%> <!-- IMPORTACIÓN DE IOException -->
<%@page import="jakarta.servlet.*"%> <!-- IMPORTACIÓN DE ServletException -->
<%@page import="Bussines.Service.LibroService"%>
<%@page import="Domain.Model.User"%>
<%@page import="Bussines.Exceptions.UserNotFoundException"%>
<%@page import="Bussines.Exceptions.DuplicateLibroException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    LibroService libroService = new LibroService();
    String action = request.getParameter("action");

    if (action == null) {
        action = "list";
    }

    switch (action) {
        case "showCreateForm":
            showCreateUserForm(request, response);
            break;
        case "create":
            handleCreateLibro(request, response, libroService);
            break;
        case "showFindForm":
            showFindForm(request, response, session, libroService);
            break;
        case "search":
            handleSearch(request, response, session, libroService);
            break;
        case "update":
            handleUpdateUser(request, response, session, libroService);
            break;
        case "delete":
            handleDeleteUser(request, response, session, libroService);
            break;
        case "deletefl":
            handleDeleteUserFromList(request, response, session, libroService);
            break;
        case "listAll":
            handleListAllUsers(request, response, libroService);
            break;
        default:
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            break;
    }
%>
<%!
// Mostrar el formulario para crear un usuario
    private void showCreateUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Views/Forms/Users/create.jsp");
    }

// Método para crear un nuevo usuario (después de enviar el formulario)
    private void handleCreateLibro(HttpServletRequest request, HttpServletResponse response, LibroService libroService)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String titulo = request.getParameter("titulo");
        String paginas = request.getParameter("paginas");
        String precio = request.getParameter("precio");
        String usuario_id = request.getParameter("usuario_id");
        String fecha_publicacion = request.getParameter("fecha_publicacion");

        try {
            libroService.createLibro(Integer.parseInt(id), titulo, Integer.parseInt(paginas), Float.parseFloat(precio), Integer.parseInt(usuario_id), fecha_publicacion);
            request.setAttribute("successMessage", "Libro creado exitosamente.");
            handleListAllUsers(request, response, libroService);
        } catch (DuplicateLibroException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/Views/Forms/Libros/create.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos. Inténtelo de nuevo.");
            request.getRequestDispatcher("/Views/Forms/Libros/create.jsp").forward(request, response);
        }
    }

// Mostrar el formulario para editar un usuario
    private void showFindForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, LibroService libroService)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/Forms/Libros/find_edit_delete.jsp").forward(request, response);
    }

// Método para buscar un usuario
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, HttpSession session, LibroService libroService)
            throws ServletException, IOException {
        String searchId = request.getParameter("id");

        try {
            User user = libroService.getUserById(searchId);
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
    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response, HttpSession session, LibroService libroService)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        try {
            User user = libroService.getUserById(id);
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
    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, LibroService libroService)
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
            libroService.updateUser(id, password, nombre, apellidos, rol, email, telefono, estado, fecha_registro);
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

    private void handleDeleteUserFromList(HttpServletRequest request, HttpServletResponse response, HttpSession session, LibroService libroService)
            throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            request.setAttribute("errorMessage", "El código es requerido");
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
            return;
        }
        try {
            libroService.deleteUser(id);
            session.removeAttribute("searchedUser");
            request.setAttribute("successMessage", "Usuario eliminado exitosamente.");
            handleListAllUsers(request, response, libroService);
        } catch (UserNotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            handleListAllUsers(request, response, libroService);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos.");
            handleListAllUsers(request, response, libroService);
        }
    }

// Método para eliminar un usuario
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, HttpSession session, LibroService libroService)
            throws ServletException, IOException {
        User searchedUser = (User) session.getAttribute("searchedUser");
        if (searchedUser == null) {
            request.setAttribute("errorMessage", "Primero debe buscar un usuario para eliminar.");
            request.getRequestDispatcher("/Views/Forms/Users/find_edit_delete.jsp").forward(request, response);
            return;
        }

        String id = searchedUser.getId();  // Usamos el código del usuario buscado

        try {
            libroService.deleteUser(id);
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
    private void handleListAllUsers(HttpServletRequest request, HttpServletResponse response, LibroService libroService)
            throws ServletException, IOException {
        try {
            List<User> users = libroService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error de base de datos al listar usuarios.");
            request.getRequestDispatcher("/Views/Forms/Users/list_all.jsp").forward(request, response);
        }
    }
%>