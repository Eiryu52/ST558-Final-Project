# Script for creating reduced heart data file with random selection of 20000 rows.


Heart_Data <- read.csv("heart_2022_no_nans.csv", sep = ',')

set.seed(420)

Random_Sample_Heart_Data <- Heart_Data[sample(nrow(Heart_Data), 20000, replace = FALSE), ]

write.csv(Random_Sample_Heart_Data, "Heart_Data_Reduced.csv", row.names = FALSE)