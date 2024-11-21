<%-- 
    Document   : find_edit_delete
    Created on : 17/11/2024, 7:10:14 p. m.
    Author     : María Fernanda Ochoa
--%>

<%@page import="Domain.Model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Buscar, Editar o Eliminar Usuario</title>
    <script>
        // Función: habilitar botones, Editar y Eliminar
        function enableButtons() {
            document.getElementById("editBtn").disabled = false;
            document.getElementById("deleteBtn").disabled = false;
        }

        // Función para deshabilitar los botones de Editar y Eliminar
        function disableButtons() {
            document.getElementById("editBtn").disabled = true;
            document.getElementById("deleteBtn").disabled = true;
        }

        // Función: cambiar acción del formulario y confirmar la eliminación
        function setActionAndSubmit(action, confirmMessage) {
            if (confirmMessage) {
                if (!confirm(confirmMessage)) {
                    return;
                }
            }

            document.getElementById("actionInput").value = action;
            document.getElementById("userForm").submit();
        }
    </script>
</head>
<body onload="<%= (session.getAttribute("searchedUser") != null) ? "enableButtons()" : "disableButtons()" %>">
<h1>Buscar, Editar o Eliminar Usuario</h1>

<%-- Mensajes de error o éxito --%>
<% if (request.getAttribute("errorMessage") != null) { %>
    <p style="color:red;"><%= request.getAttribute("errorMessage") %></p>
<% } %>

<% if (request.getAttribute("successMessage") != null) { %>
    <p style="color:green;"><%= request.getAttribute("successMessage") %></p>
<% } %>
</body>
</html>
<% if (request.getAttribute("successMessage") != null) { %>
    <p style="color:green;"><%= request.getAttribute("successMessage") %></p>
<% } %>

<%-- Formulario para buscar, editar y eliminar --%>
<form id="userForm" action="<%= request.getContextPath() %>/Controllers/UserController.jsp" method="post">
    <!-- El valor cambiará dinámicamente -->
    <input type="hidden" id="actionInput" name="action" value="search">

    <label for="searchCode">Código del usuario:</label><br>
    <input type="text" id="code" name="code" required value="
        <%= session.getAttribute("searchedUser") != null ? 
            ((User)session.getAttribute("searchedUser")).getId() 
            : "" %>">
    <br><br>

    <%-- Detalles del usuario (después de la búsqueda) --%>
    <% User sessionUser = (User) session.getAttribute("searchedUser"); %>

    <% if (sessionUser != null) { %>
        <h3>Detalles del Usuario</h3>
        <p><strong>Código:</strong> <%= sessionUser.getId() %></p>
        <p><strong>Nombre:</strong> <%= sessionUser.getNombre() %></p>
        <p><strong>Email:</strong> <%= sessionUser.getEmail() %></p>

        <label for="name">Nuevo Nombre:</label><br>
        <input type="text" id="name" name="name" value="<%= sessionUser.getNombre() %>" required>
        <br><br>

        <label for="email">Nuevo Email:</label><br>
        <input type="email" id="email" name="email" value="<%= sessionUser.getEmail() %>" required>
        <br>
        <br>
   
</form>
<label for="password">Nueva Contraseña:</label><br>
<input type="password" id="password" name="password" required><br><br>
<% } else { %>
    <p>No se ha buscado ningún usuario aún o el usuario no fue encontrado.</p>
<% } %>

<br>

<%-- Botones en la misma fila --%>
<button type="submit" onclick="setActionAndSubmit('search')" id="searchBtn">Buscar Usuario</button>
<button type="button" id="editBtn" disabled onclick="setActionAndSubmit('update', '¿Seguro que deseas editar este usuario?')">
    Editar Usuario
</button>
<button type="button" id="deleteBtn" disabled onclick="setActionAndSubmit('delete', '¿Seguro que deseas eliminar este usuario?')">
    Eliminar Usuario
</button>
</form>

<br>
<a href="<%= request.getContextPath() %>/index.jsp">MENU PRINCIPAL</a>


