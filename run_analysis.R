library(dplyr)

#STEP1

#read test and training data
test<-read.table("UCI HAR Dataset/test/X_test.txt")
train<-read.table("UCI HAR Dataset/train/X_train.txt")
#combine
full<-rbind(test,train)

#STEP2
#read features.txt
features<-read.table("UCI HAR Dataset//features.txt")
#only use variables with mean() and std() in their names
full.mean.std<-full[,c(grep("mean\\(\\)",features$V2),grep("std\\(\\)",features$V2))]
#rename variables to the corresponding feature names
names(full.mean.std)<-features$V2[c(grep("mean\\(\\)",features$V2),grep("std\\(\\)",features$V2))]

#read activity files
act_test<-read.table("UCI HAR Dataset/test//y_test.txt")
act_train<-read.table("UCI HAR Dataset/train//y_train.txt")
#combine
act<-rbind(act_test,act_train)

#add activity to dataframe 
full.mean.std<-cbind(act,full.mean.std)
#rename variable
names(full.mean.std)[1]<-"Activity"

#STEP3
#read activity labels
act_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
#convert to factor variable with appropriate labels
full.mean.std$Activity<-factor(full.mean.std$Activity,levels=act_labels$V1,labels=act_labels$V2)

#read and combine subjects
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
subject<-rbind(subject_test,subject_train)

#add subjects
full.mean.std<-cbind(subject,full.mean.std)
names(full.mean.std)[1]<-"subject"

#compute mean for each variable by groups defined by subject and Activity and store the result in a new data frame
df_mean <- as.data.frame(group_by(full.mean.std, subject, Activity) %>% summarise_each(funs(mean)))

#write tidy data to txt file
write.table(df_mean,file="tidy.txt",row.names=FALSE)

# output tidy data
print(df_mean)