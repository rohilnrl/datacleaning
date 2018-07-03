# Loading packages. Require is used so that packages may install
# if not already installed.

require("data.table", quietly = TRUE)
require("reshape2", quietly = TRUE)
require("dplyr", quietly = TRUE)

# Function definitions

grepreg <- function(regex) {
  grepl(regex, dataset$feature)
}

# Set the path to the dataset folder.
path = file.path(getwd(), "UCI HAR Dataset")

# Load the activity sets.
activity_train <- fread(file.path(path, "train", "Y_train.txt"))
activity_test <- fread(file.path(path, "test", "Y_test.txt"))

# Load label training and test sets.
y_train <- fread(file.path(path, "train", "Y_train.txt"))
y_test <- fread(file.path(path, "test", "Y_test.txt"))

# Load subject files.
subject_train <- fread(file.path(path, "train", "subject_train.txt"))
subject_test <- fread(file.path(path, "test", "subject_test.txt"))

# Load the training and test feature set.
X_train <- data.table(read.table(file.path(path, "train", "X_train.txt")))
X_test <- data.table(read.table(file.path(path, "test", "X_test.txt")))

# Merging the training and test sets. It is important to note
# that there are no cross-validation tests to merge.
subject <- rbind(subject_train, subject_test)
activity <- rbind(activity_train, activity_test)
X <- rbind(X_train, X_test)

# Cleaning data names to something more meaningful
setnames(subject, "V1", "subject_id")
setnames(activity, "V1", "activity_id")

# Merging feature set and label set.
subject_set <- cbind(subject, activity)
dataset <- cbind(subject_set, X)
setkey(dataset, subject_id, activity_id)

# Setting dataset as a dplyr table.
dataset <- tbl_df(dataset)

# Reading features.txt to extract the mean features and
# std features
features <- tbl_df(fread(file.path(path, "features.txt")))
setnames(features, names(features), c("variable", "feature"))

# Subset features to only extract mean features
features <- features[grepl("mean|std", features$feature), ]
features <- mutate(features, variable = paste("V", variable, sep = ""))
dataset <- select(dataset, c(key(dataset), features$variable))

# Adding meaninful names to activities as specified in 
# activity_labels.txt
activity_labels <- fread(file.path(path, "activity_labels.txt"))
activity_labels$V2 <- tolower(activity_labels$V2)
setnames(activity_labels, names(activity_labels), c("activity_id", "activity"))
dataset <- merge(dataset, activity_labels, by = "activity_id", all.x = TRUE)
dataset <- tbl_df(dataset)
dataset <- select(dataset, activity_id, subject_id, activity, V1:V552)

# Labelling dataset with descriptive names
feature_names <- gsub("\\(", "", features$feature)
feature_names <- gsub("\\)", "", feature_names)
feature_names <- gsub("-", "_", feature_names)
dataset <- select(dataset, -activity_id)
setnames(dataset, names(dataset[3:length(dataset)]), feature_names)

# Melting dataset
dataset <- data.table(dataset)
setkey(dataset, subject_id, activity)
dataset <- data.table(melt(dataset, key(dataset), variable.name = "featureCode"))

# Factoring activity and feature names
dataset$activity <- factor(dataset$activity)
dataset$feature <- factor(dataset$featureCode)

y <- matrix(seq(1, 2), nrow = 2)
x <- matrix(c(grepreg("^t"), grepreg("^f")), ncol = nrow(y))
dataset$domain <- factor(x %*% y, labels = c("time", "frequency"))
x <- matrix(c(grepreg("Acc"), grepreg("Gyro")), ncol = nrow(y))
dataset$instrument <- factor(x %*% y, labels = c("accelerometer", "gyroscope"))
x <- matrix(c(grepreg("BodyAcc"), grepreg("GravityAcc")), ncol = nrow(y))
dataset$acceleration <- factor(x %*% y, labels = c(NA, "body", "gravity"))
x <- matrix(c(grepreg("mean()"), grepreg("std()")), ncol = nrow(y))
dataset$variable <- factor(x %*% y, labels = c("mean", "standard deviation"))

dataset$jerk <- factor(grepreg("Jerk"), labels = c(NA, "jerk"))
dataset$magnitude <- factor(grepreg("Mag"), labels = c(NA, "magnitude"))


y <- matrix(seq(1, 3), nrow = 3)
x <- matrix(c(grepreg("X"), grepreg("Y"), grepreg("Z")), ncol = nrow(y))
dataset$axis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))

# Final processing
dataset <- tbl_df(dataset)
dataset <- select(dataset, subject_id, activity, domain:axis, value)

# Creating tidy dataset with average values
tidy_data <- group_by(dataset, subject_id, activity, domain, acceleration, instrument, jerk, magnitude, variable, axis)
tidy_data <- summarise(tidy_data, average = mean(value))

if (file.exists("tidydata.txt")) {
  file.remove("tidydata.txt")
}

write.table(tidy_data, file = "tidydata.txt", row.names = FALSE)