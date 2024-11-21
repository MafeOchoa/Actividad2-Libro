/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Bussines.Service;

import Domain.Model.User;
import Bussines.Exceptions.UserNotFoundException;
import Bussines.Exceptions.DuplicateUserException;
import Infrastructure.Persistence.UserCRUD;
import java.sql.SQLException;

import java.util.List;

/**
 *
 * @author María Fernanda Ochoa
 */
public class UserService {

    private UserCRUD userCrud;

    // Constructor
    public UserService() {
        this.userCrud = new UserCRUD();
    }

    // Método para obtener todos los usuarios
    public List<User> getAllUsers() throws SQLException {
        return userCrud.getAllUsers();
    }

    // Método para agregar un nuevo usuario
    public void createUser(String id, String password, String nombre, String apellidos, String rol, String email, String telefono, String estado, String fecha_registro)
            throws DuplicateUserException, SQLException {
        User user = new User(id, password, nombre, apellidos, rol, email, telefono, estado, fecha_registro);
        userCrud.addUser(user);
    }

    // Método para actualizar un usuario
    public void updateUser(String id, String password, String nombre, String apellidos, String rol, String email, String telefono, String estado, String fecha_registro)
            throws UserNotFoundException, SQLException {
        User user = new User(id, password, nombre, apellidos, rol, email, telefono, estado, fecha_registro);
        userCrud.updateUser(user);
    }

    // Método para eliminar un usuario
    public void deleteUser(String id) throws UserNotFoundException, SQLException {
        userCrud.deleteUser(id);
    }

// Método para obtener un usuario por código
    public User getUserById(String id) throws UserNotFoundException, SQLException {
        return userCrud.getUserById(id);
    }

// Método para autenticar un usuario (login)
    public User loginUser(String email, String password) throws UserNotFoundException, SQLException {
        // Usamos el nuevo método getUserByEmail en lugar de obtener todos los usuarios
        User user = userCrud.getUserByEmail(email);

        if (user != null && user.getPassword().equals(password)) {
            return user;
        } else {
            throw new UserNotFoundException("Credenciales incorrectas. No se encontró el usuario o la contraseña es incorrecta.");
        }
    }

// Método para buscar usuarios por nombre o email
    public List<User> searchUsers(String searchTerm) {
        return userCrud.searchUsers(searchTerm);
    }

}
