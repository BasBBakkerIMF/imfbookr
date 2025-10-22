.onLoad <- function(libname, pkgname) {
  if (.Platform$OS.type == "windows") {
    grDevices::windowsFonts(SegoeUI = grDevices::windowsFont("Segoe UI"))
  }
  has_segoe <- "SegoeUI" %in% names(grDevices::windowsFonts())
  op <- options()
  op.imfbookr <- list(imfbookr.primary_font = if (has_segoe) "SegoeUI" else "Arial")
  toset <- !(names(op.imfbookr) %in% names(op))
  if (any(toset)) options(op.imfbookr[toset])
  
  fam <- getOption("imfbookr.primary_font", "Arial")
  grDevices::pdf.options(family = fam)
  if (identical(Sys.info()[["sysname"]], "Darwin")) grDevices::quartz.options(family = fam)
  
  # OPTIONAL: uncomment to force every new Windows device to Segoe
  # if (.Platform$OS.type == "windows") {
  #   options(device = function(...) grDevices::windows(..., family = fam))
  # }
}

.onAttach <- function(libname, pkgname) {
  if (!requireNamespace("grid", quietly = TRUE)) stop("Package 'grid' is required but not installed.")
  if (.Platform$OS.type != "windows" && requireNamespace("showtext", quietly = TRUE)) {
    showtext::showtext_auto(enable = TRUE)
  }
  fam <- getOption("imfbookr.primary_font", "Arial")
  ggplot2::theme_set(bookr::theme_imf(myfont = fam))
  try(graphics::par(family = fam), silent = TRUE)  # helps base plots on RStudioGD
  options(imf_plot_width = 9.46, imf_plot_height = 6.85, imf_dpi = 600)
  packageStartupMessage("IMFBookr loaded.", fam)
}
