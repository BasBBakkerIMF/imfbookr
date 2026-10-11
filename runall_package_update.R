
#When initially loading, perform these steps
#install.packages("devtools")
#install.packages("usethat")
#install.packages("roxygen2")

#install.packages("dplyr")
library(dplyr)
library(devtools)
library(usethis)
library(roxygen2)
library(ggpubr)

#Runall when making package changes
#Restart R session
devtools::document()
devtools::load_all()
devtools::install()
library(imfbookr)  # Reload the updated package

