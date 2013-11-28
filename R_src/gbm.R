
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