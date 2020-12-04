library(R.matlab)
library(svMisc)
library(data.table)

fileList <- list.files(path="/Users/chriskye 1/Desktop/DEAP/data_preprocessed_matlab", 
            pattern = "*.mat", full.names=TRUE)

## 1 second epochs per video per channel for each participant
processedRaw <- lapply(fileList, function(x) {
    numFile <- readMat(x)                    ##40 x 40 x 8064 (video x channel x data)
    numFile <- numFile$data[,1:32,-c(1:384)]  ##40 x 32 x 7680 (video x channel x data)

    output <- array(dim = c(32, 128, 2400)) ##32, 128, 2400 (channel x time x epoch)
    for (i in 1:32) {
        progress(i, progress.bar = TRUE)
        for(j in 1:40) {
            for(k in 1:60) {
                output[i, 1:128, (j-1)*60 + k] <- numFile[j,i,(k-1)*128 + c(1:128)]
            }
        }
    }
    return(output)
})

