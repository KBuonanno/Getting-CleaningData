  #set working directory to locate data files
  setwd("D:/DataScience/Course3 - Getting and Cleaning Data")  
  
  #load needed libraries
  library(data.table)
  
  #read data from working directory
  subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")
  X_test = read.table("UCI HAR Dataset/test/X_test.txt")
  Y_test = read.table("UCI HAR Dataset/test/Y_test.txt")
  subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")
  X_train = read.table("UCI HAR Dataset/train/X_train.txt")
  Y_train = read.table("UCI HAR Dataset/train/Y_train.txt")
  features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
  activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
  
  #structure data tables and merge data 
  activity_labels$activityLabel <- gsub("_", "", as.character(activity_labels$activityLabel))
  includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)
  subject_merge <- rbind(subject_test, subject_train)
  names(subject_merge) <- "subjectId"
  X_merge <- rbind(X_test, X_train)
  X_merge <- X_merge[, includedFeatures]
  names(X_merge) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
  Y_merge <- rbind(Y_test, Y_train)
  names(Y_merge) = "activityId"
  activity <- merge(Y_merge, activity_labels, by="activityId")$activityLabel
  
  #create data files
  tidy_data <- cbind(subject, X, activity)
  write.table(tidy_data, "tidy_data.txt")
  calc_tidy_data <- data.table(tidy_data)
  calc_tidy_data <- calc_tidy_data[, lapply(.SD, mean), by=c("subjectId", "activity")]
  write.table(calc_tidy_data, "calc_tidy_data.txt")