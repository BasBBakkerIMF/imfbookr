##default tests
library(ggplot2)
library(dplyr)
library(imfbookr)

# Generate test data (12 months)
set.seed(123)  # Ensures reproducibility
test_data <- data.frame(
  dates = seq(as.Date("2020-01-01"), by = "months", length.out = 12),
  category = rep(c("A", "B", "C"), each = 4),  # Three categories for stacked bar
  value1 = runif(12, 50, 100),  # Values for line & bar charts
  value2 = runif(12, 20, 80)    # Second variable for scatter
)

# 1. Line Chart (Check Default Line Colors)
ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(size = 1.5) +
  labs(title = "Test: Default Line Chart Colors", subtitle = "Checking bookr's default color behavior")

# 2. Stacked Bar Chart (Check Default Fill Colors)
ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Test: Default Stacked Bar Colors", subtitle = "Checking bookr's default fill colors")

# 3. Scatter Plot (Check Default Point Colors)
ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  labs(title = "Test: Default Scatter Colors", subtitle = "Checking bookr's default scatter colors")

##Added a custom function called scale imf colors to add
##to any chart, and testing it below.
# ------------------------------
# 1️⃣ Test Line Chart (IMF Colors vs Default)
# ------------------------------
ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(size = 1.5) +
  scale_imf_colors() +  # ✅ Apply IMF Colors
  labs(title = "Test: IMF Line Chart Colors", subtitle = "Checking if scale_imf_colors() applies correctly")

# ------------------------------
# 2️⃣ Test Stacked Bar Chart (IMF Colors vs Default)
# ------------------------------
ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_imf_colors() +  # ✅ Apply IMF Colors
  labs(title = "Test: IMF Stacked Bar Colors", subtitle = "Checking if scale_imf_colors() applies correctly")

# ------------------------------
# 3️⃣ Test Scatter Plot (IMF Colors vs Default)
# ------------------------------
ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  scale_imf_colors() +  # ✅ Apply IMF Colors
  labs(title = "Test: IMF Scatter Colors", subtitle = "Checking if scale_imf_colors() applies correctly")


# ------------------------------
# TESTING THE IMF THEME PANEL NOW
# ------------------------------

library(ggplot2)
library(dplyr)
library(patchwork)  # Required for combining multiple plots
library(bookr)  # Load bookr to check default colors

# Generate test data (12 months)
set.seed(123)
test_data <- data.frame(
  dates = seq(as.Date("2020-01-01"), by = "months", length.out = 12),
  category = rep(c("A", "B", "C"), each = 4),
  value1 = runif(12, 50, 100),
  value2 = runif(12, 20, 80)
)

# ------------------------------
# 1️⃣ Create Individual Plots with Titles & Subtitles
# ------------------------------

# Line Chart
p1 <- ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(size = 1.5) +
  scale_imf_colors() +
  labs(title = "IMF Line Chart", subtitle = "Example of a line chart using IMF colors")

# Stacked Bar Chart
p2 <- ggplot(test_data, aes(dates, value1, fill = category)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_imf_colors() +
  labs(title = "IMF Stacked Bar Chart", subtitle = "Example of a stacked bar chart")

# Scatter Plot
p3 <- ggplot(test_data, aes(value1, value2, color = category)) +
  geom_point(size = 3) +
  scale_imf_colors() +
  labs(title = "IMF Scatter Plot", subtitle = "Example of a scatter plot")

# ------------------------------
# 2️⃣ Combine the Plots with `patchwork`
# ------------------------------
combined_plot <- (p1 | p2) / p3  +
  plot_annotation(title = "Panel Test: `theme_imf_panel()`",
                  subtitle = "Checking multiple plots in a panel layout") &
  theme_imf_panel()  # 🔥 Apply IMF Panel Theme to all plots

# ------------------------------
# 3️⃣ Display the Final Combined Plot
# ------------------------------
combined_plot

##Test Additions of Lines to a bar plot
plot_bar_chart(
  input_data = test_data,
  var_x = "category",
  var_y = "value1"
  )

#Testing the standardizing of heigh and width into the functions
#check the saved plot that is automatically saved as PNG using the chart functions
plot_line_chart(
  input_data = test_data,
  var_x = "dates",
  var_y = "value1",
  plotname = "test_line_chart.png",  # Automatically saves as PNG
  plot_title = "IMF Line Chart Example",
  plot_subtitle = "Testing default width, height, and theme settings"
)

plot_bar_chart(
  input_data = test_data,
  var_x = "category",
  var_y = "value1",
  plotname = "test_bar_chart.png",  # Automatically saves as PNG
  plot_title = "IMF Bar Chart Example",
  plot_subtitle = "Verifying correct IMF color scheme and formatting"
)
plot_scatter_chart(
  input_data = test_data,
  var_x = "value1",
  var_y = "value2",
  plotname = "test_scatter_chart.png",  # Automatically saves as PNG
  plot_title = "IMF Scatter Plot Example",
  plot_subtitle = "Ensuring correct point styling and regression line"
)

#Testing the global setting of height and width specifications
p <- ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(size = 1.5) +
  scale_imf_colors() +
  labs(title = "IMF Line Chart Example", subtitle = "Testing Global Defaults")

ggsave_imf(p, "test_imf_chart.png")  # ✅ Should correctly use 9.46" x 6.85"

#Testing New Function on dual axis plots
df <- tibble::tibble(
  date = seq.Date(from = as.Date("2020-01-01"), by = "month", length.out = 12),
  left = rnorm(12, 100, 10),
  right = rnorm(12, 5, 1)
)

plot_dual_axis(
  df,
  left, right,
  plot_title = "Sample Dual Axis Chart",
  plot_subtitle = "Retail Sales vs Inflation Index (2020–2021)",
  y_left_lbl = "Retail Sales",
  y_right_lbl = "Inflation Index"
)
