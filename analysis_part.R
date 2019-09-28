#### library ####
library(tidyverse)

#### all university ####
## read data
univ_in_pref <- read_csv('univ_in_pref.csv')

## visualize 
g <- 
  univ_in_pref %>% 
  ggplot(aes(x = V3)) +
  geom_histogram(bins = 100, fill = 'slategray4')  +
  xlab('N of evaluations') + ylab('')  +
  theme_bw()
print(g)
ggsave('N_of_items.jpeg', g)

## n of less than 10 items uni
univ_in_pref %>% 
  filter(V3 < 10) %>% 
  summarise(n = n())

## ranking
rank <- univ_in_pref[order(univ_in_pref$V3, decreasing = TRUE),]
print(rank)

#### tohoku university ####
## read data
tohoku_uni <- read_csv('tohoku_uni.csv') 

tohoku_uni$rec <- ifelse(tohoku_uni$rec == 'ど仏', 1, tohoku_uni$rec)
tohoku_uni$rec <- ifelse(tohoku_uni$rec == '仏', 2, tohoku_uni$rec)
tohoku_uni$rec <- ifelse(tohoku_uni$rec == 'やや仏', 3, tohoku_uni$rec)
tohoku_uni$rec <- ifelse(tohoku_uni$rec == '並', 4, tohoku_uni$rec)
tohoku_uni$rec <- ifelse(tohoku_uni$rec == 'やや鬼', 5, tohoku_uni$rec)
tohoku_uni$rec <- ifelse(tohoku_uni$rec == '鬼', 6, tohoku_uni$rec)
tohoku_uni$rec <- ifelse(tohoku_uni$rec == 'ど鬼', 7, tohoku_uni$rec)
tohoku_uni$rec <- ifelse(tohoku_uni$rec == 1 | tohoku_uni$rec == 2 | tohoku_uni$rec == 3 | 
                           tohoku_uni$rec == 4 | tohoku_uni$rec == 5| tohoku_uni$rec == 6 | 
                           tohoku_uni$rec == 7, tohoku_uni$rec, NA)
tohoku_uni$rec <- as.numeric(tohoku_uni$rec)

tohoku_uni$report <- ifelse(tohoku_uni$report == 'あり', 2, tohoku_uni$report)
tohoku_uni$report <- ifelse(tohoku_uni$report == '時々あり', 1, tohoku_uni$report)
tohoku_uni$report <- ifelse(tohoku_uni$report == 'なし', 0, tohoku_uni$report)
tohoku_uni$report <- ifelse(tohoku_uni$report == 2 | tohoku_uni$report == 1 | tohoku_uni$report == 0, tohoku_uni$report, NA)
tohoku_uni$report <- as.factor(tohoku_uni$report)               

              
tohoku_uni$attend <- ifelse(tohoku_uni$attend == 'あり', 2, tohoku_uni$attend)
tohoku_uni$attend <- ifelse(tohoku_uni$attend == '時々あり', 1, tohoku_uni$attend)
tohoku_uni$attend <- ifelse(tohoku_uni$attend == 'なし', 0, tohoku_uni$attend)
tohoku_uni$attend <- ifelse(tohoku_uni$attend == 2 | tohoku_uni$attend == 1 | tohoku_uni$attend == 0, tohoku_uni$attend, NA)
tohoku_uni$attend <- as.factor(tohoku_uni$attend)

tohoku_uni <- tohoku_uni %>% na.omit()

## visualize
# rec
g <- 
  tohoku_uni %>% 
  ggplot(aes(x = rec)) +
  geom_bar(fill = 'slategray4') +
  theme_bw() + xlab('Evaluation') + ylab('')
print(g)
ggsave('rec.jpeg', g)

# attend
g <- 
  tohoku_uni %>% 
  ggplot(aes(x = attend)) +
  geom_bar(fill = 'slategray4') +
  theme_bw() + xlab('Attendance') + ylab('')
print(g)
ggsave('attend.jpeg', g)

# report
g <- 
  tohoku_uni %>% 
  ggplot(aes(x = report)) +
  geom_bar(fill = 'slategray4') +
  theme_bw() + xlab('Report') + ylab('')
print(g)
ggsave('report.jpeg', g)

## correlation
g <- 
  tohoku_uni %>% 
  ggplot(aes(x = attend, y = rec)) +
  geom_boxplot(fill = 'slategray4') + theme_bw() + xlab('Attendance') + ylab('')
ggsave('cor_attend.jpeg', g)

g <- 
  tohoku_uni %>% 
  ggplot(aes(x = report, y = rec)) +
  geom_boxplot(fill = 'slategray4') + theme_bw() + xlab('Report') + ylab('')
ggsave('cor_report.jpeg', g)

res_glm <- glm(rec ~ report + attend, data = tohoku_uni, family = 'poisson')
res_glm %>% summary()

library(ggeffects)
g <- 
  ggpredict(res_glm, 'report', ci.lvl = 0.95) %>% plot() + 
  geom_hline(yintercept = mean(tohoku_uni$rec), linetype="dashed", col = 'red') +
  ylab('') + xlab('') + ggtitle('')
ggsave('prediction_report.jpeg', g)

g <- 
  ggpredict(res_glm, 'attend', ci.lvl = 0.95) %>% plot() + 
  geom_hline(yintercept = mean(tohoku_uni$rec), linetype="dashed", col = 'red') +
  ylab('') + xlab('') + ggtitle('')
ggsave('prediction_attend.jpeg', g)



