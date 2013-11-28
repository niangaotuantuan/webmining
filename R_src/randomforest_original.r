library(party)
## Train cForest and Predict
set.seed(42) #From random.org
#predictions <- NULL
NT <- 1000

X <- traintfidf_mat
Y <- label_sw
DATA <- cbind(X,Y)
formula.cf <- as.formula(s1+s2+s3+s4+s5+w1+w2+w3+w4~.)
train <- runif(nrow(X)) <= .22

model.cforest <- cforest(formula.cf, data=DATA[train,], 
                           control=cforest_unbiased(ntree=NT, trace=F, mtry=2))
		

X <- tfidf_mat
Y <- label_s
DATA2 <- cbind(X,Y)
formula2.cf <- as.formula(s1+s2+s3+s4+s5~.)
train <- runif(nrow(X)) <= .22

model2.cforest <- cforest(formula2.cf, data=DATA2[train,], 
                           control=cforest_unbiased(ntree=NT, trace=F, mtry=2))		
						   
clean.test <- testtfidf_mat			  
predictions$cforest2 <-predict(model.cforest,clean.test,OOB=T)





predictions$cforest[,1][predictions$cforest[,1]<=0.5] <- 0
predictions$cforest[,1][predictions$cforest[,1]>=0.5] <- 1
ans1 <- predictions$cforest[,1]

##write(cf.predictions[,1], file = "submission03.csv", ncolumns = 1)
##predictions$cforest <- as.numeric(predict(model.cforest, newdata=clean.test))-1
##sapply(clean.test, function(x) sum(is.na(x)))

ans1 <- as.numeric(predict(model.cforest, newdata=clean.test, OOB = T))-1
##write.csv(ans, file="submission-cf.csv", row.names=F)
