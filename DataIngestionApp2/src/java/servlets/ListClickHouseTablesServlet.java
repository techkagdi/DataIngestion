/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/list-clickhouse-tables")
public class ListClickHouseTablesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Update these as per your ClickHouse config
    private static final String JDBC_URL = "jdbc:clickhouse://localhost:8123/default";
    private static final String JDBC_USER = "default";
    private static final String JDBC_PASSWORD = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        JSONArray tableArray = new JSONArray();

        try { Class.forName("com.clickhouse.jdbc.ClickHouseDriver");
Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SHOW TABLES"); {
        
            while (rs.next()) {
                tableArray.put(rs.getString(1));
            }

            JSONObject result = new JSONObject();
            result.put("tables", tableArray);
            out.print(result.toString());

        }} catch (Exception e) {
            JSONObject error = new JSONObject();
            error.put("error", "Error retrieving tables: " + e.getMessage());
            out.print(error.toString());
        }

        out.flush();
    }
}
