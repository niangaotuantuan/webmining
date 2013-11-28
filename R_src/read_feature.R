library(tm)
library(kernlab)
library(Rstem)
library(Snowball) 

#ALSO NOTE********
#Snowball package may have problems installing due to Java Virtual Machine issues. During installation, R froze,
#I shut R down and was then able to install. May also need to install Rstem, which is located on http://www.omegahat.org/
#go to packages > select repositories>omegahat, and then you should be able to install from there
#In recent versions R, can use following options to install Rstem:
#options(CRAN = c(getOption("CRAN"), "http://www.omegahat.org/R"))
#install.packages("Rstem")

dir <- "E:\\"
setwd(dir)



#--------------tm package-------------------#

fea_mat <- read.table("dump_tense.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
head(fea_mat)
fea_mat <- fea_mat[,-1]

tfidf_mat <- fea_mat[,1:100]
added_mat <- fea_mat[,101:113]
tense_mat <- fea_mat[,114:115]


#train <- Corpus(x=train_tweet, readerControl=list(language="eng"))
#corpus <- Corpus(VectorSource(train_tweet))
train_tweet <- as.matrix(train_tweet)
corpus <- Corpus(VectorSource(train_tweet[1:500]))

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