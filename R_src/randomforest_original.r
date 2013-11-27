library(party)

clean.train <- fea_mat


set.seed(42) #From random.org

X <- tfidf_mat
Y <- label_s
train <- runif(nrow(X)) <= .33


## Modeling Begin

predictions <- NULL
NT <- 1000

## Train SVM(only for gender model) and Predict
library(e1071)
tune_s <- tune.svm(y=Y[train,], x=X[train,], gamma=10^(-4:-1), cost=10^(1:4)) #scale could be treated carefully
# summary(tune)
tune$best.parameters

model.svm <- svm(formula3, 
               data=clean.train, 
               type="C-classification", 
               kernel="radial", 
               probability=T, 
               gamma=tune$best.parameters$gamma, 
               cost=tune$best.parameters$cost)
predictions$svm <- as.numeric(predict(model.svm, newdata=clean.test))-1
ans3 <- as.numeric(predict(model.svm, newdata=clean.test))-1
##write.csv(ans, file="submission-svm.csv", row.names=F)

## Train cForest and Predict
model.cforest <- cforest(formula2.cf, data=clean.train, 
                           control=cforest_unbiased(ntree=NT, trace=F))
predictions$cforest<-predict(model.cforest,clean.test,OOB=T)
predictions$cforest[,1][predictions$cforest[,1]<=0.5] <- 0
predictions$cforest[,1][predictions$cforest[,1]>=0.5] <- 1
ans1 <- predictions$cforest[,1]

##write(cf.predictions[,1], file = "submission03.csv", ncolumns = 1)
##predictions$cforest <- as.numeric(predict(model.cforest, newdata=clean.test))-1
##sapply(clean.test, function(x) sum(is.na(x)))

ans1 <- as.numeric(predict(model.cforest, newdata=clean.test, OOB = T))-1
##write.csv(ans, file="submission-cf.csv", row.names=F)

## Train gbm and Predict
library(gbm)
model.gbm <- gbm(formula2.cf, data=clean.train, n.trees=NT, interaction.depth=2)
predictions$gbm<-predict(model.gbm,clean.test, type = "response", n.trees = NT)
predictions$gbm <- round(predictions$gbm, 0)
ans2 <- predictions$gbm

##predictions$gbm <- predict(model.gbm, newdata=clean.test, type="response", n.trees=NT)
##ans2 <- as.numeric(predict(model.gbm, newdata=clean.test, n.trees = NT))-1
##write.csv(ans, file="submission-gbm.csv", row.names=F)

##model.svmfm <- attr(terms(model.svm),"terms.labels")
##model.cforestfm <- attr(terms(model.cforest), "terms.labels")
##model.fm <- as.formula(paste("y ~ ", paste(c(model.svmfm, model.cforestfm), collapse = "+")))
##model <- lm(model.fm, clean.train)

## Ensembling models
ans <- (ans1 + ans2 + ans3)
ans[ans <= 1] <- 0
ans[ans == 1] <- 0
ans[ans >= 2] <- 1
ans[ans == 2] <- 1
write.csv(ans, file="submission06.csv", row.names=F)