library(tm)
library(kernlab)
library(Rstem)

dir <- "C:\\Users\\v-yanrl\\Documents\\GitHub\\webmining\\data"
setwd(dir)


#--------------tm package-------------------#

trainfea_mat <- read.table("train_features.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(trainfea_mat)
trainfea_mat <- trainfea_mat[,-1]

traintfidf_mat <- trainfea_mat[,1:100]
trainadded_mat <- trainfea_mat[,101:110]
#tense_mat <- fea_mat[,114:115]


testfea_mat <- read.table("test_features.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(testfea_mat)
testfea_mat <- testfea_mat[,-1]

testtfidf_mat <- testfea_mat[,1:100]
testadded_mat <- testfea_mat[,101:110]


#train <- Corpus(x=train_tweet, readerControl=list(language="eng"))
#corpus <- Corpus(VectorSource(train_tweet))
#train_tweet <- as.matrix(train_tweet)
#corpus <- Corpus(VectorSource(train_tweet[1:500]))

label_s <- train_label[,1:5] #sentiment
label_w <- train_label[,6:9] #when
label_sw <- train_label[,1:9]
label_k <- train_label[,10:24] #weather

label_s[,3] <- as.numeric(label_s[,3])


## Here needs to convert binary-classification to multi-classification
#senti <- label_senti
#when <- label_when
#weather <- label_weather

#Set Directory where Text is located
dir <- "E:\\Github\\webmining\\data"
setwd(dir)