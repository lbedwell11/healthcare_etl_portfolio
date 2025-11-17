### TITLE:    basic ETL process
### PURPOSE:  demonstrate an ETL process that uses an external source to extract the data,
###           transforms data into format using business logic, and loads into a target database object.
###           This process can also be set up to utilize what has already been built by Python 
###           and connect to the database/data.

# load libraries and connections ------------------------------------------

### bring in common set of functions and libraries for setup
source('r/common_functions.R')

### connect to the database and target table
db_con <- dbConnect(RSQLite::SQLite(), paste0("data/local_warehouse.db"))

### default current reporting period
fiscal_period_repl <- c(
  start_fperiod = conv_date_to_fiscal_period(rollback(Sys.Date()))
  , end_fperiod = conv_date_to_fiscal_period(rollback(Sys.Date()))
)

### read in the external data
# rm(registry_costs_df)
registry_costs_df <- data.table(read_csv(file = 'data/registry_costs.csv')) %>% 
  .[,.(
    entity = as.character(entity)
    , department = as.character(department)
    , employee_name = as.character(employee_name)
    , invoice_date = mdy(invoice_date)
    , hours = as.numeric(hours)
    , dollars = as.numeric(dollars)
    
    )] %>% .[]

registry_costs_df[,`:=`(fiscal_period = conv_date_to_fiscal_period(invoice_date)
                  , tbl_src = 'external'
                  )] %>% .[]

### read in the existing table (if it's already loaded from the python process)
rm(registry_costs_db)
registry_costs_db <- data.table(dbGetQuery(conn = db_con
                                           , statement = paste0("select * from registry_costs_fact"))) %>%
  .[,.(
    entity = as.character(entity)
    , department = as.character(department)
    , employee_name = as.character(employee_name)
    , invoice_date = as.Date(invoice_date)
    , hours = as.numeric(hours)
    , dollars = as.numeric(dollars)
    , fiscal_period = as.character(fiscal_period)
    )] %>% 
  .[, tbl_src := 'registry_costs_fact']


# data comparison ----------------------------------------------------------

### run validation on what is already in the table and what needs to be updated/added
head(registry_costs_df, 10)
head(registry_costs_db, 10)

registry_diffs <- 
  rbind(registry_costs_df
        , registry_costs_db) %>%
  dcast(.,...~tbl_src, fill = 0, value.var = c('hours', 'dollars')) %>% 
  .[,`:=`(hours_diff = hours_registry_costs_fact - hours_external
          , dollars_diff = dollars_registry_costs_fact - dollars_external
          )] %>% 
  .[,diff_flag := fifelse(hours_diff != 0 & dollars_diff != 0, 1, 0)] %>% 
  .[diff_flag == 1]

start_fperiod <- min(unique(registry_diffs$fiscal_period))
fiscal_period_repl[1] <- start_fperiod



# load to database --------------------------------------------------------

### after comparing what would need to be updated, remove data from periods that are in the parameter
dbGetQuery(conn = db_con
           , statement = paste0("DELETE FROM registry_costs_fact
                                where fiscal_period between '", fiscal_period_repl[1]
                                ,"' and '", fiscal_period_repl[2],"' ")
           )
dbExecute(conn = db_con
          , statement = )
### load data to the target table for the periods that need to be loaded
dbWriteTable(conn = db_con
             , name = Id( table = "registry_costs_fact")
             , value = as.data.frame(registry_costs_df[between(fiscal_period
                                                               , fiscal_period_repl[1]
                                                               , fiscal_period_repl[2])
                                                       ,.(entity
                                                          , department
                                                          , employee_name
                                                          , invoice_date
                                                          , hours
                                                          , dollars
                                                          , fiscal_period
                                                          )]) 
             , append = TRUE # note that this is to append the table 
             )


# post-load validation ----------------------------------------------------

data.table(dbGetQuery(conn = db_con
                      , statement = paste0("select * from registry_costs_fact")))



