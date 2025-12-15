################################################################################
# TITLE:    basic ETL process
# PURPOSE:  demonstrate an ETL process that uses an external source to extract the data,
#           transforms data into format using business logic, and loads into a target database object.
################################################################################

import common_functions
import pandas as pd
import sqlite3
from pathlib import Path

# define database path
db_path = Path(__file__).resolve().parents[1] / "data" / "local_warehouse.db"

# create connection
conn = sqlite3.connect(db_path)

# read in the data source and do some inital prep to the data
registry_costs_df = pd.read_csv("data/registry_costs.csv", 
                                parse_dates=['invoice_date'],
                                dtype={'entity': str, 'department': str, 'employee_name': str })

# registry_costs_df.info()

# bring in a column for the fiscal period to align with business reporting logic
registry_costs_df['fiscal_period'] = registry_costs_df['invoice_date'].apply(common_functions.conv_date_to_fiscal_period)

# load to the target database object
registry_costs_df.to_sql(name='registry_costs_fact', con=conn, schema='financial', if_exists='replace', index=False)
print(f"Data has been loaded successfully to registry_costs_fact table.")

registry_df_read = pd.read_sql(sql="select * from registry_costs_fact", con=conn)
print(registry_df_read)
