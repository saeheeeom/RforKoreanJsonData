# 1202
# 2019-14505 엄세희

library(tidyverse)
library(jsonlite)

files = list.files(pattern = "^S.+json$", full.names = T)
files

get_meta <-function(x) {
  json = fromJSON(x)
  c(id = json$document$id, json$document$metadata)
}
df_meta = map(files, get_meta) %>% bind_rows()

get_speaker <- function(x) {
  json = fromJSON(x) %>% .$document %>% .$metadata %>% .$speaker
}
df_speaker = map(files, get_speaker) %>% bind_rows()




get_utterance <- function(x) {
  json_utterance = fromJSON(x) %>% .$document %>% .$utterance
  bind_rows(json_utterance)
}
df_spoken = map(files, get_utterance) %>% bind_rows()
df_spoken = df_spoken %>% select(speaker_id, sentence = form)
df_spoken = df_spoken %>% mutate(doc_id= str_sub(speaker_id, 1,14)) %>% select(doc_id, speaker_id, sentence)
df_collapse = df_spoken %>% group_by(doc_id, speaker_id) %>% mutate(whole_sentence = sentence %>% unlist() %>% str_c(collapse = " ")) %>% 
  select(doc_id, speaker_id, whole_sentence) %>% unique()
df_sentence = df_collapse %>% 
  mutate(sentence = str_split(whole_sentence, "(\\.|\\?|//!)")) %>% 
  unnest(sentence) %>% select(-whole_sentence)

df_sentence
