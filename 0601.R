# 0601
library(tidyverse)
library(tidyr)
starwars

hw_to_spc <- starwars %>% 
  group_by(homeworld, species) %>% 
  summarize(count = n()) %>% 
  arrange(desc(count))

newdata1 <- pivot_wider(hw_to_spc, names_from = homeworld, values_from = count)
newdata1
newdata2 <- spread(hw_to_spc,homeworld, count )
newdata2