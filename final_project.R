# 2019-14505 엄세희
# 수시과제2
# 연령에 따른 감성분석


library(tidyverse)
library(jsonlite)


files = list.files(pattern = "^S.+json$", full.names = T)

# 말뭉치 데이터 (감성분석 대상)
get_utterance <- function(x) {
  json_utterance = fromJSON(x) %>% .$document %>% .$utterance
  bind_rows(json_utterance)
}
df_spoken = map(files, get_utterance) %>% bind_rows()

# 화자 데이터
get_speaker <- function(x) {
  json = fromJSON(x) %>% .$document %>% .$metadata %>% .$speaker
}
df_speaker = map(files, get_speaker) %>% bind_rows()


# 문장으로 분리한 데이터프레임
df_spoken_sentence = df_spoken %>% 
  mutate(end = str_detect(original_form, pattern ="(\\.|\\?|\\!)" )) %>% 
  mutate(sentence_no = cumsum(end) %>% lag() + 1) %>% 
  mutate(sentence_no = ifelse(is.na(sentence_no), 1, sentence_no)) %>% 
  mutate(doc_id = str_extract(id, "SDRW[0-9]+")) %>% 
  mutate(seq_id = str_extract(id, "[0-9]+$")) %>% 
  select(doc_id, speaker_id, sentence_no, seq_id, original_form)

df_collapsed_sentence = df_spoken_sentence %>% group_by(doc_id, speaker_id, sentence_no) %>% 
  summarise(sentence = str_c(original_form, collapse = " "))

# 감성분석을 위해 sentence number가 붙은 단어들로 나눔
df_spoken_word = df_collapsed_sentence %>% 
  mutate(word = str_split(sentence, " ")) %>% 
  unnest(word) %>% 
  select(doc_id, speaker_id, sentence_no, word)



# 감성사전
sentiment = fromJSON("https://raw.githubusercontent.com/park1200656/KnuSentiLex/master/data/SentiWord_info.json")
df_sentiment = sentiment %>% filter(nchar(word_root)> 1) %>% select(word_root, polarity) %>%  
  unique() %>%  group_by(word_root) %>% summarise(polarity = max(polarity)) %>% mutate(polarity = as.numeric(polarity))

# 단어로 분리된 데이터프레임 감성분석

# 화자별 분석
sentiment_by_speaker = df_spoken_word %>% 
  left_join(df_sentiment, by = c("word" ="word_root")) %>% 
  arrange(polarity) %>% 
  group_by(doc_id, speaker_id) %>% summarise(sum = sum(polarity, na.rm = T)) %>% select(doc_id, id=speaker_id, sum)




df_speaker <- df_speaker %>% left_join(sentiment_by_speaker, by = "id")
df_speaker %>% ggplot(aes(x=age, y = sum, color=sex)) + geom_point()

df_sent_mean = df_speaker %>% select(age, sum) %>% group_by(age) %>% summarise(n= n(), Mean = mean(sum))
df_sent_variance = df_speaker %>%  select(id, age, sum) %>% group_by(age) %>% 
  mutate(mean_age = mean(sum),
         sd_age = sum - mean(sum)) %>% 
  ungroup() %>% 
  mutate(mean = mean(sum), sd = sum - mean(sum)) %>% 
  mutate(variance_within_age = sd_age^2) %>% 
  mutate(variance_among_age = (mean-mean_age)^2)

df_sent_variance %>% rmarkdown::paged_table()

result = aov(sum ~ age, data = df_speaker)
broom::tidy(result) # f value: 10.4 (그룹 간 분산평균/그룹 내 분산평균)


df_sent_variance %>% 
  ggplot(aes(x = age, y = variance_within_age)) + geom_point()

df_sent_variance %>% 
  ggplot(aes(x = age, y = variance_among_age)) + geom_point()

df_sent_variance %>% 
  ggplot(aes(x=age, y = sum)) + geom_boxplot()
