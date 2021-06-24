library(tidyverse)

starwars

swBMI <- starwars %>% mutate(BMI = mass/height) %>% filter(species == "Human") %>% arrange(BMI)
swBMI

ggplot(swBMI, aes(x = height, y = mass)) +
  geom_point() +
  geom_text(mapping = aes(label = name))
