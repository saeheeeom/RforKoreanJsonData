library(tidyverse)
starwars


ggplot(data = starwars) + geom_point(mapping = aes(x = birth_year, y = height, size = mass)) + facet_wrap(~eye_color, scale = "free") 
ggplot(data = starwars) + geom_point(mapping = aes(x = birth_year, y = height, size = mass)) + facet_wrap(~homeworld) 

ggplot(data = starwars) + geom_point(mapping = aes(x = homeworld, y = mass, color = gender)) 
