/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Infrastructure.Persistence;

import Bussines.Exceptions.DuplicateLibroException;
import Bussines.Exceptions.LibroNotFoundException;
import Domain.Model.Libro;
import Infrastructure.Database.ConnectionDbMysql;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author María Fernanda Ochoa
 */
public class LibroCRUD {

    public List<Libro> getAllLibros() {
        List<Libro> userList = new ArrayList<>();
        String query = "SELECT * FROM tablalibro";
        try {
            Connection con = ConnectionDbMysql.getConnection();

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                userList.add(
                        new Libro(
                                rs.getInt("id"),
                                rs.getString("titulo"),
                                rs.getInt("paginas"),
                                rs.getFloat("precio"),
                                rs.getInt("usuario_id"),
                                rs.getString("fecha_publicacion"))
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    public void addLibro(Libro libro) throws SQLException, DuplicateLibroException {
        String query = "INSERT INTO tablalibro (id, titulo, paginas, precio, usuario_id, fecha_publicacion) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setInt(1, libro.getId());
            stmt.setString(2, libro.getTitulo());
            stmt.setInt(3, libro.getPaginas());
            stmt.setFloat(4, libro.getPrecio());
            stmt.setInt(5, libro.getUsuario_id());
            stmt.setString(6, libro.getFecha_publicacion());

            stmt.executeUpdate();
        } catch (SQLException e) {

            if (e.getErrorCode() == 1062) {
                throw new DuplicateLibroException("El libro con el id ya existe.");
            } else {
                throw e;
            }
        }
    }

// Método para actualizar un libro
    public void updateLibro(Libro libro) throws SQLException, LibroNotFoundException {
        //         String query = "INSERT INTO tablalibro (id, titulo, paginas, precio, usuario_id, fecha_publicacion) VALUES (?, ?, ?, ?, ?, ?)";

        String query = "UPDATE tablalibro SET titulo=?, paginas=?, precio=?, usuario_id=?, fecha_publicacion=? WHERE id=?";

        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, libro.getTitulo());
            stmt.setInt(2, libro.getPaginas());
            stmt.setFloat(3, libro.getPrecio());
            stmt.setInt(4, libro.getUsuario_id());
            stmt.setString(5, libro.getFecha_publicacion());
            stmt.setInt(6, libro.getId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new LibroNotFoundException("El libro con el id " + libro.getId() + " no existe.");
            }
        } catch (SQLException e) {
            throw e;
        }
    }

    public Libro getLibroById(String id) throws SQLException, LibroNotFoundException {
        String query = "SELECT * FROM tablalibro WHERE id=?";
        Libro libro = null;

        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                libro = new Libro(
                    rs.getInt("id"),
                    rs.getString("titulo"),
                    rs.getInt("paginas"),
                    rs.getFloat("precio"),
                    rs.getInt("usuario_id"),
                    rs.getString("fecha_publicacion"));
            } else {
                throw new LibroNotFoundException("El libro con el Id " + id + " no existe.");
            }
        } catch (SQLException e) {
            throw e;
        }
        return libro;
    }

    public void deleteLibro(String id) throws SQLException, LibroNotFoundException {
        String query = "DELETE FROM tablalibro WHERE id=?";

        try (Connection con = ConnectionDbMysql.getConnection(); PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, id);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new LibroNotFoundException("El libro con el id " + id + " no existe.");
            }
        } catch (SQLException e) {
            throw e;
        }
    }

}
