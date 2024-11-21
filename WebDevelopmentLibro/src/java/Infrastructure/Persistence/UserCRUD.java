/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Infrastructure.Persistence;

import Bussines.Exceptions.DuplicateUserException;
import Bussines.Exceptions.UserNotFoundException;
import Domain.Model.User;
import Infrastructure.Database.ConnectionDbMysql;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author María Fernanda Ochoa
 */
public class UserCRUD {

    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String query = "SELECT * FROM usuario";
        try {
            Connection con = ConnectionDbMysql.getConnection();

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                userList.add(
                        new User(
                                rs.getString("id"),
                                rs.getString("password"),
                                rs.getString("nombre"),
                                rs.getString("apellidos"),
                                rs.getString("rol"),
                                rs.getString("email"),
                                rs.getString("telefono"),
                                rs.getString("estado"),
                                rs.getString("fecha_registro"))
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    public void addUser(User user) throws SQLException, DuplicateUserException {
        String query = "INSERT INTO usuario (code, password, name, email) VALUES (?, ?, ?, ?)";
        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, user.getId());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getNombre());
            stmt.setString(4, user.getApellidos());
            stmt.setString(5, user.getRol());
            stmt.setString(6, user.getEmail());
            stmt.setString(7, user.getTelefono());
            stmt.setString(8, user.getEstado());
            stmt.setString(9, user.getFecha_registro());

            stmt.executeUpdate();
        } catch (SQLException e) {

            if (e.getErrorCode() == 1062) {
                throw new DuplicateUserException("El usuario con el código o email ya existe.");
            } else {
                throw e;
            }
        }
    }

// Método para actualizar un usuario
    public void updateUser(User user) throws SQLException, UserNotFoundException {
        String query = "UPDATE usuario SET password=?, nombre=?, apellidos=?, rol=?, email=?, telefono=?, Estado=?, fecha registro=?, WHERE id=?";

        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, user.getId());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getNombre());
            stmt.setString(4, user.getApellidos());
            stmt.setString(5, user.getRol());
            stmt.setString(6, user.getEmail());
            stmt.setString(7, user.getTelefono());
            stmt.setString(8, user.getEstado());
            stmt.setString(9, user.getFecha_registro());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new UserNotFoundException("El usuario con el código " + user.getId() + " no existe.");
            }
        } catch (SQLException e) {
            throw e;
        }
    }

    public User getUserById(String id) throws SQLException, UserNotFoundException {
        String query = "SELECT * FROM usuario WHERE id=?";
        User user = null;

        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User(rs.getString("id"),
                        rs.getString("password"),
                        rs.getString("nombre"),
                        rs.getString("apellidos"),
                        rs.getString("rol"),
                        rs.getString("email"),
                        rs.getString("telefono"),
                        rs.getString("estado"),
                        rs.getString("fecha_registro"));
            } else {
                throw new UserNotFoundException("El usuario con el Id " + id + " no existe.");
            }
        } catch (SQLException e) {
            throw e;
        }
        return user;
    }
    // Método para autenticar un usuario por email y contraseña (Login)

    public User getUserByEmailAndPassword(String email, String password) throws UserNotFoundException {
        User user = null;
        String query = "SELECT * "
                + "FROM Usuarios "
                + "WHERE email=? AND password=?";
        try {
            Connection con = ConnectionDbMysql.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);

            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User(rs.getString("id"),
                        rs.getString("password"),
                        rs.getString("nombre"),
                        rs.getString("apellidos"),
                        rs.getString("rol"),
                        rs.getString("email"),
                        rs.getString("telefono"),
                        rs.getString("estado"),
                        rs.getString("fecha_registro")
                );
            } else {
                String message = "Credenciales incorrectas. No se encontró el usuario.";
                throw new UserNotFoundException(message);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
    // Método para obtener un usuario por email

    public User getUserByEmail(String email) throws SQLException, UserNotFoundException {
        User user = null;
        String query = "SELECT * FROM usuario WHERE email=?";
        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User(rs.getString("id"),
                        rs.getString("password"),
                        rs.getString("nombre"),
                        rs.getString("apellidos"),
                        rs.getString("rol"),
                        rs.getString("email"),
                        rs.getString("telefono"),
                        rs.getString("estado"),
                        rs.getString("fecha_registro"));
            } else {
                throw new UserNotFoundException("El usuario con el email " + email + " no existe.");
            }
        }
        return user;
    }

// Método para buscar usuarios por nombre o email
    public List<User> searchUsers(String searchTerm) {
        List<User> userList = new ArrayList<>();
        String query = "SELECT * "
                + "FROM Usuarios "
                + "WHERE name LIKE ? OR email LIKE ?";

        try {
            Connection con = ConnectionDbMysql.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);

            stmt.setString(1, "%" + searchTerm + "%");
            stmt.setString(2, "%" + searchTerm + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                userList.add(
                        new User(rs.getString("id"),
                                rs.getString("password"),
                                rs.getString("nombre"),
                                rs.getString("apellidos"),
                                rs.getString("rol"),
                                rs.getString("email"),
                                rs.getString("telefono"),
                                rs.getString("estado"),
                                rs.getString("fecha_registro"))
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    public void deleteUser(String id) throws SQLException, UserNotFoundException {
        String query = "DELETE FROM Usuario WHERE id=?";

        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, id);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new UserNotFoundException("El usuario con el código " + id + " no existe.");
            }
        } catch (SQLException e) {
            throw e;
        }
    }

}
