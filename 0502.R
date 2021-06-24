# W05 - 02 과제
# 2019-14505 엄세희
library(tidyverse)
df_meta = read_csv("df_meta.csv", guess_max = 1001)
genre_mooneo <- df_meta %>%
  filter(genre == "문어") %>%
  select(title)
splitstring <- strsplit(genre_mooneo$title, split = ' ')
words <- splitstring %>% unlist()
sort(table(words), decreasing=TRUE)[1:3]
# 따라서 '-', 그리고 숫자 '1'을 제외하고 가장 많이 쓰인 어절은
# '이야기' 임을 알 수 있습니다.
