# load stringr through tidyverse
library(tidyverse)

# detect whether a comma is present
pattern <- ","
str_detect(murders_raw$total, pattern) 


# show the subset of strings including "cm"
str_subset(reported_heights$height, "cm")

# use the "or" symbol inside a regex (|)
yes <- c("180 cm", "70 inches")
no <- c("180", "70''")
s <- c(yes, no)
str_detect(s, "cm") | str_detect(s, "inches")

str_detect(s, "cm|inches")

# highlight the first occurrence of a pattern

#install.packages("htmlwidgets")
str_view(s, pattern)

# highlight all instances of a pattern
str_view_all(s, pattern)

##########################################################

# s was defined in the previous video
yes <- c("5", "6", "5'10", "5 feet", "4'11")
no <- c("", ".", "Five", "six")
s <- c(yes, no)
pattern <- "\\d"

# [56] means 5 or 6
str_view(s, "[56]")

# [4-7] means 4, 5, 6 or 7
yes <- as.character(4:7)
no <- as.character(1:3)
s <- c(yes, no)
str_detect(s, "[4-7]")

# ^ means start of string, $ means end of string
pattern <- "^\\d$"
yes <- c("1", "5", "9")
no <- c("12", "123", " 1", "a4", "b")
s <- c(yes, no)
str_view(s, pattern)

# curly braces define quantifiers: 1 or 2 digits 
pattern <- "^\\d{1,2}$"
yes <- c("1", "5", "9", "12")
no <- c("123", "a4", "b")
str_view(c(yes, no), pattern)

# combining character class, anchors and quantifier
pattern <- "^[4-7]'\\d{1,2}\"$"
yes <- c("5'7\"", "6'2\"",  "5'12\"")
no <- c("6,2\"", "6.2\"","I am 5'11\"", "3'2\"", "64")
str_detect(yes, pattern)
str_detect(no, pattern)

#number of entries matching our desired pattern
pattern <- "^[4-7]'\\d{1,2}\"$"
sum(str_detect(problems, pattern))

#insepect examples of entries with problems
problems[c(2, 10 , 11, 12, 15)] %>% str_view(pattern)
str_subset(problems, "inches")
str_subset(problems, "''")

#replace or remove feet/inches words before matching
problems %>% str_replace("feet|ft|foot", "'") %>% 
            str_replace("inches|in|''|\"", "") %>%
            str_detect(pattern) %>%
            sum()

#R does not ignore whitespace
identical("Hi", "Hi ")

#\\s represents whitespace
pattern_2 <- "^[4-7]'\\s\\d{1,2}\"$"
str_subset(problems, pattern_2)

#* means 0+, ? means 0 or 1, + means 1+
# * means 0 or more instances of a character
yes <- c("AB", "A1B", "A11B", "A111B", "A1111B")
no <- c("A2B", "A21B")
str_detect(yes, "A1*B")
str_detect(no, "A1*B")

# test how *, ? and + differ
data.frame(string = c("AB", "A1B", "A11B", "A111B", "A1111B"),
           none_or_more = str_detect(yes, "A1*B"),
           nore_or_once = str_detect(yes, "A1?B"),
           once_or_more = str_detect(yes, "A1+B"))

# update pattern by adding optional spaces before and after feet symbol
pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
problems %>% 
    str_replace("feet|ft|foot", "'") %>% # replace feet, ft, foot with ' 
    str_replace("inches|in|''|\"", "") %>% # remove all inches symbols
    str_detect(pattern) %>% 
    sum()

############################################################
#define regex with and without groups
pattern_without_groups <- "^[4-7],\\d*$"
pattern_with_groups <-  "^([4-7]),(\\d*)$"

#create examples
yes <- c("5,9", "5,11", "6,", "6,1")
no <- c("5'9", ",", "2,8", "6.1.1")
s <- c(yes, no)

#demonstrate the effect of groups 
str_detect(s, pattern_without_groups)
str_detect(s, pattern_with_groups)

#demonstrate difference between str_match and str_extract
str_match(s, pattern_with_groups)

str_extract(s, pattern_with_groups)

    #improve the pattern to recognize more events 
pattern_with_groups <- "^([4-7]),(\\d*)$"
yes <- c("5,9", "5,11", "6,", "6,1")
no <- c("5'9", ",", "2,8", "6.1.1")
s <- c(yes, no)
str_replace(s, pattern_with_groups, "\\1'\\2")

