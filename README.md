## 🏗️ Architecture Diagram

The data warehouse follows a Medallion-style architecture that integrates data from CRM and ERP source systems.

```mermaid
flowchart LR

    CRM[(CRM Source System)]
    ERP[(ERP Source System)]

    CRM --> B[🥉 Bronze Layer]
    ERP --> B

    B --> P[🔍 Data Profiling & Quality Checks]

    P --> S[🥈 Silver Layer]

    S --> C[🧹 Cleaning & Standardization]
    C --> R[📐 Business Rules & Data Integration]

    R --> G[🥇 Gold Layer]

    G --> D[⭐ Dimensional Model / Star Schema]

    D --> A[📊 Analytics & Reporting]


🥉 Bronze Layer

The Bronze layer stores raw data from the source systems with minimal transformation.

Main responsibilities:

Raw data ingestion
Source data preservation
Full refresh loading
Initial validation
Loading CRM and ERP datasets

Technologies and techniques:

SQL Server
T-SQL
BULK INSERT
Stored Procedures
🥈 Silver Layer

The Silver layer transforms raw data into clean, standardized, and integrated datasets.

Main responsibilities:

Data cleaning
Deduplication
Data type standardization
NULL handling
Date normalization
String standardization
Business rule validation
Source system integration

Examples of transformations include:

Removing unnecessary spaces
Standardizing gender and marital status values
Handling invalid dates
Correcting invalid sales values
Removing duplicate customer records
Standardizing product and customer identifiers
🥇 Gold Layer

The Gold layer contains business-ready analytical data.

It is designed using a dimensional modeling approach consisting of:

Dimension Tables
dim_customer
dim_product
dim_date
Fact Table
fact_sales

The Gold layer follows a Star Schema to simplify analytical queries and reporting.

🔄 ETL Flow

The project follows an ETL workflow that moves data from source systems into an analytical data warehouse.

ETL Process
1. Extract

Data is collected from two source systems:

CRM
ERP

The source data contains information related to:

Customers
Products
Sales
Locations
Categories
2. Load

Raw source data is loaded into the Bronze layer.

The Bronze layer maintains the original structure of the source data as much as possible.

3. Profile & Validate

The data is analyzed to identify potential data quality problems.

Examples:

Duplicate records
NULL values
Invalid dates
Unexpected values
Invalid customer identifiers
Invalid product identifiers
Incorrect sales calculations
Invalid relationships between entities
4. Transform

The Silver layer applies transformations such as:

Cleaning
Standardization
Deduplication
Data type conversion
Date conversion
Business rules
Data validation
5. Integrate

CRM and ERP datasets are combined using common business keys.

This creates integrated datasets that can be used to build the analytical model.

6. Model

The cleaned Silver data is transformed into a dimensional model in the Gold layer.

The final model contains:

Customer Dimension
Product Dimension
Date Dimension
Sales Fact
📊 Data Model

The Gold layer contains the analytical dimensions and fact table used by the warehouse.

👤 dim_customer

The Customer Dimension contains descriptive information about customers.

Column	Description
Customer_key	Warehouse surrogate key
Customer_id	Source business key
First_name	Customer first name
Last_name	Customer last name
Marital_Status	Customer marital status
Gender	Customer gender
Country	Customer country
Birth_Date	Customer birth date
Create_Date	Customer creation date
📦 dim_product

The Product Dimension contains descriptive information about products.

Column	Description
Product_key	Warehouse surrogate key
Product_id	Source product identifier
Product_num	Product business key
Category_id	Category identifier
Category	Product category
Sub_Category	Product sub-category
Product_name	Product name
Product_cost	Product cost
Product_line	Product line
Maintenance	Maintenance information
Start_date	Product start date
📅 dim_date

The Date Dimension is a dedicated calendar dimension generated for analytical purposes.

It is not directly sourced from CRM or ERP.

Column	Description
Date_key	Date key in YYYYMMDD format
Full_date	Full calendar date
Day_number	Day number
Day_name	Day name
Month_number	Month number
Month_name	Month name
Quarter_number	Quarter number
Year_number	Year
Week_number	Week number
Is_weekend	Weekend indicator

The same Date Dimension is used for multiple date roles in the fact table:

Order Date
Ship Date
Due Date

This is known as a Role-Playing Dimension.

💰 fact_sales

The Sales Fact contains measurable business events related to sales transactions.

Column	Description
Order_Number	Sales order number
Product_key	Foreign key to dim_product
Customer_key	Foreign key to dim_customer
Order_Date_Key	Foreign key to dim_date
Ship_Date_Key	Foreign key to dim_date
Due_Date_Key	Foreign key to dim_date
Sales	Sales amount
Quantity	Sold quantity
Price	Product price
Fact Table Grain

The intended grain of fact_sales is:

One row represents one sales transaction / sales order line for a specific product and customer.

Defining the grain explicitly helps ensure that measures such as Sales, Quantity, and Price are aggregated correctly.

⭐ Star Schema

The Gold layer follows a Star Schema design.

The central fact_sales table contains measurable business events and connects to descriptive dimension tables.

⭐ Role-Playing Date Dimension

A single dim_date dimension is reused by fact_sales for three different business roles:

                    ┌───────────────┐
                    │   DIM_DATE    │
                    └───────┬───────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
        Order Date      Ship Date      Due Date
              │             │             │
              └─────────────┼─────────────┘
                            ▼
                    ┌───────────────┐
                    │  FACT_SALES   │
                    └───────────────┘

This design allows analysts to perform date-based analysis using the same calendar dimension for different business events.

📁 Project Structure
sql-data-warehouse-project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── diagram/
│   ├── Diagram_of_understand_data_befor_code.drawio
│   └── diagram_bronze_layer.drawio
│
├── script/
│   ├── Bronze/
│   │   └── DDL_Bronze.sql
│   │
│   ├── Silver/
│   │   ├── DDL_SILVER.sql
│   │   └── ...
│   │
│   └── Gold/
│       ├── ...
│       └── ...
│
├── test/
│   └── ...
│
├── .gitignore
└── README.md

Raw CSV datasets are excluded from Git tracking using .gitignore.

🛠️ Technologies
SQL Server
T-SQL
SQL Server Management Studio
Git
GitHub
Draw.io
🎯 Key Data Engineering Concepts

This project demonstrates practical understanding of:

ETL Pipelines
Medallion Architecture
Bronze / Silver / Gold Layers
Data Profiling
Data Quality
Data Cleaning
Data Standardization
Business Rules
Source System Integration
Data Modeling
Dimensional Modeling
Star Schema
Fact Tables
Dimension Tables
Surrogate Keys
Business Keys
Role-Playing Dimensions
Date Dimensions
SQL Server Stored Procedures
T-SQL
Window Functions
CTEs
Data Validation
Deduplication
Incremental Loading Concepts
📌 Project Goals

The main goals of this project are:

Build an end-to-end SQL Data Warehouse.
Integrate data from CRM and ERP systems.
Apply data quality and transformation rules.
Separate raw, cleaned, and analytical data using layered architecture.
Build a dimensional model using a Star Schema.
Prepare the warehouse for analytical queries and reporting.
🚀 Project Status

The SQL Data Warehouse has been implemented using a Bronze → Silver → Gold architecture.

Current focus areas include:

Data ingestion
Data transformation
Data quality
Source integration
Dimensional modeling
Star Schema design
Analytical data preparation
