# Map version

#### library ####
library(tidyverse) 
library(rvest)

#### All Universities ####
original_html <- read_html("https://www.kibutu.com")

pref <- 
  original_html %>% 
  html_nodes('a') %>% 
  html_attr('href') %>% 
  tibble() %>% 
  slice(1:47) # 最後の2つは関係ないので削除

## get every pref html
pref_url <- transpose(pref) %>% map(~paste0('https://www.kibutu.com/', .x))

## get every univ html in pref and its name
url_cont <- pref_url %>% map(~html_attr(html_nodes(read_html(.x), 'a'), 'href')[-1]) 
name_cont <- pref_url %>% map(~ read_html(.x) %>% html_nodes('a') %>% html_attr('href') %>% .[-1])

## get items in the universiy
# Modify `read_html` to show URL
read_html_with_show <- function(x, ...){
  cat('Reading', x, '....\n')
  x %>% read_html(...)
}
# Test Run
url_cont %>% map(~as.list(.x)) %>% .[[1]] %>% map(~read_html_with_show(.x) %>% html_nodes('a') %>% html_attr('href'))
# Convert `url_cont` to list of list type
url_cont <- url_cont %>% map(~as.list(.x))
info_uni <- url_cont %>% map(~map(~read_html_with_show(.x) %>% html_nodes('a') %>% html_attr('href')))
info_uni_named <- map2(.x = info_uni, .y = url_cont, 
                       .f = function(x, y){
                         univ_name <- map(y, ~str_split(.x, "=", simplify = TRUE) %>% .[1, 2])
                         names(x) <- univ_name
                         univ_name %>% map( ~cat('University Name = ', .x, '\n') )
                         x
                       }
)
# table of the nember of classes reviewed
univ_in_pref <- info_uni_named %>% 
  map(~map(.x, ~str_count(.x, 'search2') %>% sum)) %>% 
  flatten() %>% 
  as_tibble(.name_repair = 'unique') %>% t %>% as_tibble(rownames = NA) %>%  rownames_to_column(var = 'name')

write_csv(univ_in_pref, 'univ_in_pref2.csv')

#### TOHOKU University ####


