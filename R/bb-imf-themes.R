#' Convert RGB values to a color string
#'
#' @param red Red component (0-255).
#' @param green Green component (0-255).
#' @param blue Blue component (0-255).
#' @return A color string.
#' @export
rgb2 <- function(red, green, blue) {
  rgb(red, green, blue, maxColorValue = 255)
}
reoHeight <- 2 * 1.82
reoWidth <- 2 * 2.92
blue <- rgb2(0, 76, 151)
green <- rgb2(150, 186, 121)
red <- rgb2(192, 0, 80)
grey <- rgb2(166, 168, 172)
light_green <- rgb2(150, 215, 130)
light_grey <- rgb2(211, 211, 211)
light_red <- rgb2(238, 36, 0)
dark_red <- rgb2(144, 0, 0)
light_blue <- rgb2(202, 224, 251)
dark_blue <- rgb2(14, 16, 116)
purple <- rgb2(146, 60, 194)
orange <- rgb2(255, 133, 71)
# Preserve the package's existing exported color names.
#' IMF blue
#' @export
imfblue <- blue
#' IMF green
#' @export
imfgreen <- green
#' IMF red
#' @export
imfred <- red
#' IMF grey
#' @export
imfgrey <- grey
#' IMF light blue
#' @export
imflight_blue <- light_blue
#' IMF light green
#' @export
imflight_green <- light_green
#' IMF light red
#' @export
imflight_red <- light_red
#' IMF light grey
#' @export
imflight_grey <- light_grey
#' IMF dark red
#' @export
imfdark_red <- dark_red
#' IMF dark blue
#' @export
imfdark_blue <- dark_blue
#' IMF purple
#' @export
imfpurple <- purple
#' IMF orange
#' @export
imforange <- orange
#' List of IMF colors
#'
#' @export
A4_colors <- c(
  blue,
  green,
  grey,
  light_green,
  light_grey,
  light_red,
  dark_red
)
#' List of IMF colors for bar charts
#'
#' @export
A4_colors_bar <- c(
  blue,
  green,
  red,
  grey,
  "black",
  light_green,
  light_grey,
  light_red,
  dark_red
)
#' Apply IMF colors to ggplot2 scales
#'
#' @param n Optional number of categories.
#' @return A list of ggplot2 color and fill scales.
#' @export
scale_imf_colors <- function(n = NULL) {
  available_colors <- A4_colors_bar
  if (!is.null(n) && n > length(available_colors)) {
    warning("Not enough predefined IMF colors. Recycling colors.")
    available_colors <- rep(
      available_colors,
      length.out = n
    )
  }
  list(
    ggplot2::scale_color_manual(values = available_colors),
    ggplot2::scale_fill_manual(values = available_colors)
  )
}

segoe_font <- "Segoe UI"
arial_font <- "Arial"


