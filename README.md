# SQL Data Warehouse Project

## 📌 Overview

This project demonstrates the design and implementation of a
modern SQL Data Warehouse using SQL Server.

The project integrates data from two source systems:

- CRM
- ERP

The data is processed through a Medallion-style architecture:

Bronze → Silver → Gold

---

## 🏗️ Architecture

Source Systems
      ↓
CRM + ERP
      ↓
Bronze Layer
      ↓
Data Quality & Profiling
      ↓
Silver Layer
      ↓
Cleaning + Standardization + Business Rules
      ↓
Gold Layer
      ↓
Star Schema
      ↓
Analytics & Reporting

---

## 🥉 Bronze Layer

The Bronze layer stores raw data extracted from the source systems.

Main operations:

- BULK INSERT
- Raw data ingestion
- Full refresh loading
- Source data preservation

---

## 🥈 Silver Layer

The Silver layer performs:

- Data cleaning
- Deduplication
- Data type standardization
- NULL handling
- Date normalization
- Business rule validation
- Source system integration

---

## 🥇 Gold Layer

The Gold layer contains the analytical data model.

### Dimensions

- dim_customer
- dim_product
- dim_date

### Fact

- fact_sales

The final model follows a Star Schema design.

---

## ⭐ Data Model

The fact table contains:

- Customer_key
- Product_key
- Order_Date_Key
- Ship_Date_Key
- Due_Date_Key
- Sales
- Quantity
- Price

The Date Dimension is used as a role-playing dimension for:

- Order Date
- Ship Date
- Due Date

---

## 🛠️ Technologies

- SQL Server
- T-SQL
- SQL Server Management Studio
- Git
- GitHub

---

## 🎯 Key Data Engineering Concepts

This project demonstrates:

- ETL
- Data Profiling
- Data Quality
- Data Cleaning
- Medallion Architecture
- Data Modeling
- Star Schema
- Surrogate Keys
- Fact & Dimension Tables
- Window Functions
- CTEs
- Stored Procedures
- Incremental Loading Concepts
- Data Validation