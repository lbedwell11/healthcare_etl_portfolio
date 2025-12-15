
### Healthcare dbt Project

This repo contains the dbt transformation layer for the broader *Healthcare Analytics ETL Portfolio*. The goal of this project is to model realistic healthcare data using modern anlytics engineering best practices.

---

### Project Purpose
This dbt project demonstrates how raw healthcare data (e.g., claims, members, providers) can be transformed into clean, analytics-ready models suitable for downstream reporting and analysis. It is designed to mirror real-world healthcare data workflows while remaining lightweight for portfolio purposes.

# Objectives:
- apply analytics engineering patterns (staging --> marts)
- enforce data quality with tests and documentation

### Tech Stack
- dbt Core: deploy transformations, testing, documentation
- DuckDB / DBeaver: utilize local analytical database management
- Python (venv): isolate dependencies
- CSV seeds: simulate raw source data