#' IMF ggplot2 theme
#'
#' @param myfont Font family. Defaults to Segoe UI when installed,
#'   otherwise "sans".
#' @param myfontColor Color used for plot title and subtitle.
#' @param use_imf_colors Retained for backwards compatibility.
#' @param legend_title_format Formatting for legend title.
#' @param legend_position Legend position.
#' @param legend_direction Legend direction.
#' @param legend_key_height Height of legend keys.
#' @param legend_key_width Width of legend keys.
#' @param legend_spacing_x Horizontal legend spacing.
#' @param legend_spacing_y Vertical legend spacing.
#'
#' @return A ggplot2 theme.
#' @export
theme_imf <- function(
    myfont = segoe_font,
    myfontColor = blue,
    use_imf_colors = TRUE,
    legend_title_format = ggplot2::element_blank(),
    legend_position = "bottom",
    legend_direction = "horizontal",
    legend_key_height = grid::unit(0.45, "cm"),
    legend_key_width = grid::unit(1.3, "cm"),
    legend_spacing_x = grid::unit(0.2, "cm"),
    legend_spacing_y = grid::unit(0.25, "cm")
) {
  message("theme_imf font: ", myfont)
  ggplot2::theme_classic() +
    ggplot2::theme(
      text = ggplot2::element_text(
        size = 14,
        family = myfont
      ),
      axis.text = ggplot2::element_text(
        color = "black",
        size = 14,
        family = myfont
      ),
      axis.text.x = ggplot2::element_text(
        size = 14,
        family = myfont
      ),
      axis.text.y = ggplot2::element_text(
        size = 14,
        family = myfont,
        margin = ggplot2::margin(
          t = 0,
          r = 3.5,
          b = 0,
          l = 0,
          unit = "mm"
        )
      ),
      axis.title.x = ggplot2::element_text(
        size = 14,
        family = myfont
      ),
      axis.title.y = ggplot2::element_text(
        size = 14,
        family = myfont
      ),
      axis.title.y.right = ggplot2::element_text(
        size = 14,
        family = myfont
      ),
      axis.ticks.x = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_line(
        colour = light_grey
      ),
      axis.ticks.length.y = grid::unit(
        -2,
        "mm"
      ),
      plot.title = ggplot2::element_text(
        size = 18,
        colour = myfontColor,
        family = myfont,
        face = "bold"
      ),
      plot.subtitle = ggplot2::element_text(
        size = 16,
        family = myfont,
        colour = myfontColor,
        face = "plain"
      ),
      panel.border = ggplot2::element_rect(
        colour = light_grey,
        fill = NA,
        linewidth = 1
      ),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(
        colour = light_grey
      ),
      plot.margin = ggplot2::margin(
        t = 0.2,
        r = 0.2,
        b = 0.2,
        l = 0.2,
        unit = "cm"
      ),
      plot.caption = ggplot2::element_text(
        hjust = 0,
        vjust = 5,
        size = 12,
        family = myfont
      ),
      legend.title = legend_title_format,
      legend.position = legend_position,
      legend.direction = legend_direction,
      legend.key.height = legend_key_height,
      legend.key.width = legend_key_width,
      legend.spacing.x = legend_spacing_x,
      legend.spacing.y = legend_spacing_y
    )
}
#' IMF panel ggplot2 theme
#'
#' @param myfont Font family. Defaults to Segoe UI when installed,
#'   otherwise "sans".
#' @param myfontColor Color used for plot title and subtitle.
#' @param legend_title_format Formatting for legend title.
#' @param legend_position Legend position.
#' @param legend_direction Legend direction.
#' @param legend_key_height Height of legend keys.
#' @param legend_key_width Width of legend keys.
#' @param legend_spacing_x Horizontal legend spacing.
#' @param legend_spacing_y Vertical legend spacing.
#'
#' @return A ggplot2 theme for panel charts.
#' @export
theme_imf_panel <- function(
    myfont = segoe_font,
    myfontColor = blue,
    legend_title_format = ggplot2::element_blank(),
    legend_position = "bottom",
    legend_direction = "horizontal",
    legend_key_height = grid::unit(0.45, "cm"),
    legend_key_width = grid::unit(1.3, "cm"),
    legend_spacing_x = grid::unit(0.2, "cm"),
    legend_spacing_y = grid::unit(0.25, "cm")
) {
  message("theme_imf_panel font: ", myfont)
  ggplot2::theme_classic() +
    ggplot2::theme(
      text = ggplot2::element_text(
        size = 14,
        family = myfont
      ),
      axis.text = ggplot2::element_text(
        color = "black",
        size = 10,
        family = myfont
      ),
      axis.text.x = ggplot2::element_text(
        size = 10,
        family = myfont
      ),
      axis.text.y = ggplot2::element_text(
        size = 10,
        family = myfont,
        margin = ggplot2::margin(
          t = 0,
          r = 3.5,
          b = 0,
          l = 0,
          unit = "mm"
        )
      ),
      axis.title.x = ggplot2::element_text(
        size = 10,
        family = myfont
      ),
      axis.title.y = ggplot2::element_text(
        size = 10,
        family = myfont
      ),
      axis.title.y.right = ggplot2::element_text(
        size = 10,
        family = myfont
      ),
      axis.ticks.x = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_line(
        colour = light_grey
      ),
      axis.ticks.length.y = grid::unit(
        -2,
        "mm"
      ),
      plot.title = ggplot2::element_text(
        size = 14,
        colour = myfontColor,
        family = myfont,
        face = "bold"
      ),
      plot.subtitle = ggplot2::element_text(
        size = 12,
        family = myfont,
        colour = myfontColor,
        face = "plain"
      ),
      panel.border = ggplot2::element_rect(
        colour = light_grey,
        fill = NA,
        linewidth = 1
      ),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(
        colour = light_grey
      ),
      plot.margin = ggplot2::margin(
        t = 0.2,
        r = 0.2,
        b = 0.2,
        l = 0.2,
        unit = "cm"
      ),
      plot.caption = ggplot2::element_text(
        hjust = 0,
        vjust = 5,
        size = 12,
        family = myfont
      ),
      legend.title = legend_title_format,
      legend.position = legend_position,
      legend.direction = legend_direction,
      legend.key.height = legend_key_height,
      legend.key.width = legend_key_width,
      legend.spacing.x = legend_spacing_x,
      legend.spacing.y = legend_spacing_y
    )
}