#' IMF Data Utility Functions
#'
#' A collection of utility functions to process date strings and retrieve data
#' from the IMF database.
#'
#' @importFrom lubridate ceiling_date ymd days
#' @importFrom zoo as.yearmon as.yearqtr
#' @importFrom AzureAuth get_azure_token
#' @importFrom rsdmx readSDMX
#' @importFrom dplyr select matches
#' @importFrom magrittr %>%
#' @name imfdata-utils
NULL

#' Convert a Year-Month String to a Date
#'
#' This function converts a string representing a year and month to a date
#' corresponding to the last day of that month.
#'
#' @param month_string A character string in the format "YYYY-MM" (or similar).
#'
#' @return A \code{yearmon} object representing the last day of the month.
#'
#' @examples
#' yearMonthToDate("2021-05")
#'
#' @export
yearMonthToDate <- function(month_string) {
  if (is.null(month_string) || nchar(month_string) < 7) {
    stop("Invalid month string format")
  }

  # Extract year and month
  year <- as.numeric(substr(month_string, 1, 4))
  month <- as.numeric(substr(month_string, 6, 7))  # Fix index from 7 to 6

  # Find the last day of the month
  last_date <- lubridate::ceiling_date(lubridate::ymd(paste0(year, "-", month, "-01")), "month") - lubridate::days(1)

  # Ensure output is a Date (not yearmon)
  return(as.Date(last_date))
}

#' Convert a Year-Quarter String to a Date
#'
#' This function converts a string representing a year and quarter to a date
#' corresponding to the last month of that quarter.
#'
#' @param quarter_string A character string in the format "YYYY-Q" where Q is the quarter number.
#'
#' @return A \code{yearqtr} object representing the quarter.
#'
#' @examples
#' yearQuarterToDate("2021-Q1")
#'
#' @export
yearQuarterToDate <- function(quarter_string) {
  if (is.null(quarter_string) || nchar(quarter_string) < 7) {
    stop("Invalid quarter string format")
  }
  year <- as.numeric(substr(quarter_string, 1, 4))
  quarter <- as.numeric(substr(quarter_string, 7, 7))
  last_month <- quarter * 3
  last_date <- lubridate::ceiling_date(lubridate::ymd(paste0(year, "-", last_month, "-01")), "month") -
    lubridate::days(1)
  last_date <- zoo::as.yearqtr(last_date)
  return(last_date)
}

#' Process the TIME_PERIOD Column in a Dataset
#'
#' This function processes the \code{TIME_PERIOD} column in a dataset based on the provided frequency.
#'
#' @param dataset A data frame that includes a \code{TIME_PERIOD} column.
#' @param frequency A character vector of length 1 indicating the frequency ("Q", "M", or "A").
#'
#' @return The dataset with a new \code{date} column computed from \code{TIME_PERIOD}.
#'
#' @examples
#' \dontrun{
#'   df <- data.frame(TIME_PERIOD = c("2021-05", "2021-06"))
#'   processTimePeriod(df, "M")
#' }
#'
#' @export
processTimePeriod <- function(dataset, frequency) {
  if (!"TIME_PERIOD" %in% colnames(dataset)) {
    stop("TIME_PERIOD column is missing in the dataset.")
  }

  dataset$date <- NA  # Initialize column

  if (length(frequency) == 1) {
    if (frequency == "Q") {
      dataset$date <- sapply(dataset$TIME_PERIOD, function(x) {
        if (grepl("Q[1-4]$", x)) {
          qtr_date <- zoo::as.yearqtr(x, format = "%Y-Q%q")
          return(as.Date(zoo::as.Date(qtr_date, frac = 1)))  # ✅ Proper conversion
        } else {
          return(NA)
        }
      })
    } else if (frequency == "M") {
      dataset$date <- sapply(dataset$TIME_PERIOD, function(x) {
        if (grepl("^[0-9]{4}-[0-9]{2}$", x)) {
          mon_date <- zoo::as.yearmon(x, format = "%Y-%m")
          return(as.Date(zoo::as.Date(mon_date, frac = 1)))  # ✅ Proper conversion
        } else {
          return(NA)
        }
      })
    } else if (frequency == "A") {
      dataset$date <- as.numeric(dataset$TIME_PERIOD)  # ✅ Keep numeric format for years
    } else {
      stop("Invalid frequency format. Use 'M', 'Q', or 'A'.")
    }
  }

  # Ensure the class is correctly set for Dates
  if (frequency %in% c("M", "Q")) {
    dataset$date <- as.Date(dataset$date, origin = "1970-01-01")  # ✅ Ensures Date class
  }

  return(dataset)
}





