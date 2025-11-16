### TITLE:    basic ETL process
### PURPOSE:  demonstrate an ETL process that uses an external source to extract the data,
###           transforms data into format using business logic, and loads into a target database object.
###           This process can also be set up to utilize what has already been built by Python 
###           and connect to the database/data.

# load libraries and connections ------------------------------------------

library(data.table)
library(DBI)
library(RSQLite)
library(dplyr)
library(dbplyr)
library(readr)
library(openxlsx)

### connect to the database and target table
db_con <- dbConnect(RSQLite::SQLite(), paste0("data/local_warehouse.db"))

### read in the existing table (if it's already loaded from the python process)
registry_costs_db <- data.frame(dbGetQuery(conn = db_con, statement = paste0("select * from registry_costs_fact")))

### read in the external data
registry_costs_df <- read.csv(file = 'data/registry_costs.csv')

