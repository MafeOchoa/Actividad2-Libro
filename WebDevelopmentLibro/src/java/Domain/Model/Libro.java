/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Domain.Model;

/**
 *
 * @author María Fernanda Ochoa
 */
public class Libro {

    private int id;
    private String titulo;
    private int paginas;
    private float precio;
    private int usuario_id;
    private String fecha_publicacion;

    public Libro(int id, String titulo, int paginas, float precio, int usuario_id, String fecha_publicacion) {
        this.id = id;
        this.titulo = titulo;
        this.paginas = paginas;
        this.precio = precio;
        this.usuario_id = usuario_id;
        this.fecha_publicacion = fecha_publicacion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public int getPaginas() {
        return paginas;
    }

    public void setPaginas(int paginas) {
        this.paginas = paginas;
    }

    public float getPrecio() {
        return precio;
    }

    public void setPrecio(float precio) {
        this.precio = precio;
    }

    public int getUsuario_id() {
        return usuario_id;
    }

    public void setUsuario_id(int usuario_id) {
        this.usuario_id = usuario_id;
    }

    public String getFecha_publicacion() {
        return fecha_publicacion;
    }

    public void setFecha_publicacion(String fecha_publicacion) {
        this.fecha_publicacion = fecha_publicacion;
    }

}
