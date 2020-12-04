library(data.table)
library(dplyr)
ratings <- fread("./Data/metadata_csv/participant_ratings.csv")
data_y <- ratings[,c("Participant_id","Trial", "Valence", 
                     "Arousal", "Dominance", "Liking")]

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
labels <- t(labels)
labels <- as.data.table(labels)
colnames(labels)[1:2] <- c("SubNo","TrialNo")

finalLabs <- labels[rep(seq_len(nrow(ratings)), each=60),]

saveRDS(object = finalLabs,file = "./Data/finalLabs.rds")