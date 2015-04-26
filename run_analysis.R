# load the required library packages
library(plyr)
library(dplyr)
library(Hmisc)
library(reshape2)

# Get date to be used as filename extension
Date <- format(Sys.time(), "%Y%m%d%H%M%S")

# Check whether directory exists 
if(file.exists("UCI HAR Dataset/") == FALSE) {
  stop("Samsung data directory (UCI HAR Dataset/) not found")
}

# Copy required files into a new directory called "wrk-<Date>" for later reference
wrkDir <- paste("wrk-", Date, sep = "")
dir.create(wrkDir)
file.copy("UCI HAR Dataset//test//X_test.txt", wrkDir)
file.copy("UCI HAR Dataset//test//y_test.txt", wrkDir)
file.copy("UCI HAR Dataset//train//X_train.txt", wrkDir)
file.copy("UCI HAR Dataset//train//y_train.txt", wrkDir)
file.copy("UCI HAR Dataset//features.txt", wrkDir)
file.copy("UCI HAR Dataset//test/subject_test.txt", wrkDir)
file.copy("UCI HAR Dataset//train//subject_train.txt", wrkDir)
file.copy("UCI HAR Dataset//activity_labels.txt", wrkDir)
setwd(wrkDir)

# Create a single file X.txt with contents X_train.txt and X_test.txt 
file.copy("X_train.txt", "X.txt")
file.append("X.txt", "X_test.txt")

# Create a single file y.txt with contents y_train.txt and y_test.txt 
file.copy("y_train.txt", "y.txt")
file.append("y.txt", "y_test.txt")

# Create a single file subject.txt with contents subject_train.txt and subject_test.txt 
file.copy("subject_train.txt", "subject.txt")
file.append("subject.txt", "subject_test.txt")

# Set the required filenames
Xfilename <- "X.txt"
yfilename <- "y.txt"
featuresFileName <- "features.txt"
subjectFileName <- "subject.txt"
activityFileName <- "activity_labels.txt"

# read the lines from X.txt, y.txt and features.txt
Xlines <- readLines(Xfilename)
ylines <- readLines(yfilename)
featuresLines <- readLines(featuresFileName)
subjectLines <- readLines(subjectFileName)
activityLines <- readLines(activityFileName)

# convert lines to the required R objects 
Xlinessplit <- stri_split_fixed(Xlines, " ", omit_empty = TRUE)
Xdf <- data.frame(matrix(unlist(Xlinessplit), ncol=561),stringsAsFactors=FALSE)
ydf <- data.frame(matrix(unlist(ylines), ncol=1),stringsAsFactors=FALSE)
features <- unlist(featuresLines)
subject <- unlist(subjectLines)
activitylinessplit <- stri_split_fixed(activityLines, " ", omit_empty = TRUE)
activitydf <- t(data.frame(matrix(unlist(activitylinessplit), c(2,6)),stringsAsFactors=FALSE))

# Merge X and y
colnames(Xdf) <- features
DF <- cbind(Xdf, ydf)
colnames(DF)[562] <- "Parameter"

# Merge subject
DF <- cbind(DF, subject)
colnames(DF)[563] <- "Subject"

# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# build a vector of mean() and std() occurences from features
col2extract <- grepl("-mean()|-std()", features)
DFOfMeanAndStd <- DF[,c(col2extract, TRUE, TRUE)]

# 3.Uses descriptive activity names to name the activities in the data set
colnames(activitydf) <- c("Parameter", "Activity.Name")
mergedDF <- merge(DFOfMeanAndStd,activitydf)

# 5.From the data set in step 4, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.
meltDF <- melt(mergedDF, id = c("Parameter", "Activity.Name", "Subject"))
meltDF[,"value"] <- as.numeric(meltDF[,"value"])
tidyDF <- dcast(meltDF, Parameter + Activity.Name + Subject ~ variable, mean)
write.table(tidyDF, file = "tidyDF.txt", row.name = FALSE)
setwd("..")

