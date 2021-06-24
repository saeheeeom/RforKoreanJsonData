# 1101
# 2019-14505 엄세희



library(tidyverse)
library(rvest)

wiki_url = "https://ko.wikipedia.org/wiki/%EC%8A%A4%ED%83%80%EC%9B%8C%EC%A6%88"
html = read_html(wiki_url)

content = c()
xpath_contents = c()
for (i in 1:8) {
  xpath_contents[[i]] = paste("//*[@id=\"mw-content-text\"]/div[1]/dl[",i,"]/dd[1]", sep = "")
  content[[i]] = rvest::html_nodes(html, xpath = xpath_contents[[i]]) %>% html_text()
}
content = content[-2]
content = unlist(content)

title = c(rvest::html_nodes(html, '.mw-headline') %>% html_text())
title = title[5:11]

df = data.frame(title, content)




