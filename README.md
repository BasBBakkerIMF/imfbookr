# imfbookr

`imfbookr` provides helper functions to streamline IMF-style book writing with reproducible R code and standardized charting. It is based on the original `bookr` package, extended for IMF workflows.

---

## Pre-requisites

Before installing `imfbookr`, you need the latest version of the [`rsdmx`](https://github.com/opensdmx/rsdmx) package.  
You **cannot** install it from CRAN — you must install it from GitHub.

```r
# install devtools if you don't have it
install.packages("devtools")
library(devtools)
```
## Installing `imfbookr`

On most computers you can install directly from GitHub:

```r
library(remotes)
remotes::install_git("https://github.com/BasBBakkerIMF/imfbookr.git")
```
On some IMF computers that does not work. In that case, use this fallback:

```r
url <- "https://codeload.github.com/BasBBakkerIMF/imfbookr/tar.gz/HEAD"
tf  <- tempfile(fileext = ".tar.gz")

curl::curl_download(url, tf)        # fetch with curl
remotes::install_local(tf)          # install from the downloaded file
```

After installation, load the package with:
```r
library(imfbookr)
```