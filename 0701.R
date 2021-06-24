# 2019 - 14505 엄세희

library(tidyverse)

test_str = "====$^$===="

str_view(test_str, "\\$\\^\\$", match = TRUE)

str_view(stringr::words, "^y", match = TRUE)
str_view(stringr::words, "^x", match = TRUE)
str_view(stringr::words, "^...$", match = TRUE)
str_view(stringr::words, ".{7,}", match = TRUE)

hi = "===== \" 안녕 \" ====="
str_view(hi, "안녕", match = TRUE)
