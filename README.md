# Getting-and-Cleaning-data---Course-Project
Files related to the course project of the Coursera class Getting  and Cleaning Data

Raw data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to samsung and unzip it. The script run_analysis.R needs the libraries plyr and reshape2. If needed it will download and install them (press 'y' at the dialogue)

The script downloads the dataset if it does not already exist in the working directory
Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
Loads the activity and subject data for each dataset, and merges those columns with the dataset
Merges the two datasets
Creates a tidy dataset with the mean value of each variable for each subject and activity pair.
The end result is shown in the file averages.txt.
