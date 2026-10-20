## -----------------------------------------------------------------------------
## imfbookr basic check
##
## Checks that the exported colours, palettes, themes and save helpers work,
## then saves a small gallery of example charts so you can eyeball the styling.
##
## How to run (after installing imfbookr):
##   source("default_settings_basic_test.R")
## Needs: ggplot2 and imfbookr. patchwork is optional (used for the panel
## example only). Charts are saved in a `theme_tests` folder in your working
## directory (change `out_dir` below to save them elsewhere). In RStudio each
## example chart is also shown in the Plots pane as it is made; use the arrows
## there to flip back through them.
## -----------------------------------------------------------------------------

library(ggplot2)
library(imfbookr)

out_dir <- "theme_tests"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

## --- Small helpers ----------------------------------------------------------

results <- data.frame(check = character(), status = character(),
                      detail = character(), stringsAsFactors = FALSE)

# Run `expr`; it passes if it returns TRUE without an error.
check <- function(name, expr) {
  outcome <- tryCatch(
    {
      ok <- isTRUE(expr)
      list(status = if (ok) "PASS" else "FAIL",
           detail = if (ok) "" else "returned FALSE")
    },
    error = function(e) list(status = "FAIL", detail = conditionMessage(e))
  )
  results[nrow(results) + 1, ] <<- c(name, outcome$status, outcome$detail)
  cat(sprintf("[%s] %s%s\n", outcome$status, name,
              if (nzchar(outcome$detail)) paste0("  -> ", outcome$detail) else ""))
  invisible(outcome$status == "PASS")
}

is_colour <- function(x) {
  all(vapply(x, function(col) {
    !inherits(try(grDevices::col2rgb(col), silent = TRUE), "try-error")
  }, logical(1)))
}

# Width and height in pixels, read from the PNG header.
png_size <- function(path) {
  con <- file(path, "rb")
  on.exit(close(con))
  header <- readBin(con, "raw", 24)
  to_int <- function(b) sum(as.integer(b) * 256^(3:0))
  c(width = to_int(header[17:20]), height = to_int(header[21:24]))
}

## --- Example data -----------------------------------------------------------

set.seed(123)
test_data <- data.frame(
  dates    = seq(as.Date("2020-01-01"), by = "month", length.out = 12),
  category = rep(c("A", "B", "C"), each = 4),
  value1   = runif(12, 50, 100),
  value2   = runif(12, 20, 80)
)

## --- 1. Exports -------------------------------------------------------------

cat("\n== 1. Exports ==\n")

expected_exports <- c(
  "rgb2", "imfblue", "imfblue_2027", "imfgreen", "imfred", "imfgrey",
  "imflight_blue", "imflight_green", "imflight_red", "imflight_grey",
  "imfdark_red", "imfdark_blue", "imfpurple", "imforange",
  "A4_colors", "A4_colors_bar", "A4_colors_2027", "A4_colors_bar_2027",
  "scale_imf_colors", "scale_imf_colors_2027",
  "theme_imf", "theme_imf_panel", "theme_imf_panel_title",
  "theme_imf_2027", "theme_imf_panel_2027", "theme_imf_panel_title_2027",
  "get_dimensions", "save_plot", "%>%"
)
missing_exports <- setdiff(expected_exports, getNamespaceExports("imfbookr"))
check("All expected functions and colours are exported",
      length(missing_exports) == 0 ||
        stop("missing: ", paste(missing_exports, collapse = ", ")))

## --- 2. Colours and palettes ------------------------------------------------

cat("\n== 2. Colours and palettes ==\n")

single_colours <- list(imfblue, imfblue_2027, imfgreen, imfred, imfgrey,
                       imflight_blue, imflight_green, imflight_red,
                       imflight_grey, imfdark_red, imfdark_blue, imfpurple,
                       imforange)
check("Every named IMF colour is a valid colour",
      is_colour(unlist(single_colours)))
check("rgb2() builds hex colours", rgb2(0, 76, 151) == "#004C97")
check("imfblue_2027 is the 2027 blue (0, 76, 151)", imfblue_2027 == "#004C97")
check("imfblue is the IMF theme blue (75, 130, 173)", imfblue == "#4B82AD")

check("A4_colors has 7 valid colours",
      length(A4_colors) == 7 && is_colour(A4_colors))
