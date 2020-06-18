#case study: extracting a table from a PDF

#load library and data
library(dslabs)
data("research_funding_rates")
research_funding_rates

#downloading the data and import it into R 
library("pdftools")
temp_file <- tempfile()
url <- "http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf"
download.file(url, temp_file)
txt<- pdf_text(temp_file)
file.remove(temp_file)
txt %>% head()

# examine the object text and notice that it is a character vector with an entry 
# for each page, so we keep the page we want 
raw_data_research_funding_rates <-txt[2]

#create a list of lines of the text as elements
tab <- str_split(raw_data_research_funding_rates, "\n")
class(tab)
tab %>% head()
tab <- tab[[1]]

#the column information is spread across two lines
the_names_1 <- tab[3]
the_names_2 <- tab[4]

#remove the leading spaces and everything following the comma, split only when 
# there are 2 or more spaces to avoid splitting succes rate 
the_names_1 <- the_names_1 %>%
    str_trim() %>%
    str_replace_all(",\\s.", "") %>%
    str_split("\\s{2,}", simplify = TRUE)
the_names_1
#examine the second line
the_names_2
#trim the leading space and then split by space as we did for the first line
the_names_2 <- the_names_2 %>%
    str_trim() %>%
    str_split("\\s+", simplify = TRUE)
the_names_2
the_names_2

#we can join these to generate one name for each column 
tmp_names <- str_c(rep(the_names_1, each = 3), the_names_2[-1], sep = "_")
the_names <- c(the_names_2[1], tmp_names) %>%
    str_to_lower() %>%
    str_replace_all("\\s", "_")
the_names

new_research_funding_rates <- tab[6:14] %>%
    str_trim() %>%
    str_split("\\s{2,}", simplify = TRUE) %>%
    data.frame(stringsAsFactors = FALSE) %>%
    setNames(the_names) %>%
    mutate_at(-1, parse_number)
new_research_funding_rates %>% head()

identical(research_funding_rates, new_research_funding_rates)

