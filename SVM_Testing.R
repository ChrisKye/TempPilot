##SVM Testing
library(e1071)
##dominance
dataSVM <- cbind(training, trainingTarget)
testSVM <- cbind(test, testTarget)
mymodel <- svm(trainingTarget~., data = dataSVM, type = 'C-classification')
summary(mymodel)

pred <- predict(mymodel, testSVM)
tab <- table(Predicted = pred, Actual = testTarget)
sum(diag(tab))/sum(tab)

## liking
likingTarget_train <- liking[ind==1]
likingTarget_test <- liking[ind==2]
dataSVM2 <- cbind(training, likingTarget_train)
testSVM2 <- cbind(test, likingTarget_test)

mymodel2 <- svm(likingTarget_train~., data=  dataSVM2, type = 'C-classification')
summary(mymodel2)
pred <- predict(mymodel2, testSVM2)
tab <- table(Predicted = pred, Actual = likingTarget_test)
sum(diag(tab))/sum(tab)