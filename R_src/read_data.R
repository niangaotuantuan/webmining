library(tm)
library(kernlab)
library(Rstem)

#Set Directory where Text is located
dir <- "C:\\Users\\v-yanrl\\Documents\\GitHub\\webmining\\data"
setwd(dir)

#--------------tm package-------------------#

train_raw <- read.table("train.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(train_raw)

train_tweet <- train_raw[,2] #id, tweet, state, location
train_label <- train_raw[,5:28] #sentiment, when, weather
label_mat <- train_label

#train <- Corpus(x=train_tweet, readerControl=list(language="eng"))
#corpus <- Corpus(VectorSource(train_tweet))
train_tweet <- as.matrix(train_tweet)
corpus <- Corpus(VectorSource(train_tweet[1:500]))

label_s <- train_label[,1:5] #sentiment
label_w <- train_label[,6:9] #when
label_sw <- train_label[,1:9]
label_k <- train_label[,10:24] #weather

label_s[,3] <- as.numeric(label_s[,3])
label_sw[,3] <- as.numeric(label_sw[,3])

data <- train_raw[,-1]
data <- data[,-2]
data <- data[,-2]

## Here needs to convert binary-classification to multi-classification
#senti <- label_senti
#when <- label_when
#weather <- label_weather
