panel.datasm = data.frame(
    cbind( 
        sample(1991:1993, 100, replace=TRUE), 
        rep(1:20,each=5), runif(100, min=0, max=1), 
        runif(100, min=0, max=6), 
        runif(100, min=2, max=6) , 
        runif(100, min=0, max=1), 
        runif(100, min=0, max=6), 
        runif(100, min=2, max=6)  ))
names(panel.datasm) = c("choice", "id", "data_1991","data_1992",
    "data_1993", "data2_1991", "data2_1992","data2_1993") 


logit.data <- mlogit.data(panel.datasm, id = "id", choice = "choice", 
    varying= 3:5, shape = "wide", sep = "_") 

head(logit.data)