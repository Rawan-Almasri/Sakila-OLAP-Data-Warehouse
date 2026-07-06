# Sakila Data Warehouse Project

## Overview

This project demonstrates the transformation of the **Sakila** transactional database (**OLTP**) into an **OLAP Data Warehouse** using **Microsoft SQL Server**.

The project covers the complete data warehousing workflow, including dimensional modeling, ETL implementation, table partitioning, triggers, and analytical SQL queries. It serves as a practical example of designing and implementing a SQL Server-based data warehouse.

---

## About Sakila

**Sakila** is an open-source sample database originally developed by MySQL. It simulates a DVD rental store and is widely used for learning SQL, database design, and advanced database programming concepts.

Its rich relational structure makes it an excellent dataset for demonstrating data warehouse design and analytical reporting.

---

## Project Objectives

* Transform the Sakila OLTP database into an OLAP Data Warehouse.
* Design and implement a Star Schema.
* Build ETL processes to populate dimension and fact tables.
* Apply SQL Server performance optimization techniques.
* Develop analytical SQL queries for reporting and business insights.

---

## Project Structure

```text
Sakila-Data-Warehouse/
│
├── 01-Sakila-Database/
│   ├── sakila-schema.sql          # Original Sakila database schema
│   └── sakila-data.sql            # Original sample data
│
├── 02-Data-Warehouse/
│   ├── star-schema.sql            # Data Warehouse schema
│   └── star-schema-design.png     # Star Schema diagram
│
├── 03-ETL/
│   └── etl.sql                    # ETL implementation
│
├── 04-Partitioning/
│   └── partitioning.sql           # Table partitioning
│
├── 05-Triggers/
│   └── triggers.sql               # SQL Server triggers
│
├── 06-Analytics/
│   └── analytical-queries.sql     # Analytical SQL queries
│
└── README.md
```

---

## Project Components

### Original Sakila Database

Contains the original Sakila database schema and sample data scripts provided by MySQL.

### Data Warehouse

Implements the Star Schema, including fact and dimension tables, designed for analytical workloads.

### Star Schema Design

Provides a visual representation of the dimensional model used in the project.

### ETL

Implements the Extract, Transform, and Load process to populate the data warehouse from the transactional database.

### Partitioning

Demonstrates table partitioning techniques to improve query performance and manage large datasets efficiently.

### Triggers

Includes SQL Server triggers used for automation and data management tasks.

### Analytical Queries

A collection of SQL queries demonstrating reporting, aggregation, trend analysis, and business insights using the data warehouse.

---

## Technologies

* Microsoft SQL Server
* T-SQL
* SQL Server Management Studio (SSMS)
* Data Warehousing
* Star Schema
* ETL
* Table Partitioning
* SQL Server Triggers
* Query Optimization

---

## Skills Demonstrated

* Data Warehouse Design
* Dimensional Modeling
* Star Schema Implementation
* ETL Development
* SQL Server Programming
* Performance Optimization
* Table Partitioning
* Trigger Development
* Analytical SQL
* Business Reporting

---

## License

This project is intended for educational and portfolio purposes.

The original **Sakila** sample database was developed by MySQL and is used as the source dataset for this project.
