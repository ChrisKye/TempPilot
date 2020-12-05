library(R.matlab)
library(data.table)
library(svMisc)
library(pbapply)

fileList <- list.files(path="/Users/chriskye 1/Desktop/DEAP/data_preprocessed_matlab", 
            pattern = "*.mat", full.names=TRUE)

## 1 second epochs per video per channel for each participant
processedRaw <- pblapply(fileList, function(x) {
    numFile <- readMat(x)                    ##40 x 40 x 8064 (video x channel x data)
    numFile <- numFile$data[,1:32,-c(1:384)]  ##40 x 32 x 7680 (video x channel x data)

    output <- array(dim = c(32, 128, 2400)) ##32, 128, 2400 (channel x time x epoch)
    for (i in 1:32) {
        print(paste0(i))
        for(j in 1:40) {
            for(k in 1:60) {
                output[i, 1:128, (j-1)*60 + k] <- numFile[j,i,(k-1)*128 + c(1:128)]
            }
        }
    }
    return(output)
})

names(processedRaw) <- paste0("subject", "_", sprintf("%03d", 1:32))
saveRDS(processedRaw, "epochedList.rds")

## FFT extract features from each participant
library(reticulate)
library(pbapply)
py_config()
sig <- import("scipy.signal")
int <- import("scipy.integrate")

delta <- c(1:4)
theta <- c(4:8)
alpha <- c(8:13)
beta <- c(13:30)
gamma <- c(30:47)

sumPSD <- array(dim = c(32, 5, 2400)) ##32 subjects
for (i in 1:32) { ##subjects
    sub <- as.array(processedRaw[[i]])
    rawPSD <- array(dim = c(32, 5, 2400)) ##32 channels per subject
    for (j in 1:32) { ##channels
        rawPSD[j,,] <- pbapply(sub[j,,], 2, function(x) {
            psd <- sig$welch(x, fs = 128, nperseg = 128, noverlap = 32)
            psd <- as.data.frame(psd)
            d <- int$simps(psd[psd[,1] %in% delta,2], dx = 0.25)
            t <- int$simps(psd[psd[,1] %in% theta,2], dx = 0.25)
            a <- int$simps(psd[psd[,1] %in% alpha,2], dx = 0.25)
            b <- int$simps(psd[psd[,1] %in% beta,2], dx = 0.25)
            g <- int$simps(psd[psd[,1] %in% gamma,2], dx = 0.25)
            return(c(d,t,a,b,g))
        })
    }
    sumPSD[i,,] <- apply(rawPSD, c(2,3), mean)
    print(paste0("Subject iteration: ", i))
}

dimnames(sumPSD)[[1]] <- paste0("subject", "_", sprintf("%03d", 1:32))
dimnames(sumPSD)[[2]] <- c("delta","theta","alpha","beta","gamma")
saveRDS(sumPSD, "freqFeatures.rds")

##Reshape freqFeatures into long format
x_freq <- data.table()
for (i in 1:32) {
    x_freq <- cbind(x_freq,freq[i,,])
    print("done")
}
x_freq <- t(x_freq)
x_freq <- as.data.table(x_freq)
colnames(x_freq) <- c("delta","theta","alpha","beta","gamma")




