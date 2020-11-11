---
author: Kat Parisis
date: 11/10/20
title: "Thorne Descriptive Stats"
---

  
## Step 1: 1a. We need to load in the master dataframe output that we got from SQL.
## Assign 'df' as the alias to make referring the data easier in later steps.
  df <- read.csv("Desktop/AAO/thorne_final.csv")
 #1b. Check to see which dirctory we are working in
  getwd()

##Step 2: Do some exploratory analysis of df 
##Take a peek at df using the head and tail functions 
##lets see a small part of the data
head(df)
tail(df)
##Check the internal structure of the data frame
str(df)
##Check out how many missing values we have 
sum(is.na(df))
##Check out where these missing values are - they exist in the #_month_va_eye and #_month_va columns 
##Not all eyes have va values post surgery 
sapply(df, function(x) sum(is.na(x)))
##View dimensions of df
dim(df)

## Step 3: Continuous Variable - Age at Index Date
## Get age_at_index column from df give it the alias index_age 
#if any, exclude "negative" ages that are invalid and missing values  
## "$" references the variable of interest in our data
```{r}
index_age <- df$age_at_index[df$age_at_index >= 0 & !is.na(df$age_at_index)] 
```
## Check to see if we have any missing values - there are none 
```{r}
sum(is.na(index_age))
```
## Find summary statistics of cohort's index ages
```{r}
sum_age <- summary(index_age)
sum_age
```
## Find standard deviation of cohort's index ages 
```{r}
sd_age <- sd(index_age)
sd_age
```
## Create a visual to see distribution of ages 
```{r}
hist(index_age, xaxp=c(0,90,12))
```

## Step 3: Counts of Race 
```{r}
t1 <- table(distinct_df$race_final)
t1
```
## Step 4: Counts of gender
```{r}
t2 <-table(distinct_df$gender)
t2
```
## Step 5: Counts of smoking status
```{r}
t3 <-table(distinct_df$smoke_status)
t3
```
## Step 6: Counts of insurance status
```{r}
t4 <-table(distinct_df$insurance_new)
t4
```
## Step 7: Counts of practice region
```{r}
t5 <-table(distinct_df$practice_region)
t5
```
## Step 8: Counts of eyes
```{r}
t6 <-table(distinct_df$uveitis_eye)
t6
```
## Step 9: Counts of patients 
```{r}
t7 <-table(distinct_df$patient_guid)
t7
```
## Step 10: Summary stats for one month VA
## Remove the missing values 
```{r}
one_month <- df$one_month_va[!is.na(df$one_month_va)]
sum1 <-summary(one_month)
sum1
sd1 <-sd(one_month)
sd1 
```
## Step 11: Find summary statistics and standard deviation of cohort's three month va values
## Remove any missing values 
```{r}
three_month <- df$three_month_va[!is.na(df$three_month_va)]
sum3 <- summary(three_month)
sum3 
sd3 <- sd(three_month)
sd3
```
## Step 12: Counts of patients with 20/40 vision or better at one month post cataract surgery 
## nrow counts the number of rows that have a VA of <= 0.3
```{r}
nrow1 <- nrow(df[df$one_month <= 0.3, ]) #check to one_month_va patient count in SQL
nrow1 
```
## Step 13: Counts of patients with 20/40 vision or better at three month post cataract surgery 
## nrow counts the number of rows that have a VA of <= 0.3
```{r}
nrow3 <- nrow(df[df$three_month <= 0.3, ]) #check to three_month_va patient count in SQL
nrow3 
```

## Step 14: Export tables into CSVs
write.table(sum_age, file = "thorne1.csv", sep = ",")
write.table(sd_age, file = "thorne1.csv", sep = ",")
write.table(t1, file = "thorne1.csv", sep = ",")
write.table(t2, file = "thorne1.csv", sep = ",")
write.table(t3, file = "thorne1.csv", sep = ",")
write.table(t4, file = "thorne1.csv", sep = ",")
write.table(t5, file = "thorne1.csv", sep = ",")
write.table(t6, file = "thorne1.csv", sep = ",")
write.table(t7, file = "thorne1.csv", sep = ",")
write.table(sum1, file = "thorne1.csv", sep = ",")
write.table(sd1, file = "thorne1.csv", sep = ",")
write.table(sum3, file = "thorne1.csv", sep = ",")
write.table(sd3, file = "thorne1.csv", sep = ",")
write.table(nrow1, file = "thorne1.csv", sep = ",")
write.table(nrow3, file = "thorne1.csv", sep = ",")
