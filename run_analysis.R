## Installing the required libraries if needed
libraryInstReq <- function(package) {
  suppressWarnings({
    if (!require(package,character.only=TRUE)) {
      installPackage <- readline(paste("Package",package,"not found. Install? (y for yes, otherwise for no): "))
      if (installPackage == "y") {
        install.packages(package)
      }
      require(package,character.only=TRUE)  
    }})
}
libraryInstReq("plyr")
libraryInstReq("reshape2")
## Download and unzip the dataset:
filename <- "getdata_dataset.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
  download.file(fileURL, filename)
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

###############################################################################
#Part 1: Merges the training and the test sets to create one data set.

#Reading the train and test datasets: x indicates training or test set. y training or test labels. 
#subject_train or subject_test identifies per each row the subject who performed the activity

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

#Reading the variable names and set as column names in x data set

features <- read.table("UCI HAR Dataset/features.txt")
names(x_data) <- features[,2]
###############################################################################
#Part 2: Extracts only the measurements on the mean and standard deviation 
#for each measurement. 

# Integer identifying the columns with mean() or std() as part of the name
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

# Subset of x data set with mean and std
x_data_sub <- x_data[, mean_std]

###############################################################################
#Part 3: Uses descriptive activity names to name the activities in the data set

activity <- read.table("UCI HAR Dataset/activity_labels.txt")

# Updating column name for y_data
names(y_data) <- "activity"

# Setting activity names as y_data
y_data[, 1] <- activity[y_data[, 1], 2]

###############################################################################
#Part 4: Appropriately label the data set with descriptive variable names
# Setting column name
names(subject_data) <- "subject"

# Creating a complete tidy data set
data_set <- cbind(subject_data, y_data, x_data_sub)

###############################################################################
# Part 5: Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

# Using melt from reshape2 package to transform the wide data_set into a long data set 
average_set_prepare <- melt(data_set,id.vars= c("subject","activity"))
#Using dcast from reshape2 package to calculate the mean and produce  
average_set <- dcast(average_set_prepare, subject+activity ~ variable, fun.aggregate=mean)
#writing tidy data
write.table(average_set, "averages.txt", row.name=FALSE)
