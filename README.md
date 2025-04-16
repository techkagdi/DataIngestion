# 📊 ClickHouse Data Management Web App (Java EE + JSP)

This web application enables users to **import and export data** between **ClickHouse tables** and **flat files (CSV)** through an intuitive, browser-based interface. Built using **Java Servlets and JSP**, the project demonstrates backend logic integration with dynamic UI handling, making it a practical solution for ETL-style data management.



---

## ✅ Features

- 🔁 **Import flat files to ClickHouse tables**
- 📤 **Export ClickHouse tables to CSV**
- 🧩 **Select data source** (ClickHouse or Flat File)
- 📑 **Dynamically load ClickHouse tables and columns**
- 👁️ **Preview selected data** before ingestion
- 📈 **Display status and results with live feedback**
- 📱 **Responsive user interface**

---

## 💻 Tech Stack

| Technology     | Description                     |
|----------------|---------------------------------|
| Java Servlets  | Backend logic (HttpServlets)    |
| JSP            | UI templating                   |
| HTML/CSS/JS    | Frontend behavior and layout    |
| ClickHouse     | Columnar database (via Docker)  |
| JDBC Driver    | Connect Java to ClickHouse      |
| Apache NetBeans| IDE for development             |

---

## 📁 Project Structure

clickhouse-data-manager/ │ ├── src/ │ ├── servlets/ │ │ ├── FileToClickHouseServlet.java │ │ ├── ClickHouseToFileServlet.java │ │ ├── ListClickHouseTablesServlet.java │ │ ├── LoadClickHouseColumnsServlet.java │ │ └── PreviewServlet.java │ ├── web/ │ ├── index.jsp │ ├── filetoclickhouse.jsp │ ├── clickhousetofile.jsp │ └── manage_data.jsp │ ├── resources/ │ └── sample_data.csv │ ├── prompt.txt # Full list of AI prompts used └── README.md # Project documentation



---

## 🚀 How to Run Locally

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/clickhouse-data-manager.git
cd clickhouse-data-manager
```
---

### 3. Configure JDBC Connection
## Ensure the servlet uses the correct JDBC URL:

-jdbc:clickhouse://localhost:8123/default

---

## 🧠 Application Workflow
### Step-by-Step UI Flow:
-Select Data Source
-Choose between "ClickHouse Table" or "Flat File"
-Load tables dynamically from ClickHouse via list-clickhouse-tables
-Select Columns
-Fetch columns for the selected table
-Display as checkbox list
-Preview Data
-Preview selected columns via PreviewServlet
-Ingest/Export
-Start ingestion or export process
-View live status and record count

--- 

## 📌 Notes
-Ensure Docker is running and ports 8123/9000 are open.

-Data preview only shows limited records (can be adjusted in the servlet).

-Make sure to set correct file paths and permissions when using flat files.
