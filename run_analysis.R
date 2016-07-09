# This program is to clean up the dataset obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# (data collected from the accelerometers from the Samsung Galaxy S smartphone)
# The purpose of this program is to demostrate its abilities in:
# 1. Merges the training and the test sets to create one data set
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

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

# function to labels the data set with descriptive variable names
labelVariableName <- function() {
  #=================================================================================================================================
  #=                                          Part 1 : Processing Data Sets Labelling                                              =
  #= 1. filter out matched columns from merged "test" and "train" data sets                                                        =
  #= 2. Replace matching patterns with descriptive name                                                                            =
  #=================================================================================================================================
  
  descVariableName <<- as.character(colLabelName[filteredColIndex])
  descVariableName <<- lapply(descVariableName, function(x){
    temp = x
    temp = str_replace(temp, "tBody", "Time-Body")
    temp = str_replace(temp, "fBody", "Freq-Body") 
    temp = str_replace(temp, "mean", "Mean") 
    temp = str_replace(temp, "std", "Std")
    temp = str_replace(temp, "tGravity", "Time-Gravity")
    
    return(temp)
  })

  #=================================================================================================================================
  #=                                          Part 2 : Applying new Variable Name                                                  =
  #=================================================================================================================================  
  
  names(mergedDataSet) <<- c(descVariableName, "SubjectID", "Activity")
}

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

# function to test this solution
# directory - set the directory up until to the extracted data set's root level (EG. "c:\\UCI HAR Dataset" in Windows).
#           - the script will automatically query for files located in "test" and "train" sub directories
test <- function(directory) {
  setwd(directory)
  
  main()
}