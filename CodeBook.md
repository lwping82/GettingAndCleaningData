# Getting And Cleaning Data
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#About the data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#About the variables
## Abbreviations used on measurement
No#  | Code | Description
-----|------|-------------
1 | Time  | Time domain signal
2 | Freq  | Frequency domain signal
3 | Acc | Accelerometer sensor
4 | Gyro | Gyroscope sensor
5 | Gravity | Gravity acceleration
6 | Jerk | The body linear acceleration and angular velocity derived in time
7 | Mag | Figure obtained based on the three-dimensional signals calculation using Euclidean norm
8 | Mean() | Mean value
9 | Std() | Standard deviation

## Measurement Variables List
+ Time-BodyAcc-Mean()-X
+ Time-BodyAcc-Mean()-Y
+ Time-BodyAcc-Mean()-Z
+ Time-BodyAcc-Std()-X
+ Time-BodyAcc-Std()-Y
+ Time-BodyAcc-Std()-Z           
+ Time-GravityAcc-Mean()-X
+ Time-GravityAcc-Mean()-Y
+ Time-GravityAcc-Mean()-Z
+ Time-GravityAcc-Std()-X        
+ Time-GravityAcc-Std()-Y
+ Time-GravityAcc-Std()-Z
+ Time-BodyAccJerk-Mean()-X
+ Time-BodyAccJerk-Mean()-Y      
+ Time-BodyAccJerk-Mean()-Z
+ Time-BodyAccJerk-Std()-X
+ Time-BodyAccJerk-Std()-Y
+ Time-BodyAccJerk-Std()-Z       
+ Time-BodyGyro-Mean()-X
+ Time-BodyGyro-Mean()-Y
+ Time-BodyGyro-Mean()-Z
+ Time-BodyGyro-Std()-X          
+ Time-BodyGyro-Std()-Y
+ Time-BodyGyro-Std()-Z
+ Time-BodyGyroJerk-Mean()-X
+ Time-BodyGyroJerk-Mean()-Y     
+ Time-BodyGyroJerk-Mean()-Z
+ Time-BodyGyroJerk-Std()-X
+ Time-BodyGyroJerk-Std()-Y
+ Time-BodyGyroJerk-Std()-Z      
+ Time-BodyAccMag-Mean()
+ Time-BodyAccMag-Std()
+ Time-GravityAccMag-Mean()
+ Time-GravityAccMag-Std()       
+ Time-BodyAccJerkMag-Mean()
+ Time-BodyAccJerkMag-Std()
+ Time-BodyGyroMag-Mean()
+ Time-BodyGyroMag-Std()         
+ Time-BodyGyroJerkMag-Mean()
+ Time-BodyGyroJerkMag-Std()
+ Freq-BodyAcc-Mean()-X
+ Freq-BodyAcc-Mean()-Y          
+ Freq-BodyAcc-Mean()-Z
+ Freq-BodyAcc-Std()-X
+ Freq-BodyAcc-Std()-Y
+ Freq-BodyAcc-Std()-Z           
+ Freq-BodyAccJerk-Mean()-X
+ Freq-BodyAccJerk-Mean()-Y
+ Freq-BodyAccJerk-Mean()-Z
+ Freq-BodyAccJerk-Std()-X       
+ Freq-BodyAccJerk-Std()-Y
+ Freq-BodyAccJerk-Std()-Z
+ Freq-BodyGyro-Mean()-X
+ Freq-BodyGyro-Mean()-Y
+ Freq-BodyGyro-Mean()-Z
+ Freq-BodyGyro-Std()-X
+ Freq-BodyGyro-Std()-Y
+ Freq-BodyGyro-Std()-Z          
+ Freq-BodyAccMag-Mean()
+ Freq-BodyAccMag-Std()
+ Freq-BodyBodyAccJerkMag-Mean()
+ Freq-BodyBodyAccJerkMag-Std() 
+ Freq-BodyBodyGyroMag-Mean()
+ Freq-BodyBodyGyroMag-Std()
+ Freq-BodyBodyGyroJerkMag-Mean()
+ Freq-BodyBodyGyroJerkMag-Std()

## Additional Variables List
+ SubjectID - Volunteer Unique identifier
+ Activity - Six experiments' activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

#About the code
## Loading packages and declaring common variables

```
library(dplyr)
library(stringr)

# constant names for both "test" and "train" data sets.
# update the value accordingly if you have updated the categorized test data codes

# "test" data set code
CONSTTEST <- c("test")

# "train" data set code
CONSTTRAIN <- c("train")

# common variables for this program
mergedDataSet <- NULL
colLabelID <- NULL
colLabelName <- NULL
filteredColIndex <- NULL
```

