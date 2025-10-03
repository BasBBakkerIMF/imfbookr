# imfbookr

`imfbookr` provides helper functions to streamline IMF-style style with reproducible R code and standardized charting.

---

## Pre-requisites

Before installing `imfbookr`, you need the latest version of the [`rsdmx`](https://github.com/opensdmx/rsdmx) package.  
You **cannot** install it from CRAN — you must install it from GitHub.

```r
# install devtools if you don't have it
install.packages("devtools")
library(devtools)
```
## Installing `imfbookr`

On most computers you can install directly from GitHub:

```r
library(remotes)
remotes::install_git("https://github.com/BasBBakkerIMF/imfbookr.git")
```
On some IMF computers that does not work. In that case, use this fallback:

```r
url <- "https://codeload.github.com/BasBBakkerIMF/imfbookr/tar.gz/HEAD"
tf  <- tempfile(fileext = ".tar.gz")

curl::curl_download(url, tf)        # fetch with curl
remotes::install_local(tf)          # install from the downloaded file
```

After installation, load the package with:
```r
library(imfbookr)
```
## Usage

### Quick start (example data)
```r
library(ggplot2)
library(dplyr)
library(imfbookr)

set.seed(123)
test_data <- data.frame(
  dates    = seq(as.Date("2020-01-01"), by = "month", length.out = 12),
  category = rep(c("A","B","C"), each = 4),
  value1   = runif(12, 50, 100),
  value2   = runif(12, 20, 80)
)
```
### Now let's look at default ggplot behavior
```r
# Line
ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(size = 1.5) +
  labs(title = "Default Line Chart Colors",
       subtitle = "Baseline without IMF color scale")

# Stacked bar
ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Default Stacked Bar Colors")

# Scatter
ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  labs(title = "Default Scatter Colors")
```

### This is how we would apply the IMF palette to any plot
```r
# Line with IMF colors
ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(size = 1.5) +
  scale_imf_colors() +
  labs(title = "IMF Line Chart Colors")

# Stacked bar with IMF colors
ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_imf_colors() +
  labs(title = "IMF Stacked Bar Colors")

# Scatter with IMF colors
ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  scale_imf_colors() +
  labs(title = "IMF Scatter Colors")
```
### This is the panel theme for IMF Theme Panel
```r
library(patchwork)

p1 <- ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(size = 1.5) +
  scale_imf_colors() +
  labs(title = "IMF Line Chart", subtitle = "IMF palette")

p2 <- ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_imf_colors() +
  labs(title = "IMF Stacked Bar", subtitle = "IMF palette")

p3 <- ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  scale_imf_colors() +
  labs(title = "IMF Scatter", subtitle = "IMF palette")

(p1 | p2) / p3 +
  plot_annotation(title = "Panel Test: theme_imf_panel()",
                  subtitle = "Multiple plots in a panel layout") &
  theme_imf_panel()
```
### Finally let's look at a dual axis example
```r
df <- tibble::tibble(
  date  = seq.Date(from = as.Date("2020-01-01"), by = "month", length.out = 12),
  left  = rnorm(12, 100, 10),
  right = rnorm(12, 5, 1)
)

plot_dual_axis(
  df,
  left, right,
  plot_title   = "Sample Dual Axis Chart",
  plot_subtitle= "Retail Sales vs Inflation Index (2020–2021)",
  y_left_lbl   = "Retail Sales",
  y_right_lbl  = "Inflation Index"
)
```