#' Retrieve IMF Data by Key
#'
#' This function retrieves IMF data using the provided key.
#' It handles authentication (if required), builds the API call, and processes
#' the returned SDMX data.
#'
#' @param department A character string representing the department.
#' @param dataset A character string representing the dataset.
#' @param key A character string or list containing keys for countries, series, and frequency.
#' @param needs_auth Logical; whether authentication is required.
#' @param needs_labels Logical; whether to retrieve data with labels.
#'
#' @return A data frame with the retrieved and processed data.
#'
#' @export
imfdata_by_key <- function(department, dataset, key, needs_auth = FALSE, needs_labels = FALSE) {
  # Environment to store token information
  env <- new.env(parent = emptyenv())
  client_id <- "446ce2fa-88b1-436c-b8e6-94491ca4f6fb"
  tenant <- "https://imfprdb2c.onmicrosoft.com/"
  authority <- "https://imfprdb2c.b2clogin.com/imfprdb2c.onmicrosoft.com/b2c_1a_signin_aad_simple_user_journey/oauth2/v2.0"
  scope <- "https://imfprdb2c.onmicrosoft.com/4042e178-3e2f-4ff9-ac38-1276c901c13d/iData.Login"

  get_new_token <- function() {
    AzureAuth::get_azure_token(
      resource = scope,
      tenant = tenant,
      app = client_id,
      version = 2,
      aad_host = authority
    )
  }

  if (needs_auth) {
    if (!exists("token", envir = env) ||
        is.null(env$token) ||
        is.null(env$token$credentials$expires_on) ||
        Sys.time() >= as.POSIXct(env$token$credentials$expires_on, origin = "1970-01-01")) {
      env$token <- get_new_token()
    }
    token <- env$token
    headers <- c(
      'Authorization' = paste(token$credentials$token_type, token$credentials$access_token),
      'User-Agent' = 'idata-script-client'
    )
  } else {
    headers <- c('User-Agent' = 'idata-script-client')
  }

  flowRef <- paste0("IMF.", department, ",", dataset)

  if (needs_labels) {
    data <- tryCatch({
      as.data.frame(
        rsdmx::readSDMX(
          providerId = 'IMF_DATA',
          resource = 'data',
          flowRef = flowRef,
          key = key,
          headers = headers,
          dsd = TRUE
        ),
        labels = TRUE
      )
    }, error = function(e) {
      stop("Failed to retrieve data: ", e$message)
    })
  } else {
    data <- tryCatch({
      as.data.frame(
        rsdmx::readSDMX(
          providerId = 'IMF_DATA',
          resource = 'data',
          flowRef = flowRef,
          key = key,
          headers = headers
        )
      )
    }, error = function(e) {
      stop("Failed to retrieve data: ", e$message)
    })
  }

  # 🔹 Extract frequency correctly
  if (is.character(key)) {
    key_parts <- strsplit(key, "\\.")[[1]]
    frequency <- key_parts[length(key_parts)]  # Last part is expected to be frequency
  } else if (is.list(key)) {
    frequency <- key[[length(key)]]
  } else {
    stop("Invalid key format. Must be a character string or list.")
  }

  # 🔹 Validate frequency format before passing to processTimePeriod()
  if (!frequency %in% c("M", "Q", "A")) {
    stop("Invalid frequency format. Use 'M', 'Q', or 'A'.")
  }

  # 🔹 Ensure TIME_PERIOD exists before calling processTimePeriod()
  if ("TIME_PERIOD" %in% colnames(data)) {
    data <- processTimePeriod(data, frequency)
  } else {
    warning("TIME_PERIOD column missing in dataset. Data may not be formatted correctly.")
  }

  # 🔹 Ensure OBS_VALUE exists before creating 'value' column
  if ("OBS_VALUE" %in% colnames(data)) {
    data$value <- as.numeric(data$OBS_VALUE)
  } else {
    stop("OBS_VALUE column is missing in the dataset.")
  }

  # 🔹 Remove language-specific label columns
  data <- dplyr::select(data, -dplyr::matches("label\\.(ja|fr|zh|ar|ru|pt|es)$"))

  return(data)
}



