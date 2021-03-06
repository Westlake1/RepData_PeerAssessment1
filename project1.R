## My R program script for the Reproducible Research course
## Course Project 1, August, 2015


# --- set the working directory
setwd("c:/Users/Owner/ReproducibleResearch1/RepData_PeerAssessment1")

# --- get the working directory to verify it is set correctly
getwd()

# --- unzip the file
unzip("c:/Users/Owner/ReproducibleResearch1/RepData_PeerAssessment1/activity.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, unzip = "internal", setTimes = FALSE)

# --- read the file into R
data = read.table("c:/Users/Owner/ReproducibleResearch1/RepData_PeerAssessment1/activity.csv", header=TRUE, sep = ',')

## -------------------------------------------------
## What is mean total number of steps taken per day?
## -------------------------------------------------
# sum the steps by date
data1.sum <- aggregate(x = data[c("steps")],
                     FUN = sum,
                     by = list(Group.date = data$date))

# create histogram of the total number of steps taken each day
hist(as.numeric(data1.sum$steps), 
     main = "Total Number of Steps Taken Each Day", 
     col = "Red")

# --- copy the plot to a PNG file
dev.copy(device = png, filename = 'plot1.png', width = 480, height = 480)
# --- close the PNG device
dev.off()

# Calculate and report the mean of the total number of steps taken per day
m <- mean(data1.sum$steps, na.rm = TRUE)
m

# Calculate and report the median of the total number of steps taken per day
median(data1.sum$steps, na.rm = TRUE)


## -------------------------------------------
## What is the average daily activity pattern?
## -------------------------------------------
# --- summarize the data -- calc the mean steps by interval to data frame mi
mi = aggregate(data$steps, list(data$interval), na.rm = TRUE, mean)

# --- plot the data
plot(mi$Group.1, mi$x, type ='l',   main = "Average Daily Activity Pattern", col="Red", 
     xlab = "5-minute intervals", ylab = "avg number of steps averaged across all days")

# --- copy the plot to a PNG file
dev.copy(device = png, filename = 'plot2.png', width = 480, height = 480)
# --- close the PNG device
dev.off()

# get the largest value of avg number of steps in intervals
mx <- max(mi$x, na.rm = TRUE)
mx
#get the row number of this largest number
r <- which(mi$x == mx)
# get the time interval in the row with the largest number (format is -hmm)
mi[r,1]


## -----------------------
## Imputing missing values
## -----------------------

# calculate the total number of missing values in the dataset
sum(is.na(data$steps))

data2 <- as.data.frame(data) # copy the dataset to data2
# data2[is.na(data2)] <- 0  # replace na with 0
data2[, 1][is.na(data2[, 1])] <- m/288 # replace na with daily mean / 288 intervals

data2.sum <- aggregate(x = data2[c("steps")],
                       FUN = sum,
                       by = list(Group.date = data2$date))

# create histogram of the total number of steps taken each day
hist(as.numeric(data2.sum$steps), 
     main = "Total Number of Steps Taken Each Day", 
     col = "Red")

# --- copy the plot to a PNG file
dev.copy(device = png, filename = 'plot3.png', width = 480, height = 480)
# --- close the PNG device
dev.off()

# Calculate and report the mean of the total number of steps taken per day
mean(data2.sum$steps)   #, na.rm = TRUE)

# Calculate and report the median of the total number of steps taken per day
median(data2.sum$steps) #, na.rm = TRUE)


#--------------------------------------------------------------------------
# Are there differences in activity patterns between weekdays and weekends?
#--------------------------------------------------------------------------
my.date <- as.Date(data2$date) # convert date to date format

data2$day <- weekdays(my.date <- as.Date(data2$date)) # add column with the day of the week

data2$dayType <- as.character("weekday") # add column for type of day and prefill with "weekday"

data2$dayType[data2$day == "Saturday"] <- "weekend"  # change to weekend
data2$dayType[data2$day == "Sunday"] <- "weekend"

data2Weekday <- data2[data2$dayType  ==  "weekday", ] # extract weekday data
data2Weekend <- data2[data2$dayType  ==  "weekend", ] # extract weekend data

# --- summarize the weekday data -- calc the mean of steps by interval to data frame wd
wd = aggregate(data2Weekday$steps, list(data2Weekday$interval), na.rm = TRUE, mean)

# --- summarize the weekday data -- calc the mean of steps by interval to data frame wd
we = aggregate(data2Weekend$steps, list(data2Weekend$interval), na.rm = TRUE, mean)

par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
plot(we$Group.1, we$x, type ='l',   main = "Weekends", col="Red", 
     ylab = "number of steps")
plot(wd$Group.1, wd$x, type ='l',   main = "Weekdays", col="Red", 
     xlab = "5-minute intervals", ylab = "number of steps")

# --- copy the plot to a PNG file
dev.copy(device = png, filename = 'plot4.png', width = 480, height = 480)
# --- close the PNG device
dev.off()

# --- end of my script -- 08-12-2015 -- jc Westlake1 ---