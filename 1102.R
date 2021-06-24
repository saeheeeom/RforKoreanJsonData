# 1102
# 2019-14505 엄세희

library(rvest)
library(tidyverse)
wiki_url = "https://ko.wiktionary.org/wiki/%EB%B6%80%EB%A1%9D:%EC%9E%90%EC%A3%BC_%EC%93%B0%EC%9D%B4%EB%8A%94_%ED%95%9C%EA%B5%AD%EC%96%B4_%EB%82%B1%EB%A7%90_5800"
html <- read_html(wiki_url)
xpath_contents = "//*[@id=\"mw-content-text\"]/div[1]/table[2]/tbody" 


words = html_node(html, xpath = xpath_contents) %>% html_text() %>% str_split("\n") %>% unlist()
words = str_extract(words, "[가-힣]+") %>% unique()
words = words[-1]

word_list = list()
idx = 1


for (idx in 1:100) {    
  word_item = words[idx]    
  definition_url = paste0("https://opendict.korean.go.kr/api/search?&key=EEE7F41FB5874CDBF79AB60B5E82F80C&target_type=search&part=word&q=", word_item , "&sort=dict&start=1&num=10")
  sense_no = read_html(definition_url) %>% html_nodes("item") %>% .[[1]] %>% html_nodes("sense_no") %>%  html_text()
  definition = read_html(definition_url) %>% html_nodes("item") %>% .[[1]] %>% html_nodes("definition") %>%  html_text()
  word_list[[idx]] = data.frame(word_item, sense_no, definition)
}

df_word_sense = bind_rows(word_list)
df_word_sense %>% arrange(word_item, sense_no) %>% head(5) %>% knitr::kable()
