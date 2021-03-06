################################################################################################################################
library("readr")
library("dplyr")
#activity_labels (walking...) Links the activity ID with their activity name.
activity_labels <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\activity_labels.txt")

#features for vector x
features <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\features.txt")


#A 561-feature vector with time and frequency domain variables.
X_train <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\train\\X_train.txt")

#Its associated activity label. 
Y_train <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\train\\Y_train.txt")

#An identifier of the subject who carried out the experiment
subject_train <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\train\\subject_train.txt")


##A 561-feature vector with time and frequency domain variables.
X_test <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\test\\X_test.txt")

#Its associated activity label. 
Y_test <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\test\\Y_test.txt")

#An identifier of the subject who carried out the experiment
subject_test <- read.table(file = "C:\\Users\\maxpoz\\Downloads\\UCI HAR Dataset\\test\\subject_test.txt")
  

#Rbind tables
Xtable<- rbind(X_train,X_test)
Ytable<- rbind(Y_train,Y_test)
subject_table<- rbind(subject_train,subject_test)

#Remove table from the global environment
rm(X_train,X_test,Y_train,Y_test,subject_train,subject_test)



#add column name for Xtable and rename the column name with features.txt (4 step in the assesment)
x_colnam<- colnames(Xtable)
namefeature<-features$V2
namefeature <- sapply(namefeature, as.character)
Xtable<-setnames(Xtable, x_colnam, namefeature)

#column name
names(Ytable)[1]<-"Activity"
names(activity_labels)[1]<-"activity code"
names(activity_labels)[2]<-"activity name"
names(subject_table)[1]<-"subject number"

#Cbin tables
dat <- cbind(subject_table,Ytable, Xtable)
rm(subject_table,Ytable, Xtable,features)


###################################################################
#Extract only the measurements on the mean and standard deviation for each measurement will called "datameanstd"

#find word mean and sdt in column name of the dat data frame
index<-grep("mean|std|subject number|Activity", colnames(dat))

#create new data frame with mean and std variables
datameanstd<-dat[ , index, drop = FALSE]


###################################################################
#3. Uses descriptive activity names to name the activities in the data set


for(i in 1:nrow(datameanstd)) { # Loop over the column
  
  val<- datameanstd[i,2] # read the value
  
  index<-grep(val, rownames(activity_labels)) # finf val ind activity_label table
  
  datameanstd[i, 2] = as.character(activity_labels[index, 2]) # past the value 
  
} # Close loop!

###################################################################
#5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
# in "tidydata"

tidydata<-datameanstd
tidydata$`subject number` <- sapply(tidydata$`subject number`, as.numeric)

#group by subject, activities and summarize them

tidydata<-group_by(tidydata,`subject number`,`Activity`)
tidydata<-summarize_all(tidydata,funs(mean))

#display tidydata

tidydata
