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
blue <- rgb2(75, 130, 173)
blue_2027 <- rgb2(0, 76, 151)
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
#' IMF 2027 blue
#' @export
imfblue_2027 <- blue_2027
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


#' List of IMF 2027 colors
#'
#' @export
A4_colors_2027 <- c(
  blue_2027,
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
A4_colors_bar_2027 <- c(
  blue_2027,
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
scale_imf_colors_2027 <- function(n = NULL) {
  available_colors <- A4_colors_bar_2027
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
