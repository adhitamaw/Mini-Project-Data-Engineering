# Mini Project Data Engineering — ETL Pipeline MySQL to PostgreSQL

A mini data engineering project that builds an **ELT pipeline** to extract data from a MySQL OLTP database (ClassicModels) and load it into a PostgreSQL Data Warehouse, followed by data modeling using a **Star Schema**.

---

## Architecture Overview

```
MySQL (OLTP)          Python ELT Pipeline         PostgreSQL (Data Warehouse)
┌─────────────┐       ┌──────────────────┐         ┌──────────────────────────┐
│ classicmodels│──────▶│  mysql_extractor │────────▶│  raw schema              │
│  - customers │       │  postgres_loader │         │  (all source tables)     │
│  - orders    │       │  etl.py          │         ├──────────────────────────┤
│  - products  │       └──────────────────┘         │  data_modelling schema   │
│  - employees │                                    │  - fact_orders           │
│  - payments  │                                    │  - fact_payments         │
│  - offices   │                                    │  - dim_customers         │
│  - orderdetails                                   │  - dim_products          │
│  - productlines                                   │  - dim_employees         │
└─────────────┘                                     │  - dim_offices           │
                                                    └──────────────────────────┘
```

---

## Project Structure

```
mini project data engineering/
├── etl.py                   # Main ELT pipeline orchestrator
├── mysql_extractor.py       # Extracts tables from MySQL
├── postgres_loader.py       # Loads DataFrames into PostgreSQL
├── requirements.txt         # Python dependencies
├── folder db/
│   └── mysqlsampledatabase.sql  # MySQL ClassicModels sample database dump
└── how to run/
    ├── langkah.txt          # Step-by-step instructions (Indonesian)
    ├── script 1.sql         # Create data_warehouse DB & transactional schema
    ├── script 2.sql         # Create third_party schema & ELT transformation example
    ├── script 3.sql         # Create classicmodels DB & tables in MySQL (OLTP setup)
    └── script 4.sql         # Create data_modelling schema, fact & dim tables + analytics queries
```

---

## Tech Stack & Tools

| Component          | Technology / Tool                        |
|-------------------|------------------------------------------|
| Source DB          | MySQL (via Laragon)                      |
| Target DB          | PostgreSQL                               |
| Language           | Python 3.x                               |
| Code Editor        | Visual Studio Code (VS Code)             |
| DB Client          | DBeaver                                  |
| Local Server Stack | Laragon (MySQL management)               |
| ORM / Connector    | SQLAlchemy                               |
| Data Processing    | Pandas                                   |
| DB Driver          | PyMySQL, Psycopg2                        |

---

## Prerequisites

- Python 3.8+
- MySQL running on `localhost:3307`
- PostgreSQL running on `localhost:5432`
- `data_warehouse` database created in PostgreSQL
- `raw` schema created inside `data_warehouse`
- `data_modelling` schema created inside `data_warehouse`

---

## Setup & Installation

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd "mini project data engineering"
```

### 2. Install Python dependencies

```bash
pip install -r requirements.txt
```

### 3. Setup MySQL (OLTP Source)

Run **script 3.sql** in MySQL to create the `classicmodels` database and all its tables:

```bash
mysql -u root -p < "how to run/script 3.sql"
```

Or import `folder db/mysqlsampledatabase.sql` directly using MySQL Workbench / DBeaver.

### 4. Setup PostgreSQL (Data Warehouse)

Run **script 1.sql** in PostgreSQL to create the `data_warehouse` database along with the required schemas:

```sql
-- Creates: data_warehouse database, transactional schema
-- Run in psql or any PostgreSQL client
\i 'how to run/script 1.sql'
```

Then manually create the needed schemas:

```sql
CREATE SCHEMA raw;
CREATE SCHEMA data_modelling;
```

---

## Database Configuration

Update the connection strings in the following files if your credentials differ:

**`mysql_extractor.py`**
```python
db_connection_str = 'mysql+pymysql://root:@localhost:3307/classicmodels'
#                                    user  pass  host   port  database
```

**`postgres_loader.py`**
```python
db_connection_str = 'postgresql://postgres:root@localhost:5432/data_warehouse'
#                                  user      pass  host   port  database
```

---

## Running the ELT Pipeline

```bash
python etl.py
```

This will:
1. Connect to MySQL `classicmodels` database
2. Extract all 8 tables: `customers`, `employees`, `offices`, `orderdetails`, `orders`, `payments`, `productlines`, `products`
3. Load each table into the `raw` schema of the PostgreSQL `data_warehouse` database

Expected output:
```
Extract table customers from MySQL successfully
table customers loaded to Postgres successfully
Extract table employees from MySQL successfully
table employees loaded to Postgres successfully
...
```

---

## Data Modeling (Star Schema)

After the pipeline runs successfully, execute **script 4.sql** in PostgreSQL to build the data warehouse model:

```sql
-- Creates fact and dimension tables in the data_modelling schema
\i 'how to run/script 4.sql'
```

### Fact Tables

| Table | Description |
|---|---|
| `fact_orders` | Order transactions joined with order details |
| `fact_payments` | Payment transactions |

### Dimension Tables

| Table | Description |
|---|---|
| `dim_customers` | Customer master data |
| `dim_products` | Product master data |
| `dim_productlines` | Product category/line data |
| `dim_employees` | Employee master data |
| `dim_offices` | Office/branch master data |

### Star Schema Diagram

```
                        dim_customers
                              │
dim_productlines ── dim_products
                              │
dim_employees ─── fact_orders ─── fact_payments
                              │
                        dim_offices
```

---

## Analytics Queries

Sample queries included in **script 4.sql**:

```sql
-- 1. Show each order transaction with its product name
SELECT "productName", "quantityOrdered"
FROM data_modelling.dim_products AS dp
LEFT JOIN data_modelling.fact_orders AS fo ON dp."productCode" = fo."productCode";

-- 2. Total quantity sold per product (top sellers)
SELECT "productName", SUM("quantityOrdered")
FROM data_modelling.dim_products AS dp
LEFT JOIN data_modelling.fact_orders AS fo ON dp."productCode" = fo."productCode"
GROUP BY "productName"
ORDER BY SUM("quantityOrdered") DESC;
```

---

## Source Dataset

This project uses the **MySQL Sample Database (ClassicModels)** — a classic dataset representing a scale model car retailer's database. It is widely used for learning and practicing SQL and data engineering.

- Download: [MySQL Tutorial Sample Database](https://www.mysqltutorial.org/mysql-sample-database.aspx)
- The SQL dump is also available in `folder db/mysqlsampledatabase.sql`

---

## License

This project is for educational purposes. The ClassicModels dataset is provided by [mysqltutorial.org](https://www.mysqltutorial.org).
