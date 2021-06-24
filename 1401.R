# 1401
# 2019-14505 엄세희
# 각 문장별 감성 점수와 화자별 감성 점수

library(tidyverse)
library(jsonlite)


files = list.files(pattern = "^S.+json$", full.names = T)


get_utterance <- function(x) {
  json_utterance = fromJSON(x) %>% .$document %>% .$utterance
  bind_rows(json_utterance)
}
df_spoken = map(files, get_utterance) %>% bind_rows()


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
# 문장별 분석
df_spoken_word %>% 
  left_join(df_sentiment, by = c("word" ="word_root")) %>% 
  arrange(polarity) %>% 
  group_by(sentence_no) %>% dplyr::summarise(sum(polarity, na.rm = T)) %>% rmarkdown::paged_table()
# 화자별 분석
df_spoken_word %>% 
  left_join(df_sentiment, by = c("word" ="word_root")) %>% 
  arrange(polarity) %>% 
  group_by(doc_id, speaker_id) %>% dplyr::summarise(sum(polarity, na.rm = T)) %>% rmarkdown::paged_table()

# 감성분석 방식 개선안

# 1. 더 큰 corpus를 적용한 감성사전 이용하기: 신조어 등, 기존의 감성사전에 반영되지 않은 데이터를 추가한 사전 만들기
# 웹크롤링 등으로 얻은 문자열 자료에서, 아직 사전에 없는 단어를 찾는 경우, '하나의 단어의 긍정/부정적 감성은 함께 쓰인 
# 단어의 polarity 값으로 판단한다'는 전제 하에, 그 값을 결정한다.
# 2. '부정 + 부정 = 긍정'처럼, 예외사항 처리하기: 함께 쓰이면 긍정의 뜻으로 쓰이는 단어의 경우 예외적인 규칙 적용하기.
# 이 방법을 사용한다면, 단어 단위로 분리한 뒤 문장 단위로 합치는 대신, 문장에 for문을 사용하고 그 안에서 if문을 
# 사용하는 등을 선택해야 할 것임.
# 3. 동사의 어미나 조사 등도 감성분석 대상에 포함하기: 모든 조사, 어미를 포함할 수는 없겠지만, 그 의미를 반영하여
# 감성분석을 실시하면 더더욱 세밀한 결과를 얻을 수 있을 것임. 
