package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class PreviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Update to match your ClickHouse config
    private static final String JDBC_URL = "jdbc:clickhouse://localhost:8123/default";
    private static final String JDBC_USER = "default";
    private static final String JDBC_PASSWORD = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String tableName = request.getParameter("table");
        String[] columns = request.getParameterValues("selectedColumns");

        if (tableName == null || columns == null || columns.length == 0) {
            out.println("<p style='color:red;'>❌ Missing table or column selections.</p>");
            return;
        }

        try {
            Class.forName("com.clickhouse.jdbc.ClickHouseDriver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            List<String> columnList = Arrays.asList(columns);
            String colNames = String.join(", ", columnList);

            String query = "SELECT " + colNames + " FROM " + tableName + " LIMIT 10";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            ResultSetMetaData meta = rs.getMetaData();
            int colCount = meta.getColumnCount();

            // Start table
            out.println("<table border='1' cellpadding='5'><thead><tr>");
            for (String col : columnList) {
                out.println("<th>" + col + "</th>");
            }
            out.println("</tr></thead><tbody>");

            while (rs.next()) {
                out.println("<tr>");
                for (int i = 1; i <= colCount; i++) {
                    String value = rs.getString(i);
                    out.println("<td>" + (value != null ? value : "") + "</td>");
                }
                out.println("</tr>");
            }

            out.println("</tbody></table>");

        } catch (Exception e) {
            out.println("<p style='color:red;'>❌ Failed to preview data: " + e.getMessage() + "</p>");
        }

    }
}
