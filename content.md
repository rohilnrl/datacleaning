# Tidying of Human Activity Recognition Using Smartphones Data Set
### Download: [Data Folder](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/), [Data Set Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Dataset Attributes
 |Attribute|Value|
 |---|---|
 |Data Set Characteristics|Multivariate, Time-Series|
 |Attribute Characteristics|NA|
 |Associated Tasks|Classification, Clustering|
 |Number of Instances|10299|
 |Number of Attributes|561|
 |Date Cleaned|3rd July, 2018|

### Description
This dataset was taken from the UCI Machine Learning repository and cleaned in preparation for statistical analysis. The details of the pre-processing are given below. The download links and link to the repository are given above.


## Feature attributes
|Feature|Description|
|---|---|
|activity|Indicates the activity label being performed by the user|
|subject_id|Unique identification ID of the user performing the action|
|domain|Domain of the function (time, frequency) before FFT
|instrument|Instrument used (accelerometer, gyroscope etc.)|
|acceleration|Acceleration signal given (body, gravity etc.)|
|variable|Mean or standard deviation calculated|
|jerk|Jerk signal or no jerk signal|
|magnitude|Magnitude of the signals calculated|
|axis|X, Y or Z axis specified|
|average|Mean value of all data given the above features


### Note
 * t: Time domain signal features.
 * f: Frequency domain signal features.
 
 Refer to the domain before or after the application of a fast Fouryyyier transform.w

## Pre-processing (tidying) procedure

* Dataset files `X_train.txt`, `X_test.txt`, `Y_train.txt`, `Y_test.txt`, `features.txt` and `activity_labels.txt` were loaded into R.
* Required libraries such as `reshape2`, `data.table` and `dplyr` were loaded into R.
* The train and test sets were merged for all datasets.
* The features and labels were merged along with their subject and activity labels denoted in `subject_train.txt` and `subject_text.txt`.
* The subject and activity columns in the merged dataset were given the names `subject` and `activity`.
* Features were read from `features.txt` and features containing `mean` and `std` were extracted.
* All the feature labels in the dataset were named according to the feature code (for example: feature `V62` was renamed to `tBodyGyro_mean_X`).
* Activity labels were extracted and activity numbers in the dataset were replace by their labels (for example: if the activity column contained `1`, now it would contain `walking`). 
* Dataset was melted using `subject_id` and `activity` as keys. This was done because each variable needed to be separated into a feature. For example: `tBodyGyro_mean_X` has several features in it (domain, variable, axis etc.).
* Columns were added to this melted dataset which represented the features as described above in the "Feature attributes" table (`domain`, `axis` etc.).
* Dataset was then grouped by its keys and variables.
* Average values were calculated according to the grouping.

 
## Sample 

> "subject_id" "activity" "domain" "acceleration" "instrument" "jerk" "magnitude" "variable" "axis" "average"
1 "laying" "time" "NA" "gyroscope" "NA" "NA" "mean" "X" -0.016553093978
1 "laying" "time" "NA" "gyroscope" "NA" "NA" "mean" "Y" -0.064486124088
1 "laying" "time" "NA" "gyroscope" "NA" "NA" "mean" "Z" 0.14868943626
1 "laying" "time" "NA" "gyroscope" "NA" "NA" "standard deviation" "X" -0.87354386782
1 "laying" "time" "NA" "gyroscope" "NA" "NA" "standard deviation" "Y" -0.9510904402
1 "laying" "time" "NA" "gyroscope" "NA" "NA" "standard deviation" "Z" -0.9082846626
1 "laying" "time" "NA" "gyroscope" "NA" "magnitude" "mean" "NA" -0.874759548
1 "laying" "time" "NA" "gyroscope" "NA" "magnitude" "standard deviation" "NA" -0.81901016976

