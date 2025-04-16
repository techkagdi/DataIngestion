package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class ClickHouseToFileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String host = request.getParameter("host");
        String port = request.getParameter("port");
        String database = request.getParameter("database");
        String user = request.getParameter("user");
        String password = request.getParameter("password");
        String tableName = request.getParameter("tableName");
        String fileName = request.getParameter("fileName");

        String jdbcUrl = "jdbc:clickhouse://" + host + ":" + port + "/" + database;

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        PrintWriter fileWriter = null;

        try {
            Class.forName("com.clickhouse.jdbc.ClickHouseDriver");
            conn = DriverManager.getConnection(jdbcUrl, user, password);

            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM " + tableName);

            // Write result to CSV
            File file = new File(getServletContext().getRealPath("/") + fileName);
            fileWriter = new PrintWriter(new FileWriter(file));

            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            // Write header
            for (int i = 1; i <= columnCount; i++) {
                fileWriter.print(metaData.getColumnLabel(i));
                if (i < columnCount) fileWriter.print(",");
            }
            fileWriter.println();

            // Write rows
            int rowCount = 0;
            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    fileWriter.print(rs.getString(i));
                    if (i < columnCount) fileWriter.print(",");
                }
                fileWriter.println();
                rowCount++;
            }

            fileWriter.flush();

            request.setAttribute("successMessage", "✅ Data exported successfully! Records: " + rowCount + "<br>Saved as: " + fileName);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "❌ Export Failed: " + e.getMessage());
        } finally {
            try { if (fileWriter != null) fileWriter.close(); } catch (Exception ignored) {}
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("clickhouse_to_file.jsp").forward(request, response);
    }
}
