#path and working diretory

#see working directory
getwd()

#change your working directory
# setwd()

#set path to the locatin for raw data files in the dslabs and list files 
path <- system.file("extdata", package = "dslabs")
list.files(path)

#generate a full path to a file
filename <- "murders.csv"
fullpath <- file.path(path, filename)
fullpath

#copy file from dalabs package to your working directory
file.copy(fullpath, getwd())

#check id the file exists
file.exists(filename)