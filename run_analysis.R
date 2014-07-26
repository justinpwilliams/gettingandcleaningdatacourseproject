## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each 
## measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject. 

## NOTE: This assumes the zip file was extracted in the working
## directory.

require(plyr)
## Load the descriptions of the measurements
features <- read.table("UCI HAR Dataset/features.txt")

## Vector with mean and std row references from the features
meanandstd <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228,
                240:241, 253:254, 266:271, 294:296, 345:350, 373:375, 424:429, 
                452:454, 503:504, 516:517, 529:530, 542:543)

## Read in training data.
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

## Replace each numerical reference to an activity with a descriptive activity 
## name
for (i in 1:6) {
        trainy[trainy$V1 == i,] <- 
                as.character(activityLabels[activityLabels$V1 ==i,2])
}

for (i in 1:6) {
        testy[testy$V1 == i,] <- 
                as.character(activityLabels[activityLabels$V1 ==i,2])
}

## Restrict train variables to Mean and STD measurements and assign names
trainx <- trainx[,meanandstd]
testx <- testx[,meanandstd]
names(trainx) <- features[meandandstd,2]
names(testx) <- features[meandandstd,2]

## Give the variable names readable names using a function.
makenames <- function(x){
        for (i in 1:length(x)){
                if(substr(x[i],1,1) == "t") {x[i] <- sub("t","time",x[i])}
                if(substr(x[i],1,1) == "f") {x[i] <- sub("f","frequency",x[i])}
        }
        x <- sub("Acc","Acceleration",x)
        x <- sub("Gyro","Gyroscope",x)
        x <- sub("Mag","Magnitude",x)
        x <- sub("mean\\(\\)","Mean",x)
        x <- sub("meanFreq\\(\\)","MeanFrequency",x)
        x <- sub("std\\(\\)","StandardDeviation",x)
        x <- gsub("\\-","",x)
        x
}
names(trainx) <- makenames(names(trainx))
names(testx) <- makenames(names(testx))

## Column bind the two sets together, plus an extra variable 'set' to identify
## whether the data came from the train set or the test set.
trainset <- cbind(trainsub, trainy, trainx)
testset <- cbind(testsub, testy, testx)

## Add set, subjectID, and activityID as the names to the test and training 
## data sets.
names(trainset)[1:2] <- c("subjectID","activity")
names(testset)[1:2] <- c("subjectID","activity")

## Row bind the two sets together.
alldata <- rbind(trainset,testset)

## Create the tidy data set, takign the mean of all measures by subject and 
## activity
tidy <- ddply(alldata, .(subjectID,activity), numcolwise(mean))