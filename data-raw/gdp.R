
## -----------------------------------------------------------------------------
## Store US GDP data for use for examples.
## *** THIS IS COMMERCIAL DATA FROM HAVER SO SHOULD NOT BE ***
## *** SHARED EXTERNALLY.                                  ***
## 
## This code shows how the data was generated so
## it can be re-generated later.
##
## Relies on imf_datatools to get data from Haver.

library(reticulate)
library(dplyr)
library(lubridate)

# Need to set TZ to UTC so dates are not shifted
Sys.setenv(TZ="UTC")

# Need imf_datatools to be installed
datatools <- import("imf_datatools")

seriescodes <- c("GDP" = "PGDPH@USECON",
                 "Consumption" = "PTCH@USECON",
                 "Government" = "PTGH@USECON",
                 "Investment" = "PTFH@USECON",
                 "Inventories" = "PTVH@USECON",
                 "Exports" = "PTXH@USECON",
                 "Imports" = "PTMH@USECON")

# Get data, need to unname list
gdp <- datatools$get_haver_data(unname(seriescodes))

# Convert column names using named list.
gdp %>%
  rename(all_of(seriescodes)) -> gdp

# Create column "dates" and convert to dates
gdp$dates <- as.Date(rownames(gdp))

# Drop rownames
rownames(gdp) <- NULL

# Store the data
usethis::use_data(gdp, overwrite=TRUE)

                    