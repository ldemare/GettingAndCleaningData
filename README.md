GettingAndCleaningData
======================

Course Project for Getting and Cleaning Data

The source code (run_analysis.R) will create two tidy data sets combining both the training and test data from Samsung accelerometer and gyroscope measurements downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

To use run_analysis.R, download in script in your current working directory. This directory must also contain the UCI HAR Dataset folder, which can be downloaded from the above url.

The script will create a folder called "analysis" and deposit two tidy datasets within:

tidyData.txt - contains all mean and standard deviation calculations for each observed activity (walking, walking_upstairs, walking_downstairs, sitting, standing, and laying) by participants (1-30) 

tidyData_means.txt - aggregates means and standard deviations for all observations per participant per activity and provides their mean values