# final pattern
pattern_with_groups <-"^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$"

# combine stringr commands with the pipe
str_subset(problems, pattern_with_groups) %>% head
str_subset(problems, pattern_with_groups) %>% 
    str_replace(pattern_with_groups, "\\1'\\2") %>% head

#########################################################

#function to detect entries with problems
not_inches_or_cm <- function(x, smallest = 50, tallest = 84){
    inches <- suppressWarnings(as.numeric(x))
    ind <- !is.na(inches) &
        ((inches >= smallest & inches <= tallest) |
             (inches/2.54 >= smallest & inches/2.54 <= tallest))
    !ind
}

#identify entries with problems
problems <- reported_heights %>%
    filter(not_inches_or_cm(height)) %>%
    .$height
length(problems)

converted <- problems %>% 
    str_replace("feet|foot|ft", "'") %>% #convert feet symbols to '
    str_replace("inches|in|''|\"", "") %>%  #remove inches symbols
    str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2") ##change format

# find proportion of entries that fit the pattern after reformatting
pattern <- "^[4-7]\\s*'\\s*\\d{1,2}$"
index <- str_detect(converted, pattern)
mean(index)

converted[!index]    # show problems

s <- c("70", "5 ft", "4'11", "", ".", "Six feet")
pattern <- "\\d|ft"
str_view_all(s, pattern )

animals <- c("cat", "puppy", "Moose", "MONKEY")
pattern <- "[a-z]{4,5}"
str_detect(animals, pattern)

problems <- c("5.3", "5,5", "6 1", "5 .11", "5, 12")
pattern_with_groups <- "^([4-7])[,\\.](\\d*)$"
str_replace(problems, pattern_with_groups, "\\1'\\2")

problems <- c("5.3", "5,5", "6 1", "5 .11", "5, 12")
pattern_with_groups <- "^([4-7])[,\\.\\s](\\d*)$"
str_replace(problems, pattern_with_groups, "\\1'\\2")

pattern <- "^([4-7])\\s*'\\s*(\\d+\\.?\\d*)$"

###################################################

convert_format <- function(s){
    s %>%
        str_replace("feet|foot|ft", "'") %>% #convert feet symbols to '
        str_replace_all("inches|in|''|\"|cm|and", "") %>%  #remove inches and other symbols
        str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2") %>% #change x.y, x,y x y
        str_replace("^([56])'?$", "\\1'0") %>% #add 0 when to 5 or 6
        str_replace("^([12])\\s*,\\s*(\\d*)$", "\\1\\.\\2") %>% #change european decimal
        str_trim() #remove extra space
}

words_to_numbers <- function(s){
    str_to_lower(s) %>%  
        str_replace_all("zero", "0") %>%
        str_replace_all("one", "1") %>%
        str_replace_all("two", "2") %>%
        str_replace_all("three", "3") %>%
        str_replace_all("four", "4") %>%
        str_replace_all("five", "5") %>%
        str_replace_all("six", "6") %>%
        str_replace_all("seven", "7") %>%
        str_replace_all("eight", "8") %>%
        str_replace_all("nine", "9") %>%
        str_replace_all("ten", "10") %>%
        str_replace_all("eleven", "11")
}
smallest <- 50
tallest <- 84
new_heights <- reported_heights %>% 
    mutate(original = height, 
           height = words_to_numbers(height) %>% convert_format()) %>%
    extract(height, c("feet", "inches"), regex = pattern, remove = FALSE) %>% 
    mutate_at(c("height", "feet", "inches"), as.numeric) %>%
    mutate(guess = 12*feet + inches) %>%
    mutate(height = case_when(
        !is.na(height) & between(height, smallest, tallest) ~ height, #inches 
        !is.na(height) & between(height/2.54, smallest, tallest) ~ height/2.54, #centimeters
        !is.na(height) & between(height*100/2.54, smallest, tallest) ~ height*100/2.54, #meters
        !is.na(guess) & inches < 12 & between(guess, smallest, tallest) ~ guess, #feet'inches
        TRUE ~ as.numeric(NA))) %>%
    select(-guess)

new_heights %>%
    filter(not_inches(original)) %>%
    select(original, height) %>% 
    arrange(height) %>%
    View()

new_heights %>% arrange(height) %>% head(n=7)    
