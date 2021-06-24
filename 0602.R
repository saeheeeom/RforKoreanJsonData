# 0602
library(tidyverse)
library(jsonlite)

json_spoken = fromJSON("SDRW2000000001.json")
df_spoken = json_spoken[[3]]$utterance[[1]]
# View(df_spoken) 이용해서 데이터 탐색

# df_spoken$form 말뭉치 데이터 확인
words <- strsplit(df_spoken$form, split = " ") %>% unlist()
spoken = as.data.frame(sort(table(words), decreasing=TRUE)[1:25])
ggplot(data = spoken) +
  geom_point(mapping = aes(x = words, y = Freq)) +
  coord_flip()
# 따라서 그래프 가장 밑 10개 어절이 가장 많이 쓰임 확인 가능
