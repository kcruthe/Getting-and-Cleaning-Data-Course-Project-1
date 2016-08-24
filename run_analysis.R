## You should create one R script called run_analysis.R that does the following.

## Merges the training and the test sets to create one data set.
## First, Read the training and the test data set
setwd("D:\\Data specialist\\Getting and Clearing Data\\Week4")
library(data.table)
library(plyr)
library(dplyr)
library(reshape2)

## Extracts only the measurements on the mean and standard deviation for each measurement.

Act <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
Act_label <- as.character(Act$V2)

Fetures <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/features.txt")
FeturesWanted <- grep(".*mean.*|.*std.*", Fetures[,2])
FeturesWanted.names <- Fetures[FeturesWanted ,2]
FeturesWanted.names = gsub('-mean', 'Mean', FeturesWanted.names)
FeturesWanted.names = gsub('-std', 'Std', FeturesWanted.names)
FeturesWanted.names <- gsub('[-()]', '', FeturesWanted.names)


## Uses descriptive activity names to name the activities in the data set

Tex <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")[FeturesWanted]
Trx <- read.table("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")[FeturesWanted]
  a <- intersect(names(Tex), names(Trx))
  mrg <- merge(Tex, Trx, by = a, all = TRUE)
  colnames(mrg) <- FeturesWanted.names 
  mrg$id <- c(1:nrow(mrg))
  
## Uses descriptive activity names to name the activities in the data set


## Appropriately labels the data set with descriptive variable names.(y)
Tey <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
    colnames(Tey) <- c("activity")
    Tey$activity <- as.factor(Tey$activity)
    levels(Tey$activity) <- Act_label


Try <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
    colnames(Try) <- c("activity")
    Try$activity <- as.factor(Try$activity)
    levels(Try$activity) <- Act_label
    is.factor(Try$activity)

Dt <- do.call("rbind",list(Tey,Try))
Dt$id <- c(1:nrow(Dt))

## Appropriately labels the data set with descriptive variable names.(z)
Tez <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
colnames(Tez) <- c("subject")
Trz <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
colnames(Trz) <- c("subject")

Dt2 <- do.call("rbind",list(Tez,Trz))
Dt2$subject <- as.factor(Dt2$subject)
Dt2$id <- c(1:nrow(Dt2))

## Merge the data 
## From the data set in step 4, creates a second, 
## independent tidy data set with the average of each variable for each activity and each subject.
Mdata <- merge(Dt,Dt2, by = "id", all=TRUE)
MrData <- merge(mrg, Mdata, by = "id", all = TRUE)
MrData <- MrData[,c(2:length(MrData))]

MrData.melted <- melt(MrData , id = c("subject", "activity"))
MrData.mean <- dcast(MrData.melted, subject + activity ~ variable, mean)

write.table(MrData.mean, "tidy.txt", row.names = FALSE)
