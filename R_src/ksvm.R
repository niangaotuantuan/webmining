library(kernlab)

# train the SVM
train.dtm <- as.matrix(corpus.dtm)
svm.s <- ksvm(y=label_s[1:500,],x=train.dtm,type="eps-svr",kernel=stringdot)#epslon regression
svm.w <- ksvm(label_w~.,x=train.dtm,type="probabilities",kernel=stringdot)
# General summary
svm1
# Attributes that you can access
attributes(svm1)
# For example, the support vectors
alpha(svm1)
alphaindex(svm1)
b(svm1)
# Use the built-in function to pretty-plot the classifier
plot(svp,data=train)
 
## get fitted values
fitted(svm1)
 
## Test on the training set with probabilities as svm1put
probpreds <- predict(svm1, label, type="probabilities")
## Test on the training set with response as svm1put
responsepreds <- predict(svm1, label, type = "r")

## Compare
results <- data.frame(x = label, 
                      response = responsepreds, 
                      P.x.0 = probpreds[,1], 
                      P.x.1 = probpreds[,2])
 
## Further Comparison
predict(svm1, newdata = label, type = "response")
predict(svm1, newdata = label, type = "decision")
predict(svm1, newdata = label, type = "votes")
predict(svm1, newdata = label, type = "prob")