check("A4_colors_bar has 9 valid colours",
      length(A4_colors_bar) == 9 && is_colour(A4_colors_bar))
check("A4_colors_2027 starts with the 2027 blue, rest unchanged",
      A4_colors_2027[1] == imfblue_2027 &&
        identical(A4_colors_2027[-1], A4_colors[-1]))
check("A4_colors_bar_2027 starts with the 2027 blue, rest unchanged",
      A4_colors_bar_2027[1] == imfblue_2027 &&
        identical(A4_colors_bar_2027[-1], A4_colors_bar[-1]))

## --- 3. Colour scales -------------------------------------------------------

cat("\n== 3. Colour scales ==\n")

for (scale_name in c("scale_imf_colors", "scale_imf_colors_2027")) {
  scale_fun <- get(scale_name)
  check(paste0(scale_name, "() returns a colour scale and a fill scale"), {
    s <- scale_fun()
    length(s) == 2 && all(vapply(s, inherits, logical(1), "Scale"))
  })
  check(paste0(scale_name, "(n = 12) warns that colours are recycled"),
        tryCatch({ scale_fun(n = 12); FALSE },
                 warning = function(w) grepl("Recycling", conditionMessage(w))))
}

check("scale_imf_colors_2027() puts the 2027 blue on the first series", {
  p <- ggplot(test_data, aes(dates, value1, color = category)) +
    geom_line() + scale_imf_colors_2027()
  first_series <- subset(ggplot_build(p)$data[[1]], group == 1)
  all(toupper(first_series$colour) == imfblue_2027)
})

## --- 4. Themes --------------------------------------------------------------

cat("\n== 4. Themes ==\n")

theme_names <- c("theme_imf", "theme_imf_panel", "theme_imf_panel_title",
                 "theme_imf_2027", "theme_imf_panel_2027",
                 "theme_imf_panel_title_2027")
for (theme_name in theme_names) {
  check(paste0(theme_name, "() returns a ggplot2 theme"),
        inherits(get(theme_name)(), "theme"))
}

check("theme_imf() uses Segoe UI and a blue title", {
  th <- theme_imf()
  th$text$family == "Segoe UI" && th$plot.title$colour == imfblue
})
check("theme_imf_2027() uses Arial and a black title", {
  th <- theme_imf_2027()
  th$text$family == "Arial" && th$plot.title$colour == "black"
})
check("theme_imf_panel_2027() uses Arial and a black title", {
  th <- theme_imf_panel_2027()
  th$text$family == "Arial" && th$plot.title$colour == "black"
})
check("theme_imf_panel_title() gives the panel title the IMF theme blue", {
  th <- theme_imf_panel_title()
  th$plot.title$colour == imfblue && th$plot.subtitle$colour == imfblue
})
check("theme_imf_panel_title_2027() gives the panel title the 2027 blue", {
  th <- theme_imf_panel_title_2027()
  th$plot.title$colour == imfblue_2027 && th$plot.subtitle$colour == imfblue_2027
})
check("Theme arguments are respected (legend_position = 'right')",
      theme_imf_2027(legend_position = "right")$legend.position == "right")

## --- 5. Chart sizes and saving ----------------------------------------------

cat("\n== 5. Chart sizes and saving ==\n")

expected_dims <- list(
  single     = list(width = 9.51,  height = 6.9),
  full_panel = list(width = 12.51, height = 15.64),
  half_panel = list(width = 11.68, height = 11.68)
)
for (type in names(expected_dims)) {
  check(paste0("get_dimensions('", type, "') matches the IMF size"), {
    d <- get_dimensions(type)
    d$width == expected_dims[[type]]$width &&
      d$height == expected_dims[[type]]$height
  })
}
check("get_dimensions() defaults to 'single'",
      identical(get_dimensions(), get_dimensions("single")))

save_test_plot <- ggplot(test_data, aes(dates, value1, color = category)) +
  geom_line(linewidth = 1.2) +
  scale_imf_colors_2027() +
  labs(title = "save_plot() test") +
  theme_imf_2027()