#' Retrieve IMF Data by Countries and Series
#'
#' This function retrieves data from the IMF database using the specified
#' countries and series. It builds the necessary key and calls an internal function
#' to handle data retrieval and processing.
#'
#' @param department A character string representing the department.
#' @param dataset A character string representing the dataset.
#' @param countries A vector of country codes (optional).
#' @param series A vector of series codes (optional).
#' @param frequency A character string representing the frequency ("A", "Q", or "M").
#'   The default is "A".
#' @param needs_auth Logical; whether authentication is required. Default is \code{FALSE}.
#' @param needs_labels Logical; whether to retrieve data with labels. Default is \code{FALSE}.
#'
#' @return A data frame containing the retrieved data.
#'
#' @examples
#' \dontrun{
#'   # Retrieve annual data for a set of countries and series
#'   df <- imfdata_by_countries_and_series(department = "DEPT", dataset = "DATASET",
#'                                          countries = c("US", "GB"), series = c("SERIES1", "SERIES2"),
#'                                          frequency = "A")
#' }
#'
#' @export
imfdata_by_countries_and_series <- function(department,
                                            dataset,
                                            countries = NULL,
                                            series = NULL,
                                            frequency = "A",
                                            needs_auth = FALSE,
                                            needs_labels = FALSE) {
  key <- list(countries = countries, series = series, frequency = frequency)
  if (needs_labels) {
    data <- imfdata_by_key(department = department,
                            dataset = dataset,
                            key = key,
                            needs_auth = needs_auth,
                            needs_labels = TRUE)
  } else {
    data <- imfdata_by_key(department = department,
                            dataset = dataset,
                            key = key,
                            needs_auth = needs_auth)
  }
  return(data)
}


#' Show Available IMF Datasets
#'
#' This function retrieves a data frame containing information on available IMF datasets by querying the IMF API.
#' If authentication is required, the function obtains an access token via Azure AD B2C.
#'
#' @param needs_auth Logical; if \code{TRUE} the function will use authentication. Default is \code{FALSE}.
#'
#' @return A data frame of available IMF datasets.
#'
#' @importFrom AzureAuth get_azure_token
#' @importFrom rsdmx readSDMX
#'
#' @examples
#' \dontrun{
#'   datasets <- imfdata_show_datasets(needs_auth = TRUE)
#'   head(datasets)
#' }
#'
#' @export
imfdata_show_datasets <- local({
  # Create an environment to cache the token.
  env <- new.env(parent = emptyenv())
  client_id <- "446ce2fa-88b1-436c-b8e6-94491ca4f6fb"
  tenant <- "https://imfprdb2c.onmicrosoft.com/"
  authority <- "https://imfprdb2c.b2clogin.com/imfprdb2c.onmicrosoft.com/b2c_1a_signin_aad_simple_user_journey/oauth2/v2.0"
  scope <- "https://imfprdb2c.onmicrosoft.com/4042e178-3e2f-4ff9-ac38-1276c901c13d/iData.Login"

  function(needs_auth = FALSE) {
    # The URL for retrieving IMF datasets.
    url <- "https://api.imf.org/external/sdmx/2.1/datastructure"

    get_new_token <- function() {
      AzureAuth::get_azure_token(
        resource = scope,
        tenant = tenant,
        app = client_id,
        version = 2,
        aad_host = authority
      )
    }

    if (needs_auth) {
      if (!exists("token", envir = env) ||
          is.null(env$token) ||
          is.null(env$token$credentials$expires_on) ||
          Sys.time() >= as.POSIXct(env$token$credentials$expires_on, origin = "1970-01-01")) {
        env$token <- get_new_token()
      }
      token <- env$token
      headers <- c(
        'Authorization' = paste(token$credentials$token_type, token$credentials$access_token),
        'User-Agent' = 'idata-script-client'
      )
    } else {
      headers <- c('User-Agent' = 'idata-script-client')
    }

    imf_datasets <- rsdmx::readSDMX(url, headers = headers)
    imf_datasets <- as.data.frame(imf_datasets)
    # Removed the interactive View() call.
    return(imf_datasets)
  }
})

