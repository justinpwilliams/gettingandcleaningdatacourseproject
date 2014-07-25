## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.

## Read in train data. This assumes the zip file was extracted in the working
## directory.
## Read in train subject ids
trainsub <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="")
## Read in train set
trainx <- read.table("UCI HAR Dataset/train/X_train.txt", sep="")
## Read in train labels
trainy <- read.table("UCI HAR Dataset/train/Y_train.txt", sep="")

## Read in test data
## Read in test subject ids
testsub <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="")
## Read in test set
testx <- read.table("UCI HAR Dataset/test/X_test.txt", sep="")
## Read in test labels
testy <- read.table("UCI HAR Dataset/test/Y_test.txt", sep="")

## Column bind the two sets together, plus an extra variable 'set' to identify
## whether the data came from the train set or the test set.
trainset <- cbind("train",trainsub,trainy,trainx)
testset <- cbind("test", testsub,testy,testx)

## Load the descriptions of the measurements
features <- read.table("UCI HAR Dataset/features.txt")

## Add subjectID, activityID, and the features descriptions as the names to the 
## test and training data sets.
names(trainset) <- c("set","subjectID","activityID",as.character(features[,2]))
names(testset) <- c("set","subjectID","activityID",as.character(features[,2]))

## Row bind the two sets together.
alldata <- rbind(trainset,testset)


###########################################################



## 2. Extracts only the measurements on the mean and standard deviation for each 
## measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject. 