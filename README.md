# CleaningDataAssignment
# Readme.md
## for the "Getting and Cleaning Data" Coursera course week 4 assignment
## Author: Tim Beard 

This is the readme file for "Getting and Cleaning Data" course week 4 assignment.
The goal of the assignment is to gather some data and tidy it up. 

## Repo contents
- readme.md: this file
- run_analysis.R: the code to tidy the data
- codebook.md: description of the data headers

To reproduce the data analysis, download the data from the data source below, unzip it as shown and run `run_analysis.R` in R

## Data source: 

The data for this analysis was manually downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and unzipped using the default Windows 10 zip tool into the following directory structure:

```
{R working directory}
  |---- UCI HAR Dataset
          |------ features.txt
          |------ activity_labels.txt
          |------ test
          |         |---- {test data}
          |------ train
                    |---- {training data}  
```                     
All other actions on the data are performed by "run_analysis.R" assuming the above
directory structure.

## Actions
The script "run_analysis.R" does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Input files:
The training data:
* subject_train.txt:  Participant ID for each observation 
* X_train.txt:        Observation data from 561 features        
* y_train.txt:        The labels(i.e. the activities) associated with each observation

Similarly for the test data:
* subject_test.txt
* X_test.txt
* y_test.txt

Also: 
* features.txt: Feature labels  
* activity_labels.txt: mapping between activity number and activity 
* features_info.txt: describes the meaning of the feature labels

## Which columns are included in the tidied data set

We are asked to select only the mean and standard deviation for each measurement 
From "features_info.txt" we can see that the tags "mean()" and "std()" identify
the mean and standard deviation values we need. So all of these are included.

There are also some features labelled "meanFreq()" which are described as:
"Weighted average of the frequency components to obtain a mean frequency". I have 
NOT included these, as in each case a mean() and std() variable also exists for
those measurements.
  
The "angle" variable includes some features with "Mean" in their name. Again I have
NOT included these features because as far as I can see the terms labelled "Mean 
are inputs to the angle calculations and not averages of the measurements in their 
own right.    

## Column names
I have left the column names (i.e. the features) largely unchanged except to remove invalid characters and rename duplicates.
Arguably terms like "t", "f", "Acc, "Gyro" and "Mag" could be expanded out but I don't think this adds much clarity to the data. 

## Other information
The details of the actions performed on the above data are described in "run_analysis.R"

## Reading the ouput data file back in
The following R code will read the file in as intended:

``` R
   summarydata <- read.table("summarydata.txt", header = TRUE)
```
