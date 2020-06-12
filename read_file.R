# read file 

library(dslabs)
library(tidyverse)
library(readxl)

#inspect the first 3 lines 
read_lines("murders.csv", n_max = 3)

#read file in CSV format
filename <- "murders.csv"
dat <- read_csv(filename)
class(dat)
head(dat)
#read_using full path
# path <- system.file("extdata", package = "dslabs")
fullpath <- file.path(path, filename)
dat <- read_csv(fullpath)
head(dat)

class(dat)
#Ex：
path <- system.file("extdata", package = "dslabs")
files <- list.files(path)
files

filename <- "murders.csv"
filename1 <- "life-expectancy-and-fertility-two-countries-example.csv"
filename2 <- "fertility-two-countries-example.csv"
dat=read.csv(file.path(path, filename))
head(dat)
dat1=read.csv(file.path(path, filename1))
head(dat1)
dat2=read.csv(file.path(path, filename2))
head(dat2)
