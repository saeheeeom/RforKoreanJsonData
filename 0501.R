# W05 - 01 과제
# 2019-14505 엄세희
library(tidyverse)
df_meta = read_csv("df_meta.csv", guess_max = 1001)
genre_mooneo <- df_meta %>%
  filter(genre == "문어") %>%
  select(title)
splitstring <- strsplit(genre_mooneo$title, split = ' ')
splitstring


