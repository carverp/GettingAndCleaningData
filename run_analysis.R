## run_analysis.R
## 
## Description: 
## These R scripts are used to download and transform the Raw data
## into Tidy data.
##
## 1.Merges the training and the test sets to create one data set.
##
## 2.Extracts only the measurements on the mean and standard deviation 
## for each measurement. 
## 
## 3.Uses descriptive activity names to name the activities in the data set
## 
## 4.Appropriately labels the data set with descriptive variable names. 
## 
## 5.From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
##
########################################################################


run_analysis <- function(){
    library(dplyr)
    
    # Download data
    getdata()
    
    # Transform the data
    avgPerSubjectActivity<-mergeData()
    
    # Write out tidy dataset to txt file
    write.table(avgPerSubjectActivity,"SubjectActivityMeans.txt"
                ,row.names=FALSE)
}

# Download and Extract Raw data for project
getdata <- function(){
    url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    if (!file.exists("data")){
        dir.create("data")
    }
    
    download.file(url, "./data/uci_har_data.zip", "curl")
    
    dateDownloaded <- date()
    
    unzip("./data/uci_har_data.zip",exdir="./data")
}


# 1.Merges the training and the test sets to create one data set.
mergeData <- function(){
    

    # _test dataset
    subject_test_file <- "./data/UCI HAR Dataset/test/subject_test.txt"
    X_test_file <- "./data/UCI HAR Dataset/test/X_test.txt"
    Y_test_file <- "./data/UCI HAR Dataset/test/y_test.txt"
    
    # _train dataset
    subject_train_file <- "./data/UCI HAR Dataset/train/subject_train.txt"
    X_train_file <- "./data/UCI HAR Dataset/train/X_train.txt"
    Y_train_file <- "./data/UCI HAR Dataset/train/y_train.txt"
    
    
    # Read in data
    subject_test<-read.table(subject_test_file,stringsAsFactors=FALSE,header=FALSE)
    X_test<-read.table(X_test_file, stringsAsFactors=FALSE,header=FALSE, colClasses="numeric")
    Y_test<-read.table(Y_test_file, stringsAsFactors=FALSE,header=FALSE)
    
    subject_train<-read.table(subject_train_file,stringsAsFactors=FALSE,header=FALSE)
    X_train<-read.table(X_train_file, stringsAsFactors=FALSE,header=FALSE, colClasses="numeric")
    Y_train<-read.table(Y_train_file, stringsAsFactors=FALSE,header=FALSE)
    
    # Read in feature names
    featureNames <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE,header=FALSE)
    
    # Read in Activity Labels
    activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE,header=FALSE)
    
    
    # _test dataset #
    # Add Descriptive Feature Names to data set 
    names(subject_test)<-c("Subject")
    names(X_test) <- paste(featureNames[[1]],featureNames[[2]],sep="")
#     names(Y_test)<-c("activity")
    
    activity_test<-factor(Y_test[[1]]) # Create a Factor for Activities
    levels(activity_test) = activityLabels[[2]] # Change Labels for the levels 
    activity_test <- data.frame(activity_test)
    names(activity_test)<-c("Activity")

    # Remove un-required features/columns
    MeanAndStd_test <- removefeatures(X_test)
    
    # Join Columns of data together to make one _test dataset; order is by row position
    tidydf_test <- cbind(subject_test, MeanAndStd_test, activity_test)
    
    # _train dataset #
    # Add Descriptive Feature Names to data set 
    names(subject_train)<-c("Subject")
    names(X_train) <- paste(featureNames[[1]],featureNames[[2]],sep="")
#     names(Y_train)<-c("activity")
    
    activity_train<-factor(Y_train[[1]]) # Create a Factor for Activities
    levels(activity_train) = activityLabels[[2]] # Change Labels for the levels 
    activity_train <- data.frame(activity_train)
    names(activity_train)<-c("Activity")

    # Remove un-required features/columns
    MeanAndStd_train <- removefeatures(X_train)
    
    # Join Columns of data together to make one _train dataset; order is by row position
    tidydf_train <- cbind(subject_train,MeanAndStd_train,activity_train)
    
    
    # Join Rows of data together to make one combined(test and train) dataset
        ### Using rbind is allowable since subjectid is unique; only in test OR train not both
    tidydf <- rbind(tidydf_test,tidydf_train)
    
    # Fix Column Labels
    names(tidydf)<-gsub("^[0-9]*t","Time",names(tidydf))
    names(tidydf)<-gsub("^[0-9]*f","Freq",names(tidydf))
    names(tidydf)<-gsub("-mean\\(\\)","Mean",names(tidydf))
    names(tidydf)<-gsub("-std\\(\\)","Std",names(tidydf))
    names(tidydf)<-gsub("-","",names(tidydf))

    # Data Frame with the average of each variable for each activity and each subject.
    avgPerSubjectActivity<-tidydf %>% group_by(Subject, Activity) %>% summarise_each(funs(mean))

    avgPerSubjectActivity
}

# Remove features that are not mean() or std()
removefeatures <- function(X){
    select(X,grep("mean\\(\\)|std\\(\\)",names(X)))
}


