library(tidyverse)
starwars


ggplot(data = starwars) + geom_point(mapping = aes(x = homeworld, y = mass, color = gender)) + coord_flip()
