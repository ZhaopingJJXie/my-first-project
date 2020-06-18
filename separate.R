#separate 
#first example -normally formatted heights
library(tidyverse)
s <- c("5'1", "6'1")
tab <- data.frame(x=s)

#separate and extract functions behaves similarly
tab %>%separate(x, c("feet", "inches"), sep = "'")
tab %>% extract(x, c("feet", "inches"), regex = "(\\d)'(\\d{1,2})")

# separate fails because it leaves in extra characters, but extract keeps only the digits because of regex groups
tab %>% separate(x, c("feet","inches"), sep = "'", fill = "right")
tab %>% extract(x, c("feet", "inches"), regex = "(\\d)'(\\d{1,2})")

s <- "Hi "
cat(s)
identical(s, "Hi")

str_trim("5 ' 9 ")
