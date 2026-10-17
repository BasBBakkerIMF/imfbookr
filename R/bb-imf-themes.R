


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

#' IMF  overall panel title theme
#'
#' @return A ggplot2 theme.
#' @export
theme_imf_panel_title <- function() {
  ggplot2::theme(
    plot.title = ggplot2::element_text(
      family = "Arial",
      size = 16,
      face = "bold",
      colour = blue,
      hjust = 0.5
    ),
    plot.subtitle = ggplot2::element_text(
      family = "Arial",
      size = 12,
      colour = blue,
      hjust = 0.5
    )
  )
}