#' Get Dimensions of an IMF Dataset
#'
#' This function retrieves the data structure of a given IMF dataset and extracts its dimensions.
#'
#' @param dataset A character string specifying the dataset identifier.
#'
#' @return A data frame with one column, \code{Dimensions}, listing the dimension names of the dataset.
#'
#' @importFrom rsdmx readSDMX
#'
#' @examples
#' \dontrun{
#'   dims <- imfdata_get_dimensions_dataset("DSD_CPI")
#'   print(dims)
#' }
#'
#' @export
imfdata_get_dimensions_dataset <- function(dataset) {
  # Attempt to fetch the dataset structure
  dsd <- tryCatch({
    rsdmx::readSDMX(
      providerId = "IMF_DATA",
      resource = "datastructure",
      resourceId = dataset
    )
  }, error = function(e) {
    message("Failed to retrieve dataset dimensions: ", e$message)
    return(NULL)
  })

  # Ensure `dsd` is not NULL before proceeding
  if (is.null(dsd)) {
    return(data.frame(Dimensions = character()))  # Return empty DataFrame
  }

  # Extract dimensions safely
  ds <- slot(dsd, "datastructures")@datastructures
  if (length(ds) == 0) {
    message("No structures found for dataset: ", dataset)
    return(data.frame(Dimensions = character()))  # Return empty DataFrame
  }

  dims <- slot(ds[[1]], "Components")@Dimensions
  dim_names <- sapply(dims, function(x) slot(x, "conceptRef"))

  # Ensure dim_names is not empty
  if (length(dim_names) == 0) {
    message("No dimensions found for dataset: ", dataset)
    return(data.frame(Dimensions = character()))
  }

  # Return as a DataFrame
  dimensions <- as.data.frame(dim_names, stringsAsFactors = FALSE)
  colnames(dimensions) <- c("Dimensions")

  return(dimensions)
}


#' Get Attributes of an IMF Dataset
#'
#' This function retrieves the data structure of a given IMF dataset and extracts its attributes.
#'
#' @param dataset A character string specifying the dataset identifier.
#'
#' @return A data frame with one column, \code{attributes}, listing the attribute names of the dataset.
#'
#' @importFrom rsdmx readSDMX
#'
#' @examples
#' \dontrun{
#'   attrs <- imfdata_get_attributes_dataset("DSD_CPI")
#'   print(attrs)
#' }
#'
#' @export
imfdata_get_attributes_dataset <- function(dataset) {
  # Attempt to fetch the dataset structure
  dsd <- tryCatch({
    rsdmx::readSDMX(
      providerId = "IMF_DATA",
      resource = "datastructure",
      resourceId = dataset
    )
  }, error = function(e) {
    message("Failed to retrieve dataset attributes: ", e$message)
    return(NULL)
  })

  # Ensure `dsd` is not NULL before proceeding
  if (is.null(dsd)) {
    return(data.frame(attributes = character()))  # Return empty DataFrame
  }

  # Extract attributes safely
  ds <- slot(dsd, "datastructures")@datastructures
  if (length(ds) == 0) {
    message("No structures found for dataset: ", dataset)
    return(data.frame(attributes = character()))  # Return empty DataFrame
  }

  attrs <- slot(ds[[1]], "Components")@Attributes
  attr_names <- sapply(attrs, function(x) slot(x, "conceptRef"))

  # Ensure attr_names is not empty
  if (length(attr_names) == 0) {
    message("No attributes found for dataset: ", dataset)
    return(data.frame(attributes = character()))
  }

  # Return as a DataFrame
  attributes <- as.data.frame(attr_names, stringsAsFactors = FALSE)
  colnames(attributes) <- c("attributes")

  return(attributes)
}

