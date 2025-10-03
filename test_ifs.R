## Test line charts using IFS data.

rm(list = ls())
library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(ggpubr)
library(patchwork)
library(imfbookr)

# Filter on date
START <- as.Date("2000-01-01")
ifs <- ifs %>% filter(dates >= START)

# Format IFS data for ggplot
ifs2 <- ifs %>% pivot_longer(-dates)

# Draw line chart with title, subtitle, and legend
fig <- plot_line_chart(ifs2, "dates", "value", line_color = "name") +
  scale_imf_colors() +  # ✅ Apply default IMF colors
  labs(
    title = "IFS Line Chart Test",
    subtitle = "Default with min. specs",
    color = "Indicator"  # Ensures legend title is properly set
  )

# Display plot
fig
