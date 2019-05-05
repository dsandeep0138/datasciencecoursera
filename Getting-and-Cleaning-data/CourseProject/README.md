# Getting and Cleaning Data - Course Project

## Purpose
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

## Data
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Packages used
- data.table
- dplyr

## Script description

Run run_analysis.R script which does the following

### Step 1: Merge the training and the test sets to create one data set.
- Extract training data and test data from 'train/X_train.txt' and 'test/X_test.txt' files
- These data is the 561-feature vector with time and frequency domain variables.
- Merge these two datasets to create a single data set.
- All the columns are named V1, V2, V3, ...
- Get all the feature names from 'features.txt' and assign these as column names for the dataset.

### Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
- Use regex to filter the column names that has mean() and std() in their names.

### Step 3: Use descriptive activity names to name the activities in the data set
- For this steps, read the activities from the files 'train/y_train.txt' and 'test/y_test.txt'
- These activity values are in the range 1-6
- Read activity labels corresponding to 1-6 from file 'activity_labels.txt'
- Assign the descriptive names to these numeric activities.

### Step 4: Appropriately labels the data set with descriptive variable names.
- Current labels are not much intuitive and doesn't give a clear picture.
- Change variable names starting with t to time and f to frequency to depict the type of variable
- Change short forms "Acc", "Gyro", "Mag" to descriptive names Accelerometer, Gyroscope and Magnitude respectively.

### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- Create a file datset.txt with average of each variable for each activity and each subject.