# import a webpage into R
library(rvest)
url <- "https://en.wikipedia.org/wiki/Murder_in_the_United_States_by_state"
h <- read_html(url)
class(h)
h


tab <- h %>% html_nodes("table")
class(tab)
tab <- tab[[2]]

tab <- tab %>% html_table
class(tab)
tab <- tab %>% setNames(c("state", "population", "total", "murders", "gun_murders", "gun_ownership", "total_rate", "murder_rate", "gun_murder_rate"))
head(tab)
tab[1:2]
tab[1:2,]

h <- read_html("http://www.foodnetwork.com/recipes/alton-brown/guacamole-recipe-1940609")
recipe <- h %>% html_node(".o-AssetTitle__a-HeadlineText") %>% html_text()
prep_time <- h %>% html_node(".m-RecipeInfo__a-Description--Total") %>% html_text()
ingredients <- h %>% html_nodes(".o-Ingredients__a-Ingredient") %>% html_text()
guacamole <- list(recipe, prep_time, ingredients)
guacamole

get_recipe <- function(url){
    h <- read_html(url)
    recipe <- h %>% html_node(".o-AssetTitle__a-HeadlineText") %>% html_text()
    prep_time <- h %>% html_node(".m-RecipeInfo__a-Description--Total") %>% html_text()
    ingredients <- h %>% html_nodes(".o-Ingredients__a-Ingredient") %>% html_text()
    return(list(recipe = recipe, prep_time = prep_time, ingredients = ingredients))
}
get_recipe("http://www.foodnetwork.com/recipes/food-network-kitchen/pancakes-recipe-1913844")

library(rvest)
url <- "https://web.archive.org/web/20181024132313/http://www.stevetheump.com/Payrolls.htm"
h <- read_html(url)

nodes <- html_nodes(h, "table")
nodes
#html_text(nodes[[8]])
sapply(nodes[1:4], html_table)
nrow(nodes)
# sapply(nodes[21:23], html_table)
nodes[1]
nodes[[1]]
tab1 <- html_table(nodes[[10]]) 
tab2 <- html_table(nodes[[19]]) 
class(tab1)
class(tab2)
tab1
tab2
tab2 <- tab2 %>% slice(2:31)
tab1 <- tab1 %>%slice(2:31)%>%mutate(Team= X2, PayRoll = X3, Average = X4) %>%
        select(Team, PayRoll, Average) 
    tab2 <- tab2 %>% mutate(Team = X1, Payroll = X2)%>% 
    select(Team, Payroll)
tab2
# %>% mutate(Team = X1, Payroll = X2)%>%select(Team, Payroll)
tab1$Team
tab2$Team

tab_res <-tab1 %>%full_join(tab2, by="Team") 
tab_res
# tab_pay_2 <- tab_res%>% select(!is.na(Payroll.y))
# setdiff(tab_res, tab_pay_2)
tab3 <- html_table(nodes[[18]]) 
tab3    
#