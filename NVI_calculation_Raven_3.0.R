#This program calculates the song complexity using Note Variability Index (NVI) (Sawant S., Arvind C., Joshi V., Robin V. V., 2021)
#This program uses warbleR to calculate Spectrogram Cross-Correlation
#Input files: 1)Raven selection table for notes
#             2)Raven Batch Correlator Output
#The notes selection table should include- Begin Time (s), End Time (s), Low Frequency (Hz), High Frequency (Hz), Song No..

#-------------------------------------------------------------------------------------------------------------------------------

#This part creates Raven Songs selection table from the Notes Selections

library("readr")

#set working directory
#setwd('PATH')

#Import raven selection table for notes in the txt form
#with an annotation column- 'Song No.'
#for alloting each note under some song
Notes_Selections <-as.data.frame(read_tsv("Notes_selections.txt", col_names = T))

#Extract Unique song IDs
Unique_Songs <- as.data.frame(unique(Notes_Selections$`Song No.`))

#No. of Songs
Total_songs <- length(unique(Notes_Selections$`Song No.`))

#Create data frame for songs selection table
Song_Selections <- data.frame(matrix(nrow = Total_songs, ncol = ncol(Notes_Selections)))
colnames(Song_Selections) <- names(Notes_Selections)
colnames(Song_Selections)[ncol(Song_Selections)] <- "Note Count"

#Create selection table for songs
Song_Selections[,1] <- c(1:Total_songs)
Song_Selections[,2] <- "Spectrogram 1"
Song_Selections[,3] <- 1
Begin_Time <- aggregate(Notes_Selections$`Begin Time (s)` , by = list(Category = Notes_Selections$`Song No.`), FUN = min)
Song_Selections[,4] <- Begin_Time$x
End_Time <- aggregate(Notes_Selections$`End Time (s)` , by = list(Category = Notes_Selections$`Song No.`), FUN = max)
Song_Selections[,5] <- End_Time$x
Min_Freq <- aggregate(Notes_Selections$`Low Freq (Hz)` , by = list(Category = Notes_Selections$`Song No.`), FUN = min)
Song_Selections[,6] <- Min_Freq$x
Max_Freq <- aggregate(Notes_Selections$`High Freq (Hz)` , by = list(Category = Notes_Selections$`Song No.`), FUN = max)
Song_Selections[,7] <- Max_Freq$x
Note_Count <- aggregate(Notes_Selections$Channel , by = list(Category = Notes_Selections$`Song No.`), FUN = sum )
Song_Selections[,ncol(Song_Selections)] <- Note_Count$x

#-------------------------------------------------------------------------------------------------------------------------------

#This part calculates the song complexity values using Note Variability INdex(NVI)

######### NVI calculation from Batch Correlator Output #########

              ###   ##  ##      ##  ####
              ####  ##   ##    ##    ##
              ## ## ##    ##  ##     ##
              ##  ####     ####      ##
              ##   ###      ##      ####


#extract song lengths from the songs selction table
SongLength <- as.data.frame(Song_Selections$`Note Count`)


#Create datasheet for the start and end of each song
start_end <- data.frame(matrix(nrow = nrow(SongLength), ncol = 2))
start_end <- cbind(SongLength,start_end)
colnames(start_end) <- c("Note_Count","Start_note", "end_note")

for (i in 2:nrow(start_end)){
  start_end[1,2] <- 1
  start_end[1,3] <- start_end[1,1]
  start_end[i,2] <- 1 + start_end[i-1,3]
  start_end[i,3] <- start_end[i,1] + start_end[i-1,3]
  
}

#Extract total number of notes to be correlated from the individual note count of songs
Total_notes <- start_end[nrow(start_end),3]

#Import Raven Batch Correlator output in the txt form
BatchCorrOutput <- read_tsv("Notes_BatchCorrOutput.txt", col_names = T, skip = 2)

#Extract only correlation values (removing lags sheet)
Corr_Table <- as.data.frame(BatchCorrOutput[c(1:Total_notes),c(1:Total_notes)+1])
Corr_Table <- as.data.frame(sapply(Corr_Table, as.numeric))

#Extract note count, start note and end note fpr each song
StartNote <- start_end$Start_note
EndNote <- start_end$end_note
NoteCount <- start_end$Note_Count

#creat output dataframe for NVI values
NVI_output <- data.frame(matrix(nrow = nrow(SongLength), ncol = 3))
colnames(NVI_output) <- c("No. of notes","NVI_non_norm", "NVI")

#Calculate the NVI values based on the song bounds provided
for (x in 1:nrow(SongLength)){
  i = StartNote[c(x)]
  j = EndNote[c(x)]
  k = NoteCount[c(x)]
  NVI_non_norm <-sum((1-Corr_Table[c(i:j),c(i:j)]))
  NVI <-sum((1-Corr_Table[c(i:j),c(i:j)]))/(k*(k-1))
  NVI_output[x, 1] <- k
  NVI_output[x, 2] <- NVI_non_norm
  NVI_output[x, 3] <- NVI
}

#add NVI values to raven selection table
NVI <- NVI_output$NVI
Song_Selections_Output <- cbind(Song_Selections, NVI)

#remove objects
rm("SongLength","BatchCorrOutput","StartNote","EndNote","NoteCount","start_end",
   "Song_Selections", "i","j","k","x", "NVI", "NVI_non_norm",
   "Begin_Time","End_Time","Max_Freq","Min_Freq","Note_Count","Unique_Songs")

#Write Raven selection table for songs with added NVI values in txt format
write.table(Song_Selections_Output, file = "Song_Selections_Output.txt", sep = "\t", quote = F,row.names = FALSE)

#Export NVI output as a csv file
#write.csv(NVI_output, "NVI_Output.csv")

#_______________________________________________________________________________________________________________________________