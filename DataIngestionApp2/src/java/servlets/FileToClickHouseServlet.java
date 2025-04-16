package servlets;

import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig
public class FileToClickHouseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String host = request.getParameter("host");
        String port = request.getParameter("port");
        String database = request.getParameter("database");
        String user = request.getParameter("user");
        String password = request.getParameter("password");
        String delimiter = request.getParameter("delimiter");
        String tableName = request.getParameter("tableName");

        Part filePart = request.getPart("csvFile");

        String jdbcUrl = "jdbc:clickhouse://" + host + ":" + port + "/" + database;

        Connection conn = null;
        PreparedStatement pstmt = null;

        int rowCount = 0;

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream()))) {
            
            reader.mark(1);
if (reader.read() != 0xFEFF) {
    reader.reset(); // No BOM, rewind
}
            Class.forName("com.clickhouse.jdbc.ClickHouseDriver");
            conn = DriverManager.getConnection(jdbcUrl, user, password);

            // Read header line
            String headerLine = reader.readLine();
            if (headerLine == null) throw new Exception("Empty file.");
            String[] headers = headerLine.split(delimiter);

            // Infer data types as String for simplicity (ClickHouse uses String default if unspecified)
            StringBuilder createSQL = new StringBuilder("CREATE TABLE IF NOT EXISTS ")
                .append(tableName).append(" (");
            for (int i = 0; i < headers.length; i++) {
                createSQL.append(headers[i]).append(" String");
                if (i < headers.length - 1) createSQL.append(", ");
            }
            createSQL.append(") ENGINE = MergeTree() ORDER BY tuple()");

            // Create table
            Statement stmt = conn.createStatement();
            stmt.execute(createSQL.toString());

            // Prepare insert SQL
            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < headers.length; i++) {
                placeholders.append("?");
                if (i < headers.length - 1) placeholders.append(",");
            }

            String insertSQL = "INSERT INTO " + tableName + " VALUES (" + placeholders + ")";
            pstmt = conn.prepareStatement(insertSQL);

            String line;
            while ((line = reader.readLine()) != null) {
                String[] values = line.split(delimiter, -1); // allow empty strings
                for (int i = 0; i < headers.length; i++) {
                    pstmt.setString(i + 1, values.length > i ? values[i] : "");
                }
                pstmt.addBatch();
                rowCount++;
            }

            pstmt.executeBatch();

            request.setAttribute("successMessage", "✅ Upload successful! Records inserted: " + rowCount);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "❌ Upload failed: " + e.getMessage());
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("file_to_clickhouse.jsp").forward(request, response);
    }
}
