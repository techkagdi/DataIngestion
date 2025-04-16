<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>ClickHouse to Flat File</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        label { display: block; margin-top: 10px; }
        .btn { margin-top: 15px; padding: 10px 20px; background: green; color: white; border: none; }
    </style>
</head>
<body>
    <h2>ClickHouse ➡ Flat File Export</h2>

    <form method="post" action="ClickHouseToFileServlet">
        <!-- Step 1: Connection Info -->
        <h4>Connection Details</h4>
        <label>Host: <input type="text" name="host" value="localhost" required></label>
        <label>Port: <input type="text" name="port" value="8123" required></label>
        <label>Database: <input type="text" name="database" value="default" required></label>
        <label>User: <input type="text" name="user" value="default" required></label>
        <label>Password: <input type="password" name="password"></label>

        <!-- Step 2: Table Name -->
        <label>Table Name: <input type="text" name="tableName" required></label>

        <!-- Step 3: Optional Output File Name -->
        <label>Output File Name (with .csv): <input type="text" name="fileName" value="output.csv" required></label>

        <!-- Step 4: Column Selection -->
        <!-- We will make this dynamic later -->
        <p><i>(After entering connection and table name, you'll select columns on next step.)</i></p>

        <input class="btn" type="submit" value="Export to Flat File">
    </form>

    <p style="color:red;"><%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %></p>
    <p style="color:green;"><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %></p>
</body>
</html>
