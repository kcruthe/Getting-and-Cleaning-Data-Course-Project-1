## You should create one R script called run_analysis.R that does the following.

## Merges the training and the test sets to create one data set.
## First, Read the training and the test data set
setwd("D:\\Data specialist\\Getting and Clearing Data\\Week4")
library(data.table)
library(plyr)
library(dplyr)
library(reshape2)

Tex <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Trx <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
a <- intersect(names(Tex), names(Trx))
mrg <- merge(Tex, Trx, by = a, all = TRUE)
mrg$id <- c(1:nrow(mrg))

## Extracts only the measurements on the mean and standard deviation for each measurement.

Mn <- apply(mrg,2, mean)
Sd <- apply(mrg,2, sd)

## Uses descriptive activity names to name the activities in the data set
NewName <- c("WALKING", "WALKING_UPSTAIRS", 
             "WALKING_DOWNSTAIRS", "SITTING", 
             "STANDING", "LAYING"); seq(along = NewName)


## Appropriately labels the data set with descriptive variable names.(y)
Tey <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
    colnames(Tey) <- c("activity")
    Tey$activity <- as.factor(Tey$activity)
    levels(Tey$activity) <- NewName
    is.factor(Tey$activity)


Try <- fread("./getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
    colnames(Try) <- c("activity")
    Try$activity <- as.factor(Try$activity)
    levels(Try$activity) <- NewName
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
MrData <- subset(MrData, select = c(2:564))
names(MrData)
Actvty <- group_by(MrData,activity,subject)
head(Actvty)
x <- summarize(Actvty, mean = mean(c(V1:V561)))
y <- as.data.frame(x)
y
