####################################################################
## run_analysis.R
## Script for "Getting and cleaning data" course week 4 assignment
## Author: Tim Beard
##
## The script:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation 
##    for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.
##
## run_analysis() function inputs:
## savefile: name of the file to save the result to (default "summarydata.txt")
##
## The raw data:
## x_...: observation data for 561 variables
## subject_...: ID of subjects for each observation
## y_...: activity type for each observation (as an ID number)
## features.txt: list of the column headings
## activity_labels.txt: mapping between activity ID and name
###################################################################

run_analysis <- function(savefile = "summarydata.txt") {

    library(dplyr)
    library(tidyr)
    oldopt <- options(stringsAsFactors = FALSE)
    
    ## 1. Read in all the data files and combine them
    print("Reading in training data...")
    
    xtrain <- read.table("UCI HAR Dataset//train//X_train.txt")
    ytrain <- read.table("UCI HAR Dataset//train//y_train.txt")
    subtrain <- read.table("UCI HAR Dataset//train//subject_train.txt")
    
    traindata <- cbind(subtrain, ytrain, xtrain) # merge the columns
    
    print("Reading in test data...")
    xtest <- read.table("UCI HAR Dataset//test//X_test.txt")
    ytest <- read.table("UCI HAR Dataset//test//y_test.txt")
    subtest <- read.table("UCI HAR Dataset//test//subject_test.txt")
    
    testdata <- cbind(subtest, ytest, xtest) # merge the columns
    
    alldata <- rbind(traindata, testdata) # merge the two datasets
    
    print("Merging and tidying data...")
    
    ## Add supplied column headings
    ## The "make.names" function ensures the features are valid names
    features <- read.table("UCI HAR Dataset//features.txt")
    colnames(alldata) <- c("subjectid", "activityid", 
                           make.names(features$V2, unique = TRUE))
    
    alldata <- tbl_df(alldata) # create a tibble for dplyr
   
    activities <- read.table("UCI HAR Dataset//activity_labels.txt")
    colnames(activities) <- c("activityid", "activity")
    tidydata <- alldata %>%
    ## 2. Select mean and std columns
    ## 3. Convert activity numbers to descriptive labels 
        merge(activities, by.x = "activityid", by.y = "activityid") %>%
        select(subjectid, activity, matches("([.]mean[.][.])|([.]std[.][.])"))

    ## 4. Label columns descriptively
    ## I can't see an obviously better way of renaming all the columns
    ## so just remove the ".."s introduced by make.names
    ## and turn the subject and activity columns into factors
    colnames(tidydata) <- sub("[.][.]","", colnames(tidydata))
    tidydata$subjectid <- as.factor(tidydata$subjectid)
    tidydata$activity <- as.factor(tidydata$activity)
    
    ## 5. Create summary table
    summarydata <- tidydata %>%
        group_by(subjectid, activity) %>%
        summarise_all(mean)
    
    write.table(summarydata, file = savefile, row.names = FALSE)
    
    options(stringsAsFactors = oldopt$stringsAsFactors) # return setting to original
    
    summarydata
}

