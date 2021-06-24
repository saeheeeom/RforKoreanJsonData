# 2019-14505 엄세희
# 07-02

library(tidyverse)
library(stringr)
library(jsonlite)

fn = list.files(pattern = "^S.+json$")
js_speak = fromJSON(fn)
df_utterance = js_speak$document$utterance[[1]]


str_view(df_utterance$form, "(보고|보는데|봐|봤다|보니|보았다|보는|보다가|보면서|봐요|봤어요)", match = TRUE)

# str_view(df_utterance$form, "(보[^통(니까)]|[본봤볼][가-힣])", match = TRUE)
