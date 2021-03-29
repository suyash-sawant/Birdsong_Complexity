######### NVI calculation from Batch Correlator Output #########

              ###   ##  ##      ##  ####
              ####  ##   ##    ##    ##
              ## ## ##    ##  ##     ##
              ##  ####     ####      ##
              ##   ###      ##      ####


#This program calculates the song complexity values using Note Variability INdex(NVI)
#The input files include: 1. Spectrogram Cross-Correlation values
#                         2. Lengtth of songs, starting and ending notes


#set working directory
setwd('PATH')

#import the Raven Batch Correlator Output(delete first two rows, keep only correlation table)
BatchCorrOut<-read.csv("notes_BatchCorrOutput.csv", header =T, row.names = 1)

#import the Song length data
#3 columns needed - No. of notes in each song- "Note Count" 
#                   Starting note for each song- "Start Note"
#                   Ending note for each song- "End Note"
SongLength<-read.csv("SongLength.csv", header =T, row.names = 1)

#define the columns with the numbers of notes, starting and ending notes for each song
StartNote <- SongLength$Start.Note
EndNote <- SongLength$End.Note
NoteCount <- SongLength$Note.Count

#write output dataframe for NVI values
result <- data.frame(matrix(nrow = nrow(SongLength), ncol = 3))
colnames(result) <- c("No. of notes","NVI", "NVI_normalized")

#Calculate the NVI values based on the song bounds provided
for (x in 1:nrow(SongLength)){
  i = StartNote[c(x)]
  j = EndNote[c(x)]
  k = NoteCount[c(x)]
  NVI <-sum((1-BatchCorrOut[c(i:j),c(i:j)]))
  NVI_norm <-sum((1-BatchCorrOut[c(i:j),c(i:j)]))/(k*(k-1))
  result[x, 1] <- k
  result[x, 2] <- NVI
  result[x, 3] <- NVI_norm
}

#Export NVI output as a .csv file
write.csv(result, "PATH/NVI_Output.csv")
