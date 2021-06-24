# 1203
# 2019-14505 엄세희

library(tidyverse)
library(jsonlite)

files = list.files(pattern = "^S.+json$", full.names = T)

get_utterance <- function(x) {
  json_utterance = fromJSON(x) %>% .$document %>% .$utterance
  bind_rows(json_utterance)
}
df_spoken = map(files, get_utterance) %>% bind_rows() %>% data.frame()
df_spoken = df_spoken %>% mutate(doc_id= str_sub(speaker_id, 1,14)) %>% select(doc_id, form)

df_long = df_spoken %>% mutate(wordList = str_split(form, " ")) %>% unnest(wordList)
df_long %>% summarise(totalword = n())
df_terms = df_long %>% group_by(doc_id, wordList) %>% summarise(wordCount = n()) %>% ungroup()
df_doc_total_words = df_long %>% group_by(doc_id) %>% summarise(wordTotalCount = n())
df_tf = df_terms %>% left_join(df_doc_total_words) %>% mutate(tf = wordCount/wordTotalCount)
df_idf = df_terms %>% select(wordList) %>% group_by(wordList) %>% summarise(df = n()) %>% mutate(docCount = nrow(df_doc_total_words)) %>% mutate(idf = log(docCount/df)) %>% ungroup()

df_tf_idf = df_tf %>% left_join(df_idf, by = "wordList") %>% 
  mutate(tf_idf = tf*idf) %>% arrange(desc(tf_idf))

df_tf_idf

top100list = df_tf_idf$wordList[1:100]

top100list
