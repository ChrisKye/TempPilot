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
  if (x[3] > 5) val = 1
  else val = 0
  if (x[4] > 5) arou = 1
  else arou = 0
  if (x[5] > 5) dom = 1
  else dom = 0
  if (x[6] > 5) lik = 1
  else lik = 0
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
names <- colnames(df)
df1 <- as.matrix(df)
df1 <- matrix(unlist(df1), nrow = 40, ncol=13)
df1 <- as.data.frame(df1)
colnames(df1) <- names

##Repeat to concatenate
x_music <- df1[rep(seq_len(nrow(df1)), each=60),]
x_music <- x_music[rep(seq_len(nrow(x_music)), 32), ]
saveRDS(x_music, "./Data/x_music.rds")

##Full Feature Set
featureFull <- cbind(x_freq, x_music)
saveRDS(object = featureFull, file = "./Data/featureFull.rds")





