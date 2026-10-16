.onLoad <- function(libname, pkgname) {
  
  package_options <- list(
    imf_plot_width = 9.46,
    imf_plot_height = 6.85,
    imf_dpi = 600
  )
  
  current_options <- options()
  options_to_set <- !names(package_options) %in% names(current_options)
  
  if (any(options_to_set)) {
    options(package_options[options_to_set])
  }
  
  
  if (.Platform$OS.type == "windows") {
    grDevices::windowsFonts(
      `Segoe UI` = grDevices::windowsFont("Segoe UI")
    )
    grDevices::windowsFonts(
      `Arial` = grDevices::windowsFont("Arial")
    )
  }
}




.onAttach <- function(libname, pkgname) {
  
  
  packageStartupMessage("IMFBookr loaded.")
}