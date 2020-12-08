library(reticulate)
py_config()
library(keras)
install_keras()

##Reading Data
fullData <- readRDS("./Data/featureFull.rds")
labels <- readRDS("./Data/finalLabs.rds")
dominance <- labels[,5]
liking <- labels[,6]
str(fullData)

##change to matrix
data <- as.matrix(fullData)
dimnames(data) <- NULL
summary(data)

##Normalize Data
data[,1:18] <- normalize(data[,1:18])
summary(data)

##Data Partition
set.seed(1234)
ind <- sample(2, nrow(data), replace = T, prob = c(0.7,0.3))
training <- data[ind==1, 1:18]
test <- data[ind==2, 1:18]
trainingTarget <- dominance[ind==1]
testTarget <- dominance[ind==2]

##One Hot Encoding
trainLabs <- to_categorical(trainingTarget)
testLabs <- to_categorical(testTarget)

##Creating sequential model
model <- keras_model_sequential()
model %>% 
        layer_dense(units = 10, activation = 'relu', input_shape = c(18),
                    kernel_regularizer = regularizer_l2(0.01)) %>%
        layer_dropout(rate=0.2) %>%
        layer_dense(units = 10, activation = 'relu',
                    kernel_regularizer = regularizer_l2(0.01)) %>%
        layer_dropout(rate=0.2) %>%
        layer_dense(units = 2, activation = 'softmax')
summary(model)

##Compile model
model %>% 
        compile(loss = 'binary_crossentropy',
                optimizer = 'adam',
                metrics = 'accuracy')

##Model Training
history <- model %>%
        fit(training[1:2400,],
            trainLabs,
            epoch = 50,
            batch_size = 32,
            validation_split = 0.2)

##Model Evaluation
model %>%
        evaluate(test, testLabs)









