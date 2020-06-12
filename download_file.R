#download file from internet

url <- "https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"
dat <- read_csv(url)
download.file(url, "murders_downloaded.csv")
tempfile()
temp_filename <- tempfile()
download.file(url,temp_filename )
dat <- read_csv(temp_filename)
file.remove(temp_filename)