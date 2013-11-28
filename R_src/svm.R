library(party)

set.seed(42) #From random.org

X <- tfidf_mat
Y <- label_w
train <- runif(nrow(X)) <= .22

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