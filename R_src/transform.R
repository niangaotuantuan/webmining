
#--------------Transformations---------------#
#fixing up the data nice and good like

#extract hashtag
library("stringr")
tag <- str_extract(corpus,"^#.+?#")  #以“#”开头，“."表示任意字符，"+"表示前面的字符至少出现一次，"?"表示不采用贪婪匹配—即之后遇到第一个#就结束
tag <- na.omit(tag)  #去除NA
tag <- unique(tag)  
#insertWords(tag)

#corpus <- tm_map(corpus,stripWhitespace) #strip white space
#corpus <- tm_map(corpus, tolower)
skipWords <- function(x) removeWords(x, stopwords("english"))
funcs <- list(tolower, removePunctuation, removeNumbers, stripWhitespace, skipWords)
corpus <- tm_map(corpus, FUN = tm_reduce, tmFuns = funcs)

corpus.dtm <- DocumentTermMatrix(corpus, control = list(wordLengths = c(3,10)))
inspect(corpus.dtm[1:5,1:5])

#Create Document Term Matrix
dtm <- DocumentTermMatrix(corpus,
control = list(
            stemming=TRUE,#for special task, when, it should not be TRUE
            stopwords=TRUE,
            minWordLength=3,
            removeNumbers=TRUE,
            removePunctuation=TRUE))
#clean dtm matrix
dtm_matrix_clean <- function(dtm_matrix) {
    out <- dtm_matrix[,grep('^[A-Za-z]+$',colnames(dtm_matrix))]
    return(out)
}
inspect(dtm)
dtm_matrix_clean(dtm)
inspect(dtm)

removeSparseTerms(dtm, 0.8)
freq50 <- findFreqTerms(dtm, 50) #View terms that appear atleast 50 times
findAssocs(dtm,"sunny",0.8) #what words show up in correlation with the term "sunny". It appears many negative terms



temp <- inspect(dtm)
FreqMat <- data.frame(apply(temp, 1, sum))
FreqMat <- data.frame(ST = row.names(FreqMat), Freq = FreqMat[, 1])
FreqMat <- FreqMat[order(FreqMat$Freq, decreasing = T), ]
row.names(FreqMat) <- NULL
View(FreqMat)



#as.numeric(as.matrix(dtm)))


			
#dtm <- DocumentTermMatrix(train)
#dtm2 <- DocumentTermMatrix(train,  #dtm2 with weightTfIdf
#                          control = list(weighting =
#                                         function(x)
#                                         weightTfIdf(x, normalize =
#                                                     FALSE),
#                                         stopwords = TRUE,
#										 removePunctuation = TRUE))
#dtm3 <- DocumentTermMatrix(train,  #dtm3 with weightTfIdf and normalized
#                          control = list(weighting =
#                                         function(x)
#                                         weightTfIdf(x, normalize =
#                                                     TRUE),
#                                         stopwords = TRUE,
#										 removePunctuation = TRUE))




findFreqTerms(dtm, 50) #View terms that appear atleast 50 times
findAssocs(dtm,"sunny",0.8) #what words show up in correlation with the term "sunny". It appears many negative terms

#dtm_mat <- DocumentTermMatrix(makeChunks(rs,500),list(weighting=weightBin)) 
