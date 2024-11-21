/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Infrastructure.Database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author María Fernanda Ochoa
 */
public class ConnectionDbMysql {
    
    private static final String URL = "jdbc:mysql://localhost:3306/libreria"; 
    private static final String USER = "root"; 
    private static final String PASSWORD = "!Lucia14062000"; 
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    

    public static Connection getConnection ()throws SQLException{
        Connection connection = null;
        try {
            Class.forName(DRIVER);
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("Error: Driver Mysql no encontrado.");
        } catch (SQLException e) {
            e.printStackTrace();
         String message= "Error: no se pudo establecer conexion  a la base de datos.";
            throw new SQLException();

        }
        return connection;
    }

    }


