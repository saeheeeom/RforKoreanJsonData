# 1302
# 2019-14505 엄세희

library(tidyverse)
library(jsonlite)

files = list.files(pattern = "^S.+json$", full.names = T)
length(files)

get_speaker <- function(x) {
  json = fromJSON(x) %>% .$document %>% .$metadata %>% .$speaker
}
df_speaker = map(files, get_speaker) %>% bind_rows()

speaker_speed = list()
for (i in 1:length(files)) {
  jsonData <- fromJSON(files[i])$document$utterance[[1]]
  jsonData <- jsonData %>% 
    mutate(utter_speed = end-start/length(original_form), id = speaker_id) %>% 
    select(id, utter_speed) %>% 
    group_by(id) %>%
    summarise(utterSpeed = mean(utter_speed)) 
  speaker_speed[[i]] = jsonData
}
df_speed = bind_rows(speaker_speed)

df_speaker <- df_speaker %>% left_join(df_speed, by = "id")

df_speed_mean = df_speaker %>% select(age, utterSpeed) %>% group_by(age) %>% summarise(n= n(), Mean = mean(utterSpeed))
df_speed_variance = df_speaker %>%  select(id, age, utterSpeed) %>% group_by(age) %>% 
  mutate(mean_age = mean(utterSpeed),
         sd_age = utterSpeed - mean(utterSpeed)) %>% 
  ungroup() %>% 
  mutate(mean = mean(utterSpeed), sd = utterSpeed - mean(utterSpeed)) %>% 
  mutate(variance_within_age = sd_age^2) %>% 
  mutate(variance_among_age = (mean-mean_age)^2)

df_speed_variance %>% rmarkdown::paged_table()

result = aov(utterSpeed ~ age, data = df_speaker)
broom::tidy(result)

df_speed_variance %>% 
  ggplot(aes(x = age, y = variance_within_age)) + geom_point()

df_speed_variance %>% 
  ggplot(aes(x = age, y = variance_among_age)) + geom_point()





