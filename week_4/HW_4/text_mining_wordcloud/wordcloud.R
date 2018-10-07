rm(list=ls(all.names = TRUE))
library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)




filenames <- list.files(getwd(), pattern="*.txt")
files <- lapply(filenames, readLines, encoding="UTF-8",warn=FALSE)
docs <- Corpus(VectorSource(files))



toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, removeWords, stopwords("english"))

docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
docs <- tm_map(docs, removeWords, "said")
docs <- tm_map(docs, removeWords, "one")
docs <- tm_map(docs, removeWords, "the")
docs <- tm_map(docs, removeWords, "white")
docs <- tm_map(docs, removeWords, "house")
docs <- tm_map(docs, removeWords, "new")
docs <- tm_map(docs, removeWords, "I")
docs <- tm_map(docs, removeWords, "us")
docs <- tm_map(docs, removeWords, "will")
docs <- tm_map(docs, removeWords, "im")
docs <- tm_map(docs, removeWords, "Trump")
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)

mixseg = worker()
jieba_tokenizer=function(d){
  unlist(segment(d[[1]],mixseg))
}
seg = lapply(docs, jieba_tokenizer)
freqFrame = as.data.frame(table(unlist(seg)))

wordcloud(freqFrame$Var1,freqFrame$Freq,
          scale=c(5,0.1),min.freq=5,max.words=150,
          random.order=F, random.color=T, 
          rot.per=.1, colors=rainbow(length(row.names(freqFrame))),
          ordered.colors=FALSE,use.r.layout=FALSE,
          fixed.asp=TRUE)