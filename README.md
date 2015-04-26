### Introduction
This repository is created for the "Getting and Cleaning Data Course Project".
It contains the following files:
- README.md      # this file
- run_analysis.R # R program for the data analysis

### Pre-requisites
The samsung data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
should be available as unzipped in the directory where this program will be run.

### Usage of run_analysis.R
Run this file from within R studio as follows:
> source("run_analysis.R")

This program does the following:
- creates a new working directory: wrk-<Date>, where Date is the FullISO date of current timestamp
- copies the files to work with from Samsung directory to the working directory
- appends the relevant training and test data files using file.append() and creates new files to work with
- reads the files using readLines()
- converts the read lines to relevant R objects
- merges X, y, activity and subject
- extracts only the mean and std measures plus the activity and subject into a new data frame
- merges the Activity.Name from activity_labels with the above data frame
- using melt() and dcast the means of various measures are calculated grouped by Activity and Subject
- The output is stored in the file called "tidyDF.txt" in the working directory

NOTE: In case of unexpected errors the programs stops in the working directory. So, you need to execute setwd("..") to be able to re-execute the script.

### Code book for tidyDF.txt
Is a data frame containing the following:
Paramter:
  The activity code from 1 to 6
  - 1 WALKING
  - 2 WALKING_UPSTAIRS
  - 3 WALKING_DOWNSTAIRS
  - 4 SITTING
  - 5 STANDING
  - 6 LAYING

Activity.Name:
  Readable name for the activity as given in Parameter.

Subject:
  The subject who performed the activity.

Colums 4 till 82:
  Means and Standard deviation of various features.
