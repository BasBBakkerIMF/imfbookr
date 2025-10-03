
## -----------------------------------------------------------------------------
## Store IFS data for use for examples.
##
## This code shows how the data was generated so
## it can be re-generated later.
##
## Relies on imf_datatools to get data from data.imf.org.

library(reticulate)
library(dplyr)
library(lubridate)

# Need to set TZ to UTC so dates are not shifted
Sys.setenv(TZ="UTC")

# Need imf_datatools to be installed
datatools <- import("imf_datatools")

# Get data from data.imf.org on inflation (PCPI)
countrylist <- c("USA" = "US",
                 "China" = "CN",
                 "Japan" = "JP",
                 "United Kingdom" = "GB",
                 "Germany" = "DE") 
ifs <- datatools$get_imf_ext_data("IFS", list("A", countrylist, "PCPI_IX"))

# Convert column names to country names.
# Original columns will be of form [country code].PCPI_IX.2010=100.A
# First remove everything but country codes,
# then replace using list of countries
ifs %>%
  rename_with(~ gsub(".PCPI_IX.2010=100.A", "", .x, fixed = TRUE)) %>%
  rename(all_of(countrylist)) -> ifs

# Create column "dates" and convert to dates
ifs$dates <- as.Date(rownames(ifs))

# Drop rownames
rownames(ifs) <- NULL

# Store the data
usethis::use_data(ifs, overwrite=TRUE)