for (type in names(expected_dims)) {
  check(paste0("save_plot(type = '", type, "') writes a PNG at the right size"), {
    base <- file.path(out_dir, paste0("save_plot_", type))
    invisible(capture.output(
      save_plot(save_test_plot, base, dpi = 100, type = type)
    ))
    size <- png_size(paste0(base, ".png"))
    size[["width"]] == round(expected_dims[[type]]$width * 100) &&
      size[["height"]] == round(expected_dims[[type]]$height * 100)
  })
}
check("save_plot() saves at 600 dpi by default", {
  base <- file.path(out_dir, "save_plot_default_dpi")
  invisible(capture.output(save_plot(save_test_plot, base, type = "single")))
  png_size(paste0(base, ".png"))[["width"]] == round(9.51 * 600)
})
check("save_plot() rejects an unknown chart type",
      inherits(try(save_plot(save_test_plot, file.path(out_dir, "bad"),
                             type = "poster"), silent = TRUE), "try-error"))

## --- 6. Example data --------------------------------------------------------

cat("\n== 6. Example data ==\n")

check("Example dataset 'gdp' loads",
      is.data.frame(imfbookr::gdp) && nrow(imfbookr::gdp) > 0)
check("Example dataset 'ifs' loads",
      is.data.frame(imfbookr::ifs) && nrow(imfbookr::ifs) > 0)

## --- 7. Example charts (look at these) --------------------------------------

cat("\n== 7. Example charts ==\n")

make_charts <- function(scale, theme, label) {
  list(
    line = ggplot(test_data, aes(dates, value1, color = category)) +
      geom_line(linewidth = 1.5) + scale +
      labs(title = "Line chart", subtitle = label) + theme,
    bar = ggplot(test_data, aes(dates, value1, fill = category)) +
      geom_col(position = "stack") + scale +
      labs(title = "Stacked bar chart", subtitle = label) + theme,
    scatter = ggplot(test_data, aes(value1, value2, color = category)) +
      geom_point(size = 3) + scale +
      labs(title = "Scatter chart", subtitle = label) + theme
  )
}

charts <- c(
  setNames(make_charts(scale_imf_colors(), theme_imf(), "IMF theme"),
           paste0("imf_theme_", c("line", "bar", "scatter"))),
  setNames(make_charts(scale_imf_colors_2027(), theme_imf_2027(),
                       "IMF theme 2027"),
           paste0("imf_theme_2027_", c("line", "bar", "scatter")))
)

for (name in names(charts)) {
  check(paste0("Example chart '", name, "' renders and saves"), {
    path <- file.path(out_dir, paste0(name, ".png"))
    ggsave(path, charts[[name]], width = 9.51, height = 6.9, dpi = 100)
    file.exists(path)
  })
  if (interactive()) print(charts[[name]])
}

if (requireNamespace("patchwork", quietly = TRUE)) {
  library(patchwork)
  for (style in c("imf_theme_panel", "imf_theme_panel_2027")) {
    is_2027 <- style == "imf_theme_panel_2027"
    panel_charts <- make_charts(
      if (is_2027) scale_imf_colors_2027() else scale_imf_colors(),
      if (is_2027) theme_imf_panel_2027() else theme_imf_panel(),
      if (is_2027) "IMF panel theme 2027" else "IMF panel theme"
    )
    panel <- (panel_charts$line | panel_charts$bar) / panel_charts$scatter +
      plot_annotation(
        title = "Panel example",
        theme = if (is_2027) theme_imf_panel_title_2027() else theme_imf_panel_title()
      )
    check(paste0("Panel example '", style, "' renders and saves"), {
      path <- file.path(out_dir, paste0(style, ".png"))
      ggsave(path, panel, width = 12.51, height = 15.64, dpi = 100)
      file.exists(path)
    })
    if (interactive()) print(panel)
  }
} else {
  cat("[SKIP] Panel examples: install.packages('patchwork') to include them\n")
}

## --- Summary ----------------------------------------------------------------

n_fail <- sum(results$status == "FAIL")
cat("\n== Summary ==\n")
cat(sprintf("%d checks: %d passed, %d failed\n",
            nrow(results), nrow(results) - n_fail, n_fail))
if (n_fail > 0) {
  print(results[results$status == "FAIL", c("check", "detail")], row.names = FALSE)
}
cat("Example charts saved in:", normalizePath(out_dir), "\n")

if (!interactive() && n_fail > 0) {
  quit(status = 1)
}
