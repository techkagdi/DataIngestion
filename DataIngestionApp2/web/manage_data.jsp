<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Data</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f9f9f9; }
        .section { margin-bottom: 20px; background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        label, select, input[type="text"] { margin: 10px 0; display: block; width: 100%; }
        button, input[type="submit"] {
            padding: 10px 20px; margin: 10px 5px 0 0;
            background-color: #007bff; color: white;
            border: none; border-radius: 5px; cursor: pointer;
        }
        button:hover, input[type="submit"]:hover { background-color: #0056b3; }
        #statusArea, #resultArea { margin-top: 15px; font-style: italic; color: #333; }
        #columnList label { display: inline-block; width: 30%; margin-bottom: 10px; }
    </style>
</head>
<body>

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
    <form id="previewForm" action="PreviewServlet" method="post">
        <div id="columnList"></div>
        <input type="hidden" id="previewTable" name="table" />
        <input type="submit" value="Preview Selected Columns" />
    </form>
</div>

<div class="section">
    <h2>Step 3: Actions</h2>
    <button onclick="startIngestion()">Start Ingestion</button>
    <div id="resultArea"></div>
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
    .then(res => {
        if (!res.ok) throw new Error("HTTP status " + res.status);
        return res.json();
    })
    .then(data => {
        const container = document.getElementById("columnList");
        container.innerHTML = "";
         if (Array.isArray(data.columns)) {
            data.columns.forEach(col => {
                const label = document.createElement("label");
              console.log(col);
                label.innerHTML = `<input type="checkbox" name="selectedColumns" value="${col}" checked> ${col}`;
                container.appendChild(label);
                container.appendChild(document.createElement("br"));
            });}
        document.getElementById("columnSection").style.display = "block";
        document.getElementById("previewTable").value = table;
        document.getElementById("statusArea").innerText = "✅ Columns loaded.";
    })
    .catch(err => {
        document.getElementById("statusArea").innerText = "❌ Failed to load columns: " + err.message;
    });
}

function startIngestion() {
    document.getElementById("resultArea").innerText = "🚀 Ingestion process started...";
}
</script>

</body>
</html>
