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
pref_url <- numeric()
for(i in 1:47){
  pref_url[i] <- paste0("https://www.kibutu.com/", pref[i,])
}

## get every univ html in pref and its name
univ_in_pref <- tibble()
for(i in 1:47){
  url_cont <- 
    read_html(pref_url[i]) %>%  
    html_nodes('a') %>% 
    html_attr('href') %>% 
    as_tibble() %>% 
    slice(2:length(value)) #最初の1つは関係ないので削除
  
  name_cont <-
    read_html(pref_url[i]) %>%  
    html_nodes('a') %>% 
    html_text() %>% 
    as_tibble() %>% 
    slice(2:length(value)) #最初の1つは関係ないので削除
  
  data_cont <- bind_cols(url_cont, name_cont)
  univ_in_pref <- bind_rows(univ_in_pref, data_cont)
  
  Sys.sleep(0.3)
}

colnames(univ_in_pref) <- c('URL', 'Name')

## get items in the universiy
univ_in_pref[, 3] <- numeric(0)

for(i in 1:length(univ_in_pref$URL)){
  info_uni <-
    read_html(univ_in_pref$URL[i]) %>% 
    html_nodes('a') %>% 
    html_attr('href') 
  
  n_items = 0
  for(j in 1:length(info_uni)){
    if(str_detect(info_uni[j], 'search2')){n_items <- n_items + 1}
    else{n_items <- n_items}
  }
  
  univ_in_pref[i, 3] <- n_items 
  
  Sys.sleep(0.3)
}


write_csv(univ_in_pref, 'univ_in_pref.csv')

#### TOHOKU University ####

# import data
tohoku_html <- read_html("https://www.kibutu.com/kibutu.php?university=tohoku") 

# get html in prof names
prof_html <- 
  tohoku_html %>% 
  html_nodes("a") %>% 
  html_attr("href")
tar_url <- prof_html[15:(length(prof_html) - 1)] #15から教員名のurl, 最後はtwitterのURL

rec1 <- list()
report1 <-  list()
attend1 <- list()

rec2 <- list() # 時間がかかるので2つに分けて実施
report2 <-  list()
attend2 <- list()

n <- length(prof_html)

home_url <- "https://www.kibutu.com/"

for(i in 1:3000){
  sub_url <- tar_url[i]
  sub_data <- read_html(paste0(home_url, sub_url))
  
  sub_table <- sub_data %>% 
    html_nodes("table") %>% 
    html_text()
  
  sub_text <- sub_table[7]
  sub_text <- sub("テスト", "評価", sub_text)
  rep <- str_split(sub_text, "評価")
  rec1[i] <- rep[[1]][2]
  
  sub_text <- sub_table[7] 
  sub_text <- sub("出席", "レポート", sub_text)
  rep <- str_split(sub_text, "レポート")
  report1[i] <- rep[[1]][2]
  
  sub_text <- sub_table[7]
  sub_text <- sub("コメント", "出席", sub_text)
  rep <- str_split(sub_text, "出席")
  attend1[i] <- rep[[1]][2]
}

for(i in 3001:n){
  sub_url <- tar_url[i]
  sub_data <- read_html(paste0(home_url, sub_url))
  
  sub_table <- sub_data %>% 
    html_nodes("table") %>% 
    html_text()
  
  j <- i - 3000
  sub_text <- sub_table[7]
  sub_text <- sub("テスト", "評価", sub_text)
  rep <- str_split(sub_text, "評価")
  rec2[j] <- rep[[1]][2]
  
  sub_text <- sub_table[7] 
  sub_text <- sub("出席", "レポート", sub_text)
  rep <- str_split(sub_text, "レポート")
  report2[j] <- rep[[1]][2]
  
  sub_text <- sub_table[7]
  sub_text <- sub("コメント", "出席", sub_text)
  rep <- str_split(sub_text, "出席")
  attend2[j] <- rep[[1]][2]
}

rec <- c(rec1 %>% unlist(), rec2 %>% unlist())
report <- c(report1 %>% unlist(), report2 %>% unlist())
attend <- c(attend1 %>% unlist(), attend2 %>% unlist())

tohoku_uni <- 
  data.frame(rec = rec,
             report = report,
             attend = attend)
write_csv(tohoku_uni, 'tohoku_uni.csv')


