package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.*;
@WebServlet("/load-clickhouse-columns")
public class LoadClickHouseColumnsServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:clickhouse://localhost:8123/default";
    private static final String JDBC_USER = "default";
    private static final String JDBC_PASSWORD = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String tableName = request.getParameter("table");
        JSONArray columns = new JSONArray();

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("DESCRIBE TABLE " + tableName)) {

            while (rs.next()) {
                String columnName = rs.getString("name"); // or rs.getString(1);
                columns.put(columnName);
            }

            JSONObject result = new JSONObject();
            result.put("columns", columns);
            out.print(result.toString());

        } catch (Exception e) {
            JSONObject error = new JSONObject();
            error.put("error", "Error loading columns: " + e.getMessage());
            out.print(error.toString());
        }

        out.flush();
    }
}
