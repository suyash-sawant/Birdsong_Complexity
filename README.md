# Birdsong_Complexity

About
This repository contains R and MATLAB codes to compute birdsong complexity using Note Variability Index (NVI) as defined in Sawant, S., Arvind, C., Joshi, V., Robin, V. V. (2021)- Spectrogram cross-correlation can be used to measure the complexity of bird vocalizations. BioRxiv. https://doi.org/10.1101/2021.03.30.437665-

NVI_calculation_Raven_1.0.R
This R-program calculates the song complexity using Note Variability Index (NVI) (Sawant S., Arvind C., Joshi V., Robin V. V., 2021)
Input files: 1. Spectrogram Cross-Correlation values
             2. Length of songs, starting and ending notes

NVI_calculation_Raven_1.0.m
This MATLAB-program calculates the song complexity using Note Variability Index (NVI) (Sawant S., Arvind C., Joshi V., Robin V. V., 2021)
Input files: 1. Spectrogram Cross-Correlation values
             2. Length of songs, starting and ending notes

NVI_calculation_Raven_2.0.R
This R-program calculates the song complexity using Note Variability Index (NVI) (Sawant S., Arvind C., Joshi V., Robin V. V., 2021)
Input files: 1. Raven selection table for songs with a column mentioning Note count
             2. Racen batch correlator output

NVI_calculation_Raven_3.0.R
This R-program calculates the song complexity using Note Variability Index (NVI) (Sawant S., Arvind C., Joshi V., Robin V. V., 2021)
Input files: 1. Raven selection table for notes with a column mentioning Song number
             2. Raven Batch Correlator Output
The notes selection table should include- Begin Time (s), End Time (s), Low Frequency (Hz), High Frequency (Hz), Song No..

NVI_calculation_warbleR_1.0.R
This R-program calculates the song complexity using Note Variability Index (NVI) (Sawant S., Arvind C., Joshi V., Robin V. V., 2021)
This program uses warbleR to calculate Spectrogram Cross-Correlation
Input files: Raven selection table for notes with sound files in same directory
The notes selection table should include- Begin Time (s), End Time (s), Low Frequency (Hz), High Frequency (Hz), 
                                          Begin File, File Offset (s), Song No.
