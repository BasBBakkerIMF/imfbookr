
#When initially loading, perform these steps
#install.packages("devtools")
#install.packages("usethat")
#install.packages("roxygen2")
#library(devtools)
#library(usethat)
#library(roxygen2)

#Runall when making package changes
#Restart R session
devtools::document()
devtools::load_all()
devtools::install()
library(imfbookr)  # Reload the updated package