## Function to merge data sets
```
# function to merge both the "train" and "test" data sets
mergeDataSet <- function() {
  #=================================================================================================================================
  #=                                          Part 1 : Processing Data Sets Labelling                                              =
  #= 1. Loading given columns' names from features.txt                                                                             =
  #= 2. Data will be loaded then splitted into two parts, namely its ID and Name                                                   =
  #=================================================================================================================================
  
  colLabel <- read.csv("features.txt", header=FALSE, sep="\n")
  colLabelID <<- sapply(colLabel[,1], function(x) str_extract(x, "^[0-9]*"))
  colLabelName <<- sapply(colLabel[,1], function(x) str_trim(str_extract(x, " .*$")))
  
  #=================================================================================================================================
  #=                                          Part 2 : Processing "test" data                                                      =
  #=================================================================================================================================  
  
  # 1. Loading "test" data sets
  testDataSet <- read.table(paste(CONSTTEST, "/X_", CONSTTEST, ".txt", sep=""), header=FALSE)
  
  # 2. Appending column name to "test" data sets
  names(testDataSet) <- colLabelID
  
  #=================================================================================================================================
  #=                                          Part 3 : Processing "train" data                                                     =
  #=================================================================================================================================    
  
  # 1. Loading "train" data sets
  trainDataSet <- read.table(paste(CONSTTRAIN, "/X_", CONSTTRAIN, ".txt", sep=""), header=FALSE)
  
  # 2. Appending column name to "train" data sets
  names(trainDataSet) <- colLabelID
  
  #=================================================================================================================================
  #=                                                Part 4 : Merges the data sets                                                  =
  #=================================================================================================================================     
  
  mergedDataSet<<-rbind(testDataSet, trainDataSet)
}
```

## Function to extract measurements having mean and std value
```
# function to extracts only the measurements on mean and standard deviation for each measurement 
extractMeasurementsWithMeanOrStd <- function() {
  #=================================================================================================================================
  #=                                          Part 1 : Processing Columns' Labels                                                  =
  #= 1. Search for all columns start with "fbody" or "tbody" or "tGravity" containing the word "mean" or "sub" in between the      =
  #=    given name                                                                                                                 =
  #= 2. Exclude columns with "angle" measurement                                                                                   =
  #=================================================================================================================================  
  
  filteredColIndex <<- grep("^[^angle]*(([fbody])|([tbody])|(tGravity)).*(((std)|(mean))[^meanFreq]).*$", colLabelName)
  
  #=================================================================================================================================
  #=                                              Part 2 : Clean merged data sets                                                  =
  #= 1. filter out matched columns from merged "test" and "train" data sets                                                        =
  #=================================================================================================================================  
  
  mergedDataSet <<- mergedDataSet[, filteredColIndex[]]
  
  #=================================================================================================================================
  #=                 Part 3 : Merging subject and activity data sets into the captured signals data sets                           =
  #=================================================================================================================================    
  
  # 1. Loading subject and activity data sets
  testSubjectDataSet <- read.csv(paste(CONSTTEST, "/subject_", CONSTTEST, ".txt", sep=""), header=FALSE, row.names=NULL)
  testActivityDataSet <- read.csv(paste(CONSTTEST, "/y_", CONSTTEST, ".txt", sep=""), header=FALSE, row.names=NULL)  
  
  trainSubjectDataSet <- read.csv(paste(CONSTTRAIN, "/subject_", CONSTTRAIN, ".txt", sep=""), header=FALSE)
  trainActivityDataSet <- read.csv(paste(CONSTTRAIN, "/y_", CONSTTRAIN, ".txt", sep=""), header=FALSE)  
  
  # 2. Appending column name
  names(testSubjectDataSet) <- c("subjectID")
  names(testActivityDataSet) <- c("activityID")
  
  names(trainSubjectDataSet) <- c("subjectID")
  names(trainActivityDataSet) <- c("activityID")
  
  # 3. Merging the subject and activity data sets into merged signals data set  
  mergedDataSet$subjectID <<- rbind(testSubjectDataSet, trainSubjectDataSet)
  mergedDataSet$activityID <<- rbind(testActivityDataSet, trainActivityDataSet)  
  
  # 4. Converting subject and activity data type for easier processing in subsequence steps
  mergedDataSet$subjectID <<- apply(mergedDataSet$subjectID, 2, function(x) {as.numeric(as.character(x))})
  mergedDataSet$activityID <<- apply(mergedDataSet$activityID, 2, function(x) {as.numeric(as.character(x))})
}
```

