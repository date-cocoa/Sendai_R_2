# import data
tohoku_html <- read_html("https://www.kibutu.com/kibutu.php?university=tohoku") 

# get html in prof names
prof_html <- 
  tohoku_html %>% 
  html_nodes("a") %>% 
  html_attr("href")
tar_url <- prof_html[15:(length(prof_html) - 1)] %>%  #15から教員名のurl, 最後はtwitterのURL
  as.list()
home_url <- "https://www.kibutu.com/"

system.time(
  tar_url[1:100] %>% # Extract sub part of full data to test code.
    map(~paste0(home_url, .x) %>% read_html %>% 
          html_nodes('table') %>% html_text %>% 
          .[8] %>% # .[7]) # The 8th element is more tidyer than 7th one
          str_remove_all('\\r|\\n') %>% 
          # Use `str_split_fixed to constrain maximum elements`
          str_split_fixed('教官|教科（講座）|投稿者|投稿日|評価|テスト|レポート|出席|コメント', n = 10) ) %>% 
    # Set name to convert data frame and transpose.
    set_names(1:length(.)) %>% map_df(~.x) %>% t %>% 
    # Set col name
    `colnames<-`(c('none', 'Teacher' ,'Class' ,'Reviewer' ,'Date' ,'Difficulty' ,'Test' ,'Report' ,'Attendance' ,'Comments')) %>% 
    as_tibble()
)

# It takes 13 ~ 15 seconds to read 100 table.
# It is expected that it takes more than 15 minutes to read all data.
# Let's read all data.
system.time(
  tohoku_uni <- tar_url %>%
    map(~paste0(home_url, .x) %>% read_html %>% 
          html_nodes('table') %>% html_text %>% .[8] %>% 
          str_remove_all('\\r|\\n') %>% 
          str_split_fixed('教官|教科（講座）|投稿者|投稿日|評価|テスト|レポート|出席|コメント', n = 10) ) %>% 
    set_names(1:length(.)) %>% map_df(~.x) %>% t %>% 
    `colnames<-`(c('none', 'Teacher' ,'Class' ,'Reviewer' ,'Date' ,'Difficulty' ,'Test' ,'Report' ,'Attendance' ,'Comments')) %>% 
    as_tibble()
)

# result
# ユーザ   システム       経過  
# 74.282      7.070   1152.915 
# 
# If you are not patient enough to wait this slowly process, `furrr` pkg is recommended
library(furrr)
plan(multisession)

system.time(
  tohoku_uni_future<- tar_url %>%
    future_map(~paste0(home_url, .x) %>% read_html %>% 
          html_nodes('table') %>% html_text %>% .[8] %>% 
          str_remove_all('\\r|\\n') %>% 
          str_split_fixed('教官|教科（講座）|投稿者|投稿日|評価|テスト|レポート|出席|コメント', n = 10) , .progress = TRUE) %>% 
    set_names(1:length(.)) %>% map_df(~.x) %>% t %>% 
    `colnames<-`(c('none', 'Teacher' ,'Class' ,'Reviewer' ,'Date' ,'Difficulty' ,'Test' ,'Report' ,'Attendance' ,'Comments')) %>% 
    as_tibble()
)
# Result !!!!?
# ユーザ   システム       経過  
# 1.791      0.255    136.854 
# `future_map` is about 10 times faster than `map` !
# Additionaly you can use `.progress` option, which show progress bar.

write_csv(tohoku_uni, 'tohoku_uni_tbl.csv')


