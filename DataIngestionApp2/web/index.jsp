<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>ClickHouse Ingestion Tool</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 40px; background: #f2f2f2; }
        h1 { color: #333; }
        .card {
            background: white;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        a.button {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h1>🛠 ClickHouse Bidirectional Ingestion Tool</h1>

    <div class="card">
        <h3>📤 Upload Flat File ➡ ClickHouse</h3>
        <p>Use this if you have a CSV file and want to store it in ClickHouse.</p>
        <a class="button" href="file_to_clickhouse.jsp">Go to Upload</a>
    </div>

    <div class="card">
        <h3>📥 Export ClickHouse ➡ Flat File</h3>
        <p>Export data from ClickHouse into a downloadable CSV file.</p>
        <a class="button" href="clickhouse_to_file.jsp">Go to Export</a>
    </div>
</body>
</html>
