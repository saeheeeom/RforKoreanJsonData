library(tidyverse)

starwars


starwars %>%
  group_by(eye_color) %>%
  summarize(count = n(), mean(height, na.rm = TRUE), mean(birth_year, na.rm = TRUE), mean(mass, na.rm = TRUE))
