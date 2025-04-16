<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Data</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f5f7fa;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 960px;
                margin: auto;
                padding: 20px;
                overflow-x: hidden;
            }
            .section {
                background: #fff;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }
            h2, h3 {
                margin-top: 0;
                color: #333;
            }
            label {
                font-weight: bold;
                margin-bottom: 5px;
                display: block;
            }
            select, input[type="text"] {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-size: 14px;
            }
            button, input[type="button"] {
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s;
                font-size: 14px;
            }
            button:hover, input[type="button"]:hover {
                background-color: #0056b3;
            }
            #statusArea, #resultArea {
                margin-top: 15px;
                font-style: italic;
                color: #333;
            }
            #columnList label {
                display: block;
                margin-bottom: 10px;
            }
            #columnList input[type="checkbox"] {
                margin-right: 8px;
            }
            #resultArea {
                overflow-x: auto;
            }
            #resultArea table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                font-size: 14px;
            }
            #resultArea th, #resultArea td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
            }
            #resultArea th {
                background-color: #f2f2f2;
                font-weight: bold;
            }
            #resultArea tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            #resultArea tr:hover {
                background-color: #eef;
            }
            .loader {
                border: 4px solid #f3f3f3;
                border-top: 4px solid #007bff;
                border-radius: 50%;
                width: 20px;
                height: 20px;
                animation: spin 1s linear infinite;
                display: inline-block;
                margin-right: 10px;
            }
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
            
            
            
            
            
            @media (max-width: 600px) {
                button, input[type="button"] {
                    width: 100%;
                    margin-top: 10px;
                }
                #resultArea table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
            }
            
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
        <div class="container">
            
            <div class="section">
                <h2>Page to View Table Column And preview Data According to Selected Column</h2>
               
            </div>
            
            <div class="section">
                <h2>Step 1: Select Data Source</h2>
                <label for="sourceType">Source Type:</label>
                <select id="sourceType" onchange="onSourceChange()">
                    <option value="clickhouse">ClickHouse Table</option>
                    <option value="file" selected>Flat File</option>
                </select>

                <div id="clickhouseInput" style="display: none;">
                    <label for="clickhouseTable">ClickHouse Table:</label>
                    <select id="clickhouseTable" onchange="loadColumns()"></select>
                </div>

                <div id="fileInput">
                    <label for="flatFileName">Flat File Name:</label>
                    <input type="text" id="flatFileName" placeholder="e.g. data.csv" />
                </div>

                <div id="statusArea"></div>
            </div>

            <div class="section" id="columnSection" style="display: none;">
                <h3>Step 2: Select Columns</h3>
                <div id="columnList"></div>
                <input type="hidden" id="previewTable" name="table" />
                <input type="button" value="Preview Selected Columns" onclick="previewData()" />
            </div>

            <div class="section">
                <h2>Step 3: Actions</h2>  <div id="resultArea"></div>
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
              
            </div>
        </div>

        <script>
            function onSourceChange() {
                const type = document.getElementById("sourceType").value;
                document.getElementById("fileInput").style.display = type === "file" ? "block" : "none";
                document.getElementById("clickhouseInput").style.display = type === "clickhouse" ? "block" : "none";
                if (type === "clickhouse") loadTables();
            }

            function loadTables() {
                document.getElementById("statusArea").innerText = "🔄 Loading tables...";
                fetch("list-clickhouse-tables")
                    .then(res => res.json())
                    .then(data => {
                        const select = document.getElementById("clickhouseTable");
                        select.innerHTML = "";
                        data.tables.forEach(table => {
                            const opt = document.createElement("option");
                            opt.value = table;
                            opt.text = table;
                            select.appendChild(opt);
                        });
                        document.getElementById("statusArea").innerText = "✅ Tables loaded.";
                        if (select.options.length > 0) {
                            select.selectedIndex = 0;
                            loadColumns();
                        }
                    })
                    .catch(() => {
                        document.getElementById("statusArea").innerText = "❌ Failed to load tables.";
                    });
            }

            function loadColumns() {
                const table = document.getElementById("clickhouseTable").value;
                if (!table) return;

                document.getElementById("statusArea").innerText = "🔄 Loading columns...";
                fetch("load-clickhouse-columns", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: "table=" + encodeURIComponent(table)
                })
                    .then(res => res.json())
                    .then(data => {
                        const container = document.getElementById("columnList");
                        container.innerHTML = "";

                        if (Array.isArray(data.columns)) {
                            data.columns.forEach(col => {
                                if (col) {
                                    const label = document.createElement("label");
                                    const checkbox = document.createElement("input");
                                    checkbox.type = "checkbox";
                                    checkbox.name = "selectedColumns";
                                    checkbox.value = col;
                                    checkbox.checked = true;
                                    label.appendChild(checkbox);
                                    label.appendChild(document.createTextNode(col));
                                    container.appendChild(label);
                                }
                            });
                        }

                        document.getElementById("columnSection").style.display = "block";
                        document.getElementById("previewTable").value = table;
                        document.getElementById("statusArea").innerText = "✅ Columns loaded.";
                    })
                    .catch(err => {
                        document.getElementById("statusArea").innerText = "❌ Failed to load columns: " + err.message;
                    });
            }

            function previewData() {
                const table = document.getElementById("clickhouseTable").value;
                const checkboxes = document.querySelectorAll("input[name='selectedColumns']:checked");
                const columns = Array.from(checkboxes).map(cb => cb.value);

                if (columns.length === 0 || !table) {
                    document.getElementById("resultArea").innerText = "⚠️ Please select table and at least one column.";
                    return;
                }

                const formData = new URLSearchParams();
                formData.append("sourceType", "clickhouse");
                formData.append("table", table);
                columns.forEach(col => formData.append("selectedColumns", col));

                document.getElementById("resultArea").innerHTML = "<div class='loader'></div> Previewing data...";

                fetch("PreviewServlet", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: formData.toString()
                })
                .then(response => response.text())
                .then(html => {
                    document.getElementById("resultArea").innerHTML = html;
                })
                .catch(err => {
                    document.getElementById("resultArea").innerText = "❌ Error previewing: " + err.message;
                });
            }

            function startIngestion() {
                document.getElementById("resultArea").innerText = "🚀 Ingestion process started...";
            }
        </script>
    </body>
</html>