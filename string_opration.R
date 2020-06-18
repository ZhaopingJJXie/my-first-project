library(rvest)
library(tidyverse)

# read in raw murders data from Wikipedia
url <- "https://en.wikipedia.org/w/index.php?title=Gun_violence_in_the_United_States_by_state&direction=prev&oldid=810166167"
murders_raw <- read_html(url) %>% 
    html_nodes("table") %>% 
    html_table() %>%
    .[[1]] %>%
    setNames(c("state", "population", "total", "murder_rate"))
class(murders_raw)
str(murders_raw)
# inspect data and column classes
head(murders_raw)
class(murders_raw$population)
class(murders_raw$total)

#detect whether there are commas
test_1 <- str_replace_all(murders_raw$population, ",", "")
tese_1 <- as.numeric(test_1)

#parse murder also removes comma and vonverts to numeric 
test_2 <- parse_number(murders_raw$population)
identical(test_1, test_2)

murders_new <- murders_raw %>% mutate_at(2:3, parse_number)
murders_new