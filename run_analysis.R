# Code to download the provided data set for the assignment 

if(!file.exists("./data")){dir.create("./data")}

#The below is link to the data for the project in Getting and Cleaning Data Course

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzipping the data to the directory using the code below

unzip(zipfile="./data/Dataset.zip",exdir="./data")

#The below is the R script run_analysis.R which will do the following steps as per the requirement

# Merging the training and the test sets in order to create one data set


# First reading the training, testing, features, and activity tables

x_training <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_training <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_testing <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_testing <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activity_labels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Second is assigning column names as follows

colnames(x_training) <- features[,2]
colnames(y_training) <-"activity"
colnames(subject_training) <- "subject"

colnames(x_testing) <- features[,2] 
colnames(y_testing) <- "activity"
colnames(subject_testing) <- "subject"

colnames(activity_labels) <- c('activity','activity_type')

#Thirs is merging all the data in one data set as follows:

merging_training <- cbind(y_training, subject_training, x_training)
merging_testing <- cbind(y_testing, subject_testing, x_testing)
merg_all <- rbind(merging_training, merging_testing)

#dim(merg_all)
#[1] 10299   563

#Now, Extracting only the measurements on the mean and standard deviation for each measurement.

#2.1 Reading column names:

column_names <- colnames(merg_all)

#2.2 Create vector for defining ID, mean and standard deviation:

mean_and_std_deviation <- (grepl("activity" , column_names) | 
                                   grepl("subject" , column_names) | 
                                   grepl("mean.." , column_names) | 
                                   grepl("std.." , column_names) 
)

# Now producing subset from merg_all as follows:

sup_set <- merg_all[ , mean_and_std_deviation == TRUE]

# Now using descriptive activity names to name the activities in the data set and label them appropriately as follows:

sub_set_activity_names <- merge(sup_set, activity_labels,
                                by='activity',
                                all.x=TRUE)


# Now from the data set above, creating a second, independent tidy data set with the average of each variable for each activity and each subject as follows:


sec_ind_tidy_set <- aggregate(. ~subject + activity, sub_set_activity_names, mean)
sec_ind_tidy_set <- sec_ind_tidy_set [order(sec_ind_tidy_set $subject, sec_ind_tidy_set $activity),]

#Finally, writing the second tidy data set in txt file

write.table(sec_ind_tidy_set, " sec_ind_tidy_set.txt", row.name=FALSE)

