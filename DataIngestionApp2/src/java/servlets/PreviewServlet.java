package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class PreviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String sourceType = request.getParameter("sourceType");
        String tableName = request.getParameter("tableName");
        String[] selectedColumns = request.getParameterValues("selectedColumns");

        if (sourceType.equals("ClickHouse")) {
            try {
                Class.forName("com.clickhouse.jdbc.ClickHouseDriver");
                Connection conn = DriverManager.getConnection("jdbc:clickhouse://localhost:8123/default");

                String columns = String.join(",", selectedColumns);
                String sql = "SELECT " + columns + " FROM " + tableName + " LIMIT 100";

                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                List<Map<String, String>> previewData = new ArrayList<>();
                ResultSetMetaData meta = rs.getMetaData();
                while (rs.next()) {
                    Map<String, String> row = new HashMap<>();
                    for (String col : selectedColumns) {
                        row.put(col, rs.getString(col));
                    }
                    previewData.add(row);
                }

                request.setAttribute("previewData", previewData);
                request.setAttribute("columnList", Arrays.asList(selectedColumns));
                request.getRequestDispatcher("manage_data.jsp").forward(request, response);
                
                rs.close();
                stmt.close();
                conn.close();

            } catch (Exception e) {
                request.setAttribute("error", "Error during preview: " + e.getMessage());
                request.getRequestDispatcher("manage_data.jsp").forward(request, response);
            }
        } else {
            // Flat File preview logic can be implemented here later
        }
    }
}
