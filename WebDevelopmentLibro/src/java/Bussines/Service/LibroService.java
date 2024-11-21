/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Bussines.Service;

import Domain.Model.Libro;
import Bussines.Exceptions.LibroNotFoundException;
import Bussines.Exceptions.DuplicateLibroException;
import Infrastructure.Persistence.LibroCRUD;
import java.sql.SQLException;

import java.util.List;

/**
 *
 * @author María Fernanda Ochoa
 */
public class LibroService {

    private LibroCRUD libroCrud;

    // Constructor
    public LibroService() {
        this.libroCrud = new LibroCRUD();
    }

    // Método para obtener todos los usuarios
    public List<Libro> getAllLibros() throws SQLException {
        return libroCrud.getAllLibros();
    }

    // Método para agregar un nuevo usuario
    public void createLibro(int id, String titulo, int paginas, float precio, int usuario_id, String fecha_publicacion)
            throws DuplicateLibroException, SQLException {
        Libro libro = new Libro(id, titulo, paginas, precio, usuario_id, fecha_publicacion);
        libroCrud.addLibro(libro);
    }

    // Método para actualizar un usuario
    public void updateLibro(int id, String titulo, int paginas, float precio, int usuario_id, String fecha_publicacion)
            throws LibroNotFoundException, SQLException {
        Libro libro = new Libro(id, titulo, paginas, precio, usuario_id, fecha_publicacion);
        libroCrud.updateLibro(libro);
    }

    // Método para eliminar un usuario
    public void deleteLibro(String id) throws LibroNotFoundException, SQLException {
        libroCrud.deleteLibro(id);
    }

// Método para obtener un usuario por código
    public Libro getLibroById(String id) throws LibroNotFoundException, SQLException {
        return libroCrud.getLibroById(id);
    }

}