## Function to replace the activity ID with descriptive name
```
# function to replace activity ID with its descriptive name
applyDescriptiveActivityName <- function() {
  #=================================================================================================================================
  #=                                          Part 1 : Processing Data Sets Labelling                                              =
  #= 1. Loading given columns' names from activity_labels.txt                                                                      =
  #= 2. Data will be loaded then splitted into two parts, namely its ID and Name                                                   =
  #=================================================================================================================================
  
  activityLabel <- read.csv("activity_labels.txt", header=FALSE)
  activityLabelID <- sapply(activityLabel[,1], function(x) str_extract(x, "^[0-9]*") )
  activityLabelName <- sapply(activityLabel[,1], function(x) str_trim(str_extract(x, " .*$")) )
  
  mergedDataSet$activityID <<- apply(mergedDataSet$activityID, 1, function(x) {   
      for(r in 1:length(activityLabelID)) {
        if(activityLabelID[r]==x) {
          return(activityLabelName[r])
        }
      }
    })
}
```

## Function to label all variables with descriptive name
```
# function to labels the data set with descriptive variable names
labelVariableName <- function() {
  #=================================================================================================================================
  #=                                          Part 1 : Processing Data Sets Labelling                                              =
  #= 1. filter out matched columns from merged "test" and "train" data sets                                                        =
  #= 2. Replace matching patterns with descriptive name                                                                            =
  #=================================================================================================================================
  
  descVariableName <<- as.character(colLabelName[filteredColIndex])
  descVariableName <<- lapply(descVariableName, function(x){
    temp <- x
    temp <- str_replace(temp, "tBody", "Time-Body")
    temp <- str_replace(temp, "fBody", "Freq-Body") 
    temp <- str_replace(temp, "mean", "Mean") 
    temp <- str_replace(temp, "std", "Std")
    temp <- str_replace(temp, "tGravity", "Time-Gravity")
    
    return(temp)
  })

  #=================================================================================================================================
  #=                                          Part 2 : Applying new Variable Name                                                  =
  #=================================================================================================================================  
  
  names(mergedDataSet) <<- c(descVariableName, "SubjectID", "Activity")
}
```

## Function to organize the cleaned data then write it to a file
```
# function to create independent tidy data set with the average of each variable for each activity and each subject
createTidyDataSet <- function() {
  #=================================================================================================================================
  #=                                          Part 1 : Organizing final data set                                                   =
  #= 1. grouping of data based on subject ID and activity                                                                          =
  #= 2. order the result by subject ID and activity                                                                                =
  #=================================================================================================================================
  
  mergedDataSet <<- aggregate(mergedDataSet[1:(length(mergedDataSet)-2)], by=list(SubjectID = as.numeric(mergedDataSet$SubjectID), Activity=mergedDataSet$Activity), FUN=mean, na.rm=TRUE)
  mergedDataSet <<- mergedDataSet[order( as.numeric(mergedDataSet[, "SubjectID"]), mergedDataSet[, "Activity"] ), ]
  
  #=================================================================================================================================
  #=                                          Part 2 : Writing data to file                                                        =
  #=================================================================================================================================    
  
  write.table(mergedDataSet, file = "tidyData.txt", row.name=FALSE)
}
```

## Main function in controlling the whole process flow
```
# function to kick start the whole program
main <- function() {
  # Step 1: Merges "test" and "train" data sets
  mergeDataSet()
  
  # Step 2: Extract measurements on the mean and standard deviation for each measurement
  extractMeasurementsWithMeanOrStd()
  
  # Step 3: Apply descriptive activity names to name the activities in the data set
  applyDescriptiveActivityName()
  
  # Step 4: Appropriately labels the data set with descriptive variable names
  labelVariableName()
  
  # Step 5: Creates a second, independent tidy data set
  createTidyDataSet()
  
  # Display the tidy data
  displayAll()
}
```

## Convenient functions to filter and view the final data set
```
# function to display processed tidy data
displayAll <- function() {
  mergedDataSet[,]
}

# function to display processed tidy data by selected subject's ID
displayBySubjectID <- function(subjectID) {
  subset(mergedDataSet, mergedDataSet$Subject==subjectID)
}

# function to display processed tidy data by rows
displayByRow <- function(rows) {
  mergedDataSet[rows,]
}
```

## Function to test the program
```
# function to test this solution
# directory - set the directory up until to the extracted data set's root level (EG. "c:\\UCI HAR Dataset" in Windows).
#           - the script will automatically query for files located in "test" and "train" sub directories
test <- function(directory) {
  setwd(directory)
  
  main()
}
```