
#run_analysis.R

# You may need to install packgages reshape2

# Load Library(reshape2) Need this library to run the melt function

# Load the datasets to prepare to merge

install.packages("reshape2")

library(reshape2)

xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")[xfeatures]
ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

train <- cbind(trainSubject, ytrain, xtrain)

xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")[xfeatures]
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

test <- cbind(testSubject, ytest, xtest)



# Merge the datasets and add labels. Instruction 1

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", xfeatures.names)

# Extracts only the measurements on the mean and standard deviation for each measurement. Instruction 2

xfeatures <- grep(".*mean.*|.*std.*", features[,2])
xfeatures.names <- features[xfeatures,2]
xfeatures.names = gsub('-mean', 'Mean', xfeatures.names)
xfeatures.names = gsub('-std', 'Std', xfeatures.names)
xfeatures.names <- gsub('[-()]', '', xfeatures.names)



# Uses descriptive activity names to name the activities in the data set. Instruction #3

actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
actLabels[,2] <- as.character(actLabels[,2])
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])



# Appropriately labels the data set with descriptive variable names. Instruction #4

allData$activity <- factor(allData$activity, levels = actLabels[,1], labels = actLabels[,2])
allData$subject <- as.factor(allData$subject)


allDataMelt <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allDataMelt, subject + activity ~ variable, mean)

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject. Instruction #5

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)