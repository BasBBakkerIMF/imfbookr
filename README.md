# imfbookr

`imfbookr` provides helper functions to streamline IMF-style book writing with reproducible R code and standardized charting. It is based on the original `bookr` package, extended for IMF workflows.

---

## Pre-requisites

Before installing `imfbookr`, you need devtools if you do not have it. 

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

## Features

- Predefined **IMF color palettes** for charts.  
- Custom **ggplot2 themes** (e.g., `theme_imf_panel()`).  
- Helper functions to quickly create **line, bar, scatter, and dual-axis charts** with consistent IMF style.  
- Built-in defaults for **plot sizing and saving** (`ggsave_imf`).  
- Utility functions to streamline reproducible graphics for IMF reports and presentations. 

## IMF Color Palettes

The package includes a set of predefined color constants and palettes consistent with IMF/WEO visual standards.
You can use these colors directly in plots or via helper scales like scale_imf_colors().

## Usage

The following examples demonstrate how to use `imfbookr` functions to quickly generate IMF-style charts. We first create some example data, then compare default `ggplot2` styling with the custom IMF palette and themes.

### Quick start (example data)

To illustrate functionality, we generate a simple dataset with 12 months of values across three categories:

```r
library(ggplot2)
library(dplyr)

set.seed(123)
test_data <- data.frame(
  dates    = seq(as.Date("2020-01-01"), by = "month", length.out = 12),
  category = rep(c("A","B","C"), each = 4),
  value1   = runif(12, 50, 100),
  value2   = runif(12, 20, 80)
)
```

Before applying IMF-specific functions, here’s what the default ggplot2 output looks like for a line, bar, and scatter chart.

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

Now we apply the IMF color palette using `scale_imf_colors()`. This ensures all charts use standardized IMF colors.

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

For multi-chart presentations, `theme_imf_panel()` combined with `patchwork` makes it easy to arrange multiple plots in a consistent layout. 

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

`imfbookr` also supports dual-axis plots, useful for showing two related time series on different scales. 

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
Additional charting functions to create simple line charts, bar charts, and scatter charts are also available within the R book under the custom functions tutorial in Various Issues. 
