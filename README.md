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

