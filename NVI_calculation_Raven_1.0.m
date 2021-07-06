%%%%%%% NVI calculation from Batch Correlator Output %%%%%%%
%                   NNN  NN  VV     VV  IIII
%                   NNNN NN   VV   VV    II
%                   NN NNNN    VV VV     II
%                   NN   NN     VVV     IIII

%This program calculates the song complexity values using Note Variability Index(NVI)
%The input files include: 1. Spectrogram Cross-Correlation values
%                         2. Length of songs, starting and ending notes

%set working directory
%cd 'PATH'

%import the Raven Batch Correlator Output(delete first two rows, keep only correlation table)
BatchCorrOut = readtable('Notes_BatchCorrOutput.csv');
BatchCorrOut(:,1) = []; 

%import the Song length data
%3 columns needed - No. of notes in each song- "Note Count" 
%                   Starting note for each song- "Start Note"
%                   Ending note for each song- "End Note"
SongLength = readtable('SongLength.csv');

%define the columns with the numbers of notes, starting and ending notes for each song
NoteCount = SongLength.('NoteCount');
StartNote = SongLength.('StartNote');
EndNote = SongLength.('EndNote');

%write output dataframe for NVI values
Result = array2table(zeros(height(SongLength),3));
Result.Properties.VariableNames = {'Note_Count','NVI', 'NVI_normalized'};

%Calculate the NVI values based on the song bounds provided
for x = 1:height(SongLength)
       i = StartNote(x,:);
       j = EndNote(x,:);
       k = NoteCount(x,:);
       NVI = sum(sum(1-BatchCorrOut{i:j,i:j},2));
       NVINorm = sum(sum(1-BatchCorrOut{i:j,i:j}))/(k*(k-1));
       Result{x, 1} = k;
       Result{x, 2} = NVI;
       Result{x, 3} = NVINorm;
end

%Export NVI output as a .csv file
writetable(Result,'NVI_Output.csv')
