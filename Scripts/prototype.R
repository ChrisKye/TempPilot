##Feature Extraction PRototype
sumPSD <- array(dim = c(15, 5, 10)) ##32 subjects
for (i in 1:15) { ##subjects
    sub <- as.array(processedRaw[[i]])
    rawPSD <- array(dim = c(32, 5, 10)) ##32 channels per subject
    for (j in 1:32) { ##channels
        rawPSD[j,,] <- pbapply(sub[j,,1:10], 2, function(x) {
            psd <- sig$welch(x, fs = 128, nperseg = 128, noverlap = 32)
            psd <- as.data.frame(psd)
            d <- int$simps(psd[psd[,1] %in% delta,2], dx = 0.25)
            t <- int$simps(psd[psd[,1] %in% theta,2], dx = 0.25)
            a <- int$simps(psd[psd[,1] %in% alpha,2], dx = 0.25)
            b <- int$simps(psd[psd[,1] %in% beta,2], dx = 0.25)
            g <- int$simps(psd[psd[,1] %in% gamma,2], dx = 0.25)
            return(c(d,t,a,b,g))
            print(j)
        })
    }
    sumPSD[i,,] <- apply(rawPSD, c(2,3), mean)
    print(paste0("Subject iteration: ", i))
}

