package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TestConnection extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.clickhouse.jdbc.ClickHouseDriver");

            String url = "jdbc:clickhouse:http://localhost:8123/default";

            Properties props = new Properties();
            props.setProperty("user", "default");
            props.setProperty("password", "");

            Connection conn = DriverManager.getConnection(url, props);

            if (conn != null) {
                out.println("✅ Connection Successful!");
                conn.close();
            } else {
                out.println("❌ Connection Failed.");
            }

        } catch (Exception e) {
            out.println("❌ Error: " + e.getMessage());
            e.printStackTrace(out);
        }
    }
}
