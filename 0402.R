library(tidyverse)
library(ggrepel)

sample_df = read_csv("df_meta_new.csv")
colnames(sample_df) <-
  c("doc_id", "title", "author", "publisher", "date", "topic", "original_topic", "genre", "random_no")

new_data <- sample_df %>%
  filter(genre == "신문") %>% 
  group_by(publisher) %>% 
  mutate(title_length = str_length(title)) %>% 
  mutate(topic_length = str_length(topic)) %>%
  summarise(tit_len = mean(title_length), top_len = mean(topic_length), freq = n())
  
ggplot(new_data, mapping = aes(x = top_len, y = tit_len, color = freq, label = publisher)) +
  geom_point() +
  geom_text_repel()




