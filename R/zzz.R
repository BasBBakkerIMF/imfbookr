# This runs once when the namespace is loaded (before attach)
.onLoad <- function(libname, pkgname) {
  # Register Segoe UI only on Windows
  if (.Platform$OS.type == "windows") {
    grDevices::windowsFonts(SegoeUI = grDevices::windowsFont("Segoe UI"))
  }
  
  # Set package option for primary font
  op <- options()
  op.imfbookr <- list(
    imfbookr.primary_font =
      if ("SegoeUI" %in% names(grDevices::windowsFonts())) "SegoeUI" else "Arial"
  )
  toset <- !(names(op.imfbookr) %in% names(op))
  if (any(toset)) options(op.imfbookr[toset])
}

# This runs when user calls library(bookr)
.onAttach <- function(libname, pkgname) {
  # Ensure grid is available for unit()
  if (!requireNamespace("grid", quietly = TRUE)) {
    stop("Package 'grid' is required but not installed.")
  }
  
  # ✅ Set IMF Theme Globally
  ggplot2::theme_set(bookr::theme_imf())
  
  # ✅ Set Global Defaults for Plot Width, Height, and DPI
  options(imf_plot_width = 9.46)
  options(imf_plot_height = 6.85)
  options(imf_dpi = 600)
  
  # ✅ Inform the user
  packageStartupMessage("IMFBookr package has been loaded.")
}
