library(data.table)
library(reshape2)
library(plyr)

#create directory named "analysis" to write tidy data:
if (!file.exists("analysis")) {dir.create("analysis")}

#get feature names (will be column names for data.table):
features <-read.table("./UCI HAR Dataset//features.txt")
colNames <-data.table(features$V2)

#read in training and testing measurement vectors:
training_measurements <-read.table("./UCI HAR Dataset/train//X_train.txt", quote="")
testing_measurements <-read.table("./UCI HAR Dataset/test/X_test.txt", quote="")

#get participant IDs for training and test data:
tmp1 <- read.table("./UCI HAR Dataset//train/subject_train.txt", quote = "")
tmp2 <- read.table("./UCI HAR Dataset/test//subject_test.txt", quote = "")
participant_ID <- rbind(tmp1, tmp2)

#get numerical activity descriptors for training and test data:
tmp3 <- read.table("./UCI HAR Dataset/train//y_train.txt", quote = "")
tmp4 <- read.table("./UCI HAR Dataset/test//y_test.txt", quote = "")
activity <- rbind(tmp3, tmp4)

#create data table with training/testing measurement data:
DT <- data.table(rbind(training_measurements, testing_measurements))

#add column names to data table:
setattr(DT, 'names', as.character(t(colNames)))

#select mean and standard deviation calculations from data table:
DT_mean_stdev <- DT[, grep("*mean*|*std*", names(DT)), with=FALSE]

#add columns to data table with participant ID and activity descriptor        
DT_mean_stdev[,"Participant_id":=participant_ID] 
DT_mean_stdev[,"Numerical_label":=activity]    

activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote = "")
DT_activityLabels<- data.table(activityLabels)
setattr(DT_activityLabels, 'names', c("Numerical_label", "Activity_descriptor"))

setkey(DT_mean_stdev, "Numerical_label"); setkey(DT_activityLabels, "Numerical_label")
DT_withActivity <-merge(DT_mean_stdev, DT_activityLabels)

#write out tidy data set to Analysis folder
setwd("./analysis/")
write.table(DT_withActivity, file = "./tidyData.txt", row.names=FALSE)

#get mean measurements for each participant and activity
attach(DT_withActivity)
aggdata <-aggregate(DT_withActivity, by=list(Participant_id, Activity_descriptor),FUN=mean)
detach(DT_withActivity)

#remove redundant columns used for join and rename columns
aggdata$Numerical_label <-NULL
tidy_data2 <- rename(aggdata, c("Group.1" = "Activity", "Group.2" = "Participant"))

#write out second tidy data table with means
write.table(tidy_data2, file = "./tidyData_means.txt", row.names = FALSE)

