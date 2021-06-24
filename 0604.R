# 0604 수업

# anova test: 두 개 이상의 그룹을 비교할 때 많이 사용
# 연속적인 값 비교할 때 (이산적X)
# aov()안에 넣어서 결과 도출
library(tidyverse)
library(jsonlite)
gss_cat

aov(tvhours ~ race, data=gss_cat )#보고자 하는 결과변수(종속변수), 결과변수에 영향을 주는 설명변수(독립변수)
aov(tvhours ~ race, data=gss_cat) %>% summary() # f값이 크면 클수록 설명변수의 영향이 뚜렷하게 나타남
aov(tvhours ~ marital, data=gss_cat) %>% summary()

# 감성분석
# 텍스트에 어떤 감정이 담겨 있는지 뷴석하는 방법
# 가장 기초적인 방법은 감성 사전(긍정/부정 어휘)에 기반하여 분석하는 방법

sentiment = fromJSON("https://raw.githubusercontent.com/park1200656/KnuSentiLex/master/data/SentiWord_info.json")
sentiment %>% str()
# 분석 원하는 데이터에 단어를 key로 삼아 join, 
# 그 데이터에서 polarity 다 더해서 계산하든가, 발화자별로 합하든가, 등등
files = list.files(pattern = "^S.+json$", full.names = T)


get_utterance <- function(x) {
  json_utterance = fromJSON(x) %>% .$document %>% .$utterance
  bind_rows(json_utterance)
}
df_spoken = map(files, get_utterance) %>% bind_rows()
df_spoken = df_spoken %>% select(speaker_id, sentence = form)



# sentnce단위 만드는 법 (구버전)
df_collapse = df_spoken %>% group_by(speaker_id) %>% mutate(whole_sentence = sentence %>% unlist() %>% str_c(collapse = " ")) %>% 
  select(speaker_id, whole_sentence) %>% unique()
df_sentence = df_collapse %>% 
  mutate(sentence = str_split(whole_sentence, "(\\.|\\?|//!)")) %>% 
  unnest(sentence) %>% select(-whole_sentence)
# 새로운 버전



# svd
# 7개의 필름, 6명의 캐릭터에 대한 매트릭스 (6*7)
# idm val: 정사방 행렬이여야 하기 때문에 더 작은 숫자인 6개의 숫자
# 6개의 숫자는 각각 feature의 분산을 나타냄
# 해당 예시에서는 첫 두 숫자의 분산이 가장 크므로, 밑에 있는 매트릭스에서의
# 첫번째 두번째 feature를 보는 것이 정확함.
# u matrix: 6*6 캐릭터에 대한 벡터값. 한 관측값은 한 명의 캐릭터에 배정

name_film = starwars %>% select(name, films) %>% unnest(films)

name_film





names_film2 = name_film %>% count(name, films) %>% 
  
  pivot_wider(names_from = films, values_from = n, values_fill = 0 )



names_film2 %>% t()



df = names_film2 %>% filter(name %in% c("Luke Skywalker", "Chewbacca", "Palpatine", "Yoda", "Darth Vader", "Anakin Skywalker")) 

df



df$name

df

df %>% colnames()

mat = df %>% select(-name) %>% as.matrix() 

mat %>% svd()

