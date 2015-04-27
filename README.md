# Summarized and Tidied Data based on Human Activity Recognition Using Smartphones Dataset

The Human Activity Recognition Using Smartphones Dataset Version 1.0 [1] provided by:

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The Raw data was transformed to create a single data set in "wide form" that is consistent with the principles of Tidy data see [Hadley Wickham] (http://vita.had.co.nz/papers/tidy-data.pdf) 

Principles of Tidy data:
- Each variable you measure should be in one column
- Each different observation of that variable should be in a different row
- There should be one table for each "kind" of variable
- If you have multiple tables,they should include a column in the table that allows them to be linked

## Files

`run_analysis.R` 
- is the R Script (Recipe) for transforming the raw data into the summarised tidy data set. It reads the data from multiple files: `subject_test.txt`, `X_test.txt` and `y_test.txt`; `subject_train.txt`, `X_train.txt` and `Y_train.txt`. The data was labelled using the lableling information from `activity_labels.txt` and `features.txt` and then subsetted to use only mean() and std() features for summarization.

`SubjectActivityMeans.txt`
- is the summarized tidy data set with the Average values per Subject per Activity for the mean() and std() features.

To read in the tidy data set use `data <- read.table(file_path, header = TRUE)`

`codebook.md`
- modified code book to describe the summarized data as well as the raw data since both are inextricably linked.

### Reference

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

David Hood, `https://class.coursera.org/getdata-013/forum/thread?thread_id=31`
