# create training tables from training files
tbl_xtrain <- read.table("x_train.txt")
tbl_ytrain <- read.table("y_train.txt")
tbl_subject_train <- read.table("subject_train.txt")
colnames(tbl_subject_train) <- ("SubjectID")

# create test tables from test files 
tbl_xtest <- read.table("x_test.txt")
tbl_ytest <- read.table("y_test.txt")
tbl_subject_test <- read.table("subject_test.txt")
colnames(tbl_subject_test) <- ("SubjectID")

# create features tables and assign column names
tbl_features <- read.table("features.txt")
colnames(tbl_features) <- c("FeatureID", "Feature")

# create activity Lables and assign column names 
tbl_activity_labels <- read.table("activity_labels.txt")
colnames(tbl_activity_labels) <- c("ActivityID", "Activity")


# create table of rows of mean and std only. 
required_features <- grep( ".*mean.*|.*std.*",tbl_features[,2])

# Assign descriptive variable names for training data
colnames(tbl_xtrain) <- tbl_features[,2]
colnames(tbl_ytrain) <- "ActivityID"
#tbl_ytrain <- cbind(tbl_ytrain, "Activity")

# add descriptive activity to training - prior to merge
tbl_ytrain$Activity <- tbl_activity_labels$Activity[match(tbl_ytrain$ActivityID,tbl_activity_labels$ActivityID)]

# Assign descriptive variable names for test data
colnames(tbl_xtest) <- tbl_features[,2]
colnames(tbl_ytest) <- "ActivityID"
#tbl_ytest <- cbind(tbl_ytest, "Activity")

# add descriptive activity to test- prior to merge
tbl_ytest$Activity <- tbl_activity_labels$Activity[match(tbl_ytest$ActivityID,tbl_activity_labels$ActivityID)]


# merge test and traing data
tbl_xtrain_xtest <- rbind(tbl_xtrain,tbl_xtest)
tbl_ytrain_ytest <- rbind(tbl_ytrain,tbl_ytest)

# Select ony required measurement (mean and std)
tbl_xtrain_xtest <- tbl_xtrain_xtest[,required_features]

# Complete merge process
tbl_subject <- rbind(tbl_subject_train,tbl_subject_test)
tbl_allReqData <- cbind(tbl_subject, tbl_ytrain_ytest, tbl_xtrain_xtest)
  
# creates a second, independent tidy data set with the average of each variable 
tbl_TidyData <- aggregate(. ~SubjectID + Activity,tbl_allReqData, mean)
tbl_TidyData <- tbl_TidyData[order(tbl_TidyData$SubjectID, tbl_TidyData$Activity),]


  
