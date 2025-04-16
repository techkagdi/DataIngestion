<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Flat File to ClickHouse</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        label { display: block; margin-top: 10px; }
        .btn { margin-top: 15px; padding: 10px 20px; background: #007bff; color: white; border: none; }
    </style>
</head>
<body>
    <h2>Flat File ➡ ClickHouse Import</h2>

    <form action="FileToClickHouseServlet" method="post" enctype="multipart/form-data">
        <!-- Step 1: ClickHouse Connection Info -->
        <h4>ClickHouse Connection</h4>
        <label>Host: <input type="text" name="host" value="localhost" required></label>
        <label>Port: <input type="text" name="port" value="8123" required></label>
        <label>Database: <input type="text" name="database" value="default" required></label>
        <label>User: <input type="text" name="user" value="default" required></label>
        <label>Password: <input type="password" name="password"></label>

        <!-- Step 2: File Upload -->
        <h4>Flat File Upload</h4>
        <label>Select CSV File: <input type="file" name="csvFile" accept=".csv" required></label>
        <label>Delimiter: <input type="text" name="delimiter" value="," required></label>
        <label>New Table Name: <input type="text" name="tableName" placeholder="my_table" required></label>

        <input class="btn" type="submit" value="Upload to ClickHouse">
    </form>

    <p style="color:red;"><%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %></p>
    <p style="color:green;"><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %></p>
</body>
</html>
