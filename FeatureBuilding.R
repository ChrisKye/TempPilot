library(data.table)
library(dplyr)
library(R.matlab)

############# Creating y_labels for modelling #############

##Reading in data
ratings <- fread("./Data/metadata_csv/participant_ratings.csv")
data_y <- ratings[,c("Participant_id","Trial", "Valence", 
                     "Arousal", "Dominance", "Liking")]

##Relabelling to High/Low for emotion dimensions
labels <- apply(data_y, 1, function(x) {
  if (x[3] > 5) val = "High"
  else val = "Low"
  if (x[4] > 5) arou = "High"
  else arou = "Low"
  if (x[5] > 5) dom = "High"
  else dom = "Low"
  if (x[6] > 5) lik = "High"
  else lik = "Low"
  return (c("Sub" = x[1], "Trial" = x[2], "Valence" = val,"Arousal" = arou,
                   "Dominance" = dom, "Liking" = lik))
})

##Reshape and repeat labels to match training set
labels <- t(labels)
labels <- as.data.table(labels)
colnames(labels)[1:2] <- c("SubNo","TrialNo")

finalLabs <- labels[rep(seq_len(nrow(ratings)), each=60),]

saveRDS(object = finalLabs,file = "./Data/finalLabs.rds")

############# Music Features Reshaping #############
##Initial Formatting
df <- readMat('music_anal/musicFeatures.mat')
df <- df[[1]]
df <- as.data.frame(df)
df <- as.data.frame(t(df))
row.names(df) <- c(1:40)
df <- as.data.table(df)
df <- df[,-c("pitch")]

##Repeat to concatenate
x_music <- df[rep(seq_len(nrow(df)), each=60),]
x_music <- x_music[rep(seq_len(nrow(x_music)), 32), ]

featureFull <- cbind(x_freq, x_music)





