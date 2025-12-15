### TITLE:    common functions and libraries
### PURPOSE:  utilize this common set of functions and libraries for setup

# common libraries --------------------------------------------------------

library(data.table)
library(DBI)
library(RSQLite)
library(dplyr)
library(dbplyr)
library(readr)
library(openxlsx)
library(lubridate)

# common functions --------------------------------------------------------

### convert the fiscal period to a date format (using October as the fiscal year start)
conv_fiscal_period_to_date <- function(fiscal_period) {
  fiscal_year <- as.integer(substr(fiscal_period, 1, 4))
  fiscal_month <- as.integer(substr(fiscal_period, 5, 6))
  cal_year <- fifelse(between(fiscal_month, 1, 3)
                      , fiscal_year - 1
                      , fiscal_year
                      )
  cal_month <- fifelse(between(fiscal_month, 1, 3)
                       , fiscal_month + 9
                       , fiscal_month + 9 - 12
                       )
  
  print(as.Date(sprintf("%04d-%02d-01", cal_year, cal_month)))

}

### convert the date to a fiscal period format (using October as the fiscal year start)
conv_date_to_fiscal_period <- function(date) {
  date <- as.Date(date)
  cal_month <- as.integer(format(date, "%m"))
  cal_year <- as.integer(format(date, "%Y"))
  fiscal_month <- fifelse(between(cal_month, 10, 12)
                          , cal_month - 9
                          , cal_month + 3
                          )
  fiscal_year <- fifelse(cal_month < 10
                         , cal_year 
                         , cal_year + 1)
  
  print(as.character(sprintf("%d%02d", fiscal_year, fiscal_month)))

}
