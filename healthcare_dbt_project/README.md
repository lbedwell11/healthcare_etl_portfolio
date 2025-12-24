
### Healthcare dbt Project

This repo contains the dbt transformation layer for this repo's broader *Healthcare ETL Portfolio*. The goal of this project is to model realistic healthcare data using modern analytics engineering best practices.

---

### Project Purpose
This dbt project demonstrates how raw healthcare data (e.g., billing, claims, patients, providers) can be transformed into clean, analytics-ready models suitable for downstream reporting and analysis. It is designed to mirror real-world healthcare data workflows while remaining lightweight for portfolio purposes.

### Objectives
- apply analytics engineering patterns
  ```mermaid
  graph LR
      A[sources] --> B[staging]
      B --> C[prep]
      C --> D[intermediate]
      D --> E[marts]
  
  ```
- enforce data quality with tests and documentation

### Tech Stack
- dbt Core: deploy transformations, testing, documentation
- Python (venv): isolate dependencies
- DuckDB / DBeaver: utilize local analytical database management
- CSV seeds: simulate raw source data
