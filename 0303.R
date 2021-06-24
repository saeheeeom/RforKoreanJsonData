library(tidyverse)

starwars

# filter(films, match("영화제목")) 코드가 실행되지 않아 일일이 새로운 데이터로 지정하였습니다
tesb <- starwars %>% filter(grepl("The Empire Strikes Back",films))
rots <- starwars %>% filter(grepl("Revenge of the Sith",films))
rotj <- starwars %>% filter(grepl("Return of the Jedi",films))
tfa <- starwars %>% filter(grepl("The Force Awakens",films))
aotc <- starwars %>% filter(grepl("Attack of the Clones",films))
tpm <- starwars %>% filter(grepl("The Phantom Menace",films))
anh <- starwars %>% filter(grepl("A New Hope",films))

# 데이터를 summarize하여 각 film의 feature를 뽑아냈습니다. 
# 이 때 feature에 해당될 수 있는 것은 정수 / 실수 형태의 data만을 포함하였습니다 (height, mass, birth_year)
s1 = summarize(tesb, h = mean(height, na.rm = TRUE), m = mean(mass, na.rm = TRUE), b = mean(birth_year, na.rm = TRUE))
s2 = summarize(rots, h = mean(height, na.rm = TRUE), m = mean(mass, na.rm = TRUE), b = mean(birth_year, na.rm = TRUE))
s3 = summarize(rotj, h = mean(height, na.rm = TRUE), m = mean(mass, na.rm = TRUE), b = mean(birth_year, na.rm = TRUE))
s4 = summarize(tfa, h = mean(height, na.rm = TRUE), m = mean(mass, na.rm = TRUE), b = mean(birth_year, na.rm = TRUE))
s5 = summarize(aotc, h = mean(height, na.rm = TRUE), m = mean(mass, na.rm = TRUE), b = mean(birth_year, na.rm = TRUE))
s6 = summarize(tpm, h = mean(height, na.rm = TRUE), m = mean(mass, na.rm = TRUE), b = mean(birth_year, na.rm = TRUE))
s7 = summarize(anh, h = mean(height, na.rm = TRUE), m = mean(mass, na.rm = TRUE), b = mean(birth_year, na.rm = TRUE))

# 모든 film의 데이터를 합쳐서 그래프로 나타냈습니다
# height, mass의 경우 평균이 유사한 film들이 존재했지만,
# 범례를 보면 알 수 있듯 birth_year의 경우 60~140으로,상대적으로 차이가 뚜렷하게 나타나는 편입니다.
newdata <- rbind(s1,s2,s3,s4,s5,s6,s7)

ggplot(newdata) +
  geom_point(mapping = aes(x = h, y = m, size = b))
