/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Domain.Model;

/**
 *
 * @author María Fernanda Ochoa
 */
public class User {
    
    private String id; 
    private String password; 
    private String nombre; 
    private String apellidos; 
    private String rol;
    private String email; 
    private String telefono; 
    private String estado;
    private String fecha_registro;

    public User(String id, String password, String nombre, String apellidos, String rol, String email, String telefono, String estado, String fecha_registro) {
        this.id = id;
        this.password = password;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.rol = rol;
        this.email = email;
        this.telefono = telefono;
        this.estado = estado;
        this.fecha_registro = fecha_registro;
    }

    
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getFecha_registro() {
        return fecha_registro;
    }

    public void setFecha_registro(String fecha_registro) {
        this.fecha_registro = fecha_registro;
    }
    
    
    
}
