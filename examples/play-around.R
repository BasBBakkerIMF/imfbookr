
library(ggplot2)
library(dplyr)
library(imfbookr)





set.seed(123)
test_data <- data.frame(
  dates    = seq(as.Date("2020-01-01"), by = "month", length.out = 12),
  category = rep(c("A", "B", "C"), each = 4),
  value1   = runif(12, 50, 100),
  value2   = runif(12, 20, 80)
)

library(patchwork)

p1 <- ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(linewidth = 1.5) +
  scale_imf_colors() +
  labs(title = "IMF Line Chart", subtitle = "IMF palette")+
  theme_imf_panel()

p2 <- ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_imf_colors() +
  labs(title = "IMF Stacked Bar", subtitle = "IMF palette")+
  theme_imf_panel()

p3 <- ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  scale_imf_colors() +
  labs(title = "IMF Scatter", subtitle = "IMF palette")+
  theme_imf_panel()

(p1 | p2) / p3 +
  plot_annotation(
    title = "Panel Test: theme_imf_panel()",
    subtitle = "Multiple plots in a panel layout",
    theme = theme_imf_panel_title()
  )




p1 <- ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(linewidth = 1.5) +
  scale_imf_colors_2027() +
  labs(title = "IMF Line Chart", subtitle = "IMF palette")+
  theme_imf_panel_2027()

p2 <- ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_imf_colors_2027() +
  labs(title = "IMF Stacked Bar", subtitle = "IMF palette")+
  theme_imf_panel_2027()

p3 <- ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  scale_imf_colors_2027() +
  labs(title = "IMF Scatter", subtitle = "IMF palette")+
  theme_imf_panel_2027()

(p1 | p2) / p3 +
  plot_annotation(
    title = "Panel Test: theme_imf_panel()",
    subtitle = "Multiple plots in a panel layout",
    theme = theme_imf_panel_title_2027()
  )
