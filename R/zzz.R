# This function runs automatically when the package is attached (library(bookr))
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
  packageStartupMessage("Bookr package has been loaded.")
}
