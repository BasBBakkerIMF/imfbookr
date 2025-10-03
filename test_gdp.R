# Various testing of charts to check default IMF Theme
#Testing GDP example

rm(list = ls())
library(readr)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(patchwork)
library(tidyr)
library(lubridate)
library(imfbookr)

# ------------------------------
# 1️⃣ Data Preparation
# ------------------------------
# Filter on date
START <- as.Date("2015-01-01")
gdp <- gdp %>% filter(dates >= START)

# Format GDP data for plotting
gdp2 <- gdp %>% pivot_longer(-dates)

# Separate GDP and non-GDP components
nongdp <- gdp2 %>% filter(name != "GDP")
gdponly <- gdp2 %>% filter(name == "GDP")

# ------------------------------
# 2️⃣ Simple Test Line Plot (IMF Colors)
# ------------------------------
ggplot(gdp, aes(dates, GDP)) +
  geom_line(size = 1) +
  scale_imf_colors() +  # ✅ Apply IMF Colors
  labs(
    title = "Test Chart",
    subtitle = "This is a test subtitle for GDP trends"
  )

# ------------------------------
# 3️⃣ Test for Legend Placement in Line Plot
# ------------------------------
ggplot(gdp, aes(dates, GDP, color = "GDP")) +
  geom_line(size = 1.0) +
  scale_imf_colors() +  # ✅ Apply IMF Colors to legend
  labs(
    title = "Test Line Plot",
    subtitle = "Checking if the legend appears correctly",
    x = "Year",
    y = "GDP",
    color = "Indicator"
  )

# ------------------------------
# 4️⃣ Test Stacked Bar Chart (Last 5 Years)
# ------------------------------
# Define start date dynamically (5 years before today)
START <- Sys.Date() - years(5)

# Filter GDP data to only include the last 5 years
gdp <- gdp %>% filter(dates >= START)

# Format GDP data for plotting
gdp2 <- gdp %>% pivot_longer(-dates)

# Separate GDP and non-GDP components
nongdp <- gdp2 %>% filter(name != "GDP")
gdponly <- gdp2 %>% filter(name == "GDP")

# Define title and subtitle dynamically
plot_title <- "Stacked Bar Chart of GDP"
plot_subtitle <- paste0("Data from ", format(min(gdp$dates), "%Y"), " to ", format(max(gdp$dates), "%Y"))

# Draw bar chart of non-GDP components
fig <- plot_bar_chart(nongdp, "dates", "value", bar_width = 80, fill_var = "name") +
  scale_imf_colors() +  # ✅ Apply IMF Colors
  labs(title = plot_title, subtitle = plot_subtitle) +
  theme_imf()

# Add GDP line on top (ensuring black line)
fig + geom_line(data = gdponly, aes(x = dates, y = value), color = "black", size = 1)
