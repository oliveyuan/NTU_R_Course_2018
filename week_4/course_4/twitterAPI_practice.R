rm(list=ls(all.names=TRUE)) #remove the list
library(twitteR)
library(data.table)
library(NLP)
library(tm)
library(jiebaRD)
library(jiebaR)
library(RColorBrewer)
library(wordcloud)

# 取得 Twitter API
consumer_key <- "5p7cql8CMXfnjbo0Pt33zZW9y"
consumer_secret <- "Fmk5SBURktJVHrxlRufGCqZIpq50n2q6uX4fKCUJt2blrjNXQq"
access_token <- "753045625-kq70qgRbFiZwl0fenN1Mxx3rKBFrPnGrl2PBcfDO"
access_secret <- "VNwko3sAPRdlyHaeBduT1oF0eh3lqX4CSxoiNuK85nN3q"
options(httr_oauth_cache=T) #This will enable the use of a local file to cache OAuth access credentials between R sessions.
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

# 從特定字搜尋tweets
tweets <- searchTwitter('trump', n = 500, lang = "en",resultType = "recent")

# 把tweets變成text
text <- sapply(tweets, function(x)x$getText())
text[1:5]


#製作文字雲
docs <- Corpus(VectorSource(text))
inspect(docs[1])
removeURL <- function(x)gsub("http[^[:space:]]*","",x)
docs <- tm_map(docs, content_transformer(removeURL))
docs <- tm_map(docs, content_transformer(tolower))

removeNumPunct<- function(x)gsub("[^[:alpha:][:space:]]*","",x)
docs <- tm_map(docs, content_transformer(removeNumPunct))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, removeWords, "trump")
docs <- tm_map(docs, removeWords, "trumps")
docs <- tm_map(docs, removeWords, "president")
docs <- tm_map(docs, removeWords, "donald")




dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = T)
d <- data.frame(word=names(v), freq=v)
head(d,10)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, scale=c(4,0.1),min.freq = 1,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

