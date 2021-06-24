
library(tidyverse)

getwd()

list.files()
df_sample = read_csv("big_df_meta.csv")

# nrow() : 어떠한 배열에서의 행의 숫자
# ncol(): 어떠한 배열에서의 열의 숫자

df_sample$genre %>% table()

newdata <- df_sample %>% 
  select(title, date, genre) %>% 
  mutate(title_length = str_length(title))

ggplot(newdata,mapping = aes(x = date, y = title_length)) +
  geom_point() +
  facet_wrap(~genre) +
  geom_smooth(aes(x= date, y = title_length))
