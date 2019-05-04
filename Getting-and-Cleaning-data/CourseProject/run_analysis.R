library(data.table)
library(dplyr)

# Unzip data file
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "data.zip"))
unzip(zipfile = "data.zip")

# Get the following info for each of the record
# 1. A 561-feature vector with time and frequency domain variables. 
# 2. Its activity label. 
# 3. An identifier of the subject who carried out the experiment.

# This gives the 561-feature training and test vector 
X_train <- read.table(
  "./UCI HAR Dataset/train/X_train.txt",
  header = FALSE,
  row.names = NULL
  )

X_test <- read.table(
  "./UCI HAR Dataset/test/X_test.txt",
  header = FALSE,
  row.names = NULL
  )

# Step 1: Merge the training and the test sets to create one data set.
dataset <- rbind(X_train, X_test)

# Get feature info and set column names for the dataset
features <- read.table(
  "./UCI HAR Dataset/features.txt",
  header = FALSE,
  row.names = NULL
  )

colnames(dataset) <- as.character(features[[2]])

# Step 2: Extracts only the measurements on the mean and standard
# deviation for each measurement.
columns <- grep("mean\\(\\)|std\\(\\)", colnames(dataset))
dataset <- dataset[, columns]

# Get the activities i.e., y_train and y_test
y_train <- read.table(
  "./UCI HAR Dataset/train/y_train.txt",
  header = FALSE,
  row.names = NULL
)

y_test <- read.table(
  "./UCI HAR Dataset/test/y_test.txt",
  header = FALSE,
  row.names = NULL
)

dataset_y <- rbind(y_train, y_test)

# Get activity names
activities <- read.table(
  "./UCI HAR Dataset/activity_labels.txt",
  header = FALSE,
  row.names = NULL
)

# Step 3: Uses descriptive activity names to name the activities in the data set
dataset_y <- dataset_y %>% mutate(activity = activities$V2[dataset_y$V1]) %>% select(activity)
dataset <- cbind(dataset, dataset_y)

# Step 4: Appropriately labels the data set with descriptive variable names.
# Make the labels descriptive, by changing Acc to Accelerometer, Gyro to
# Gyroscope and the ones starting with t are time related and the ones starting
# with f are frequency related. Name them appropriately
names(dataset) <- sub("^t", "time ", names(dataset))
names(dataset) <- sub("^f", "frequency ", names(dataset))
names(dataset) <- sub("Acc", " Accelerometer ", names(dataset))
names(dataset) <- sub("Gyro", " Gyroscope ", names(dataset))
names(dataset) <- sub("Mag", "Magnitude ", names(dataset))

# Finally, get the subject ID as well and append to our data
subject_train <- read.table(
  "./UCI HAR Dataset/train/subject_train.txt",
  header = FALSE,
  row.names = NULL
)

subject_test <- read.table(
  "./UCI HAR Dataset/test/subject_test.txt",
  header = FALSE,
  row.names = NULL
)

subject <- rbind(subject_train, subject_test)

dataset <- cbind(dataset, subject)
colnames(dataset)[colnames(dataset) == "V1"] <- "subject"

# Step 5: From the data set in step 4, creates a second, independent tidy
# data set with the average of each variable for each activity and each subject.
dataset2 <- mutate(dataset, subject = as.factor(subject)) %>% 
  group_by(activity, subject) %>% 
  summarize_each(funs(mean)) %>% 
  ungroup

write.table(dataset2, "dataset.txt", row.names = FALSE)