


# Loading the data

setwd("C:\\Users\\Ishwa\\Desktop\\DataScience\\R\\Exploratory Data Analysis\\Week 1")
path <- getwd()
path


url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file.name <- "Electric Power Consumption.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, file.name))


unzip(f,exdir=path)


# executable <- file.path("C:", "Program Files (x86)", "7-Zip", "7z.exe")
# parameters <- "x"
# cmd <- paste(paste0("\"", executable, "\""), parameters, paste0("\"", file.path(path, f), "\""))
# system(cmd)
# pathIn <- file.path(path, "UCI HAR Dataset")
# list.files(pathIn, recursive=TRUE)


# Delete the zip file to free up the space
if (file.exists(file.name)){ 
  #Delete file if it exists
  file.remove(file.name)}

library(sqldf)


line_no <- grep("^(1/2/2007)|^(2/2/2007)", readLines("household_power_consumption.txt"))

View(grep("^(1/2/2007)|^(2/2/2007)", readLines("household_power_consumption.txt"), value = TRUE))


header <- read.table("household_power_consumption.txt",nrows=1, sep=';', header=TRUE)

power_data <- read.table("household_power_consumption.txt", sep=";", na.strings= "?",
           skip=line_no[1]-1,nrows=length(line_no), stringsAsFactors = FALSE, 
           header=FALSE)
colnames(power_data) <- colnames(header)

str(power_data)
head(power_data)
tail(power_data)

View(power_data)

library(lubridate)

power_data$Date <- as.Date(power_data$Date, format="%d/%m/%Y")

power_data$Date <- strptime(power_data$Date, "%d/%m/%Y")

power_data$Time <- strftime(strptime(power_data$Time, format="%H:%M:%S", tz=""))

#power_data$Time <- hms(power_data$Time)

class(power_data$Date)

class(power_data$Time)


hist(power_data$Global_active_power, xlab="Global Active Power (kilowatts)",
     ylab= "Frequency", main="Global Active Power", xaxp=c(0,6,3), ylim=c(0,1200),col=2)

plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Global_active_power, type='l',xlab="", 
     ylab = "Global Active Power (kilowatts)")


?plot

weekdays(as.Date(power_data$Date,'%Y-%m-%d'))


library(lubridate)


plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Sub_metering_1, type='l',xlab="", 
     ylab = "Energy sub metering")
points(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Sub_metering_2, type='l',xlab="", 
       ylab = "Energy sub metering",col='red')
points(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Sub_metering_3, type='l',xlab="", 
     ylab = "Energy sub metering",col='blue')
leg <- legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),plot=FALSE)


leg
# adjust as desired
leftx <- leg$rect$left
rightx <- (leg$rect$left + leg$rect$w) 
topy <- leg$rect$top - 0.5
bottomy <- (leg$rect$top - leg$rect$h) +0.5


# use the new coordinates to define custom
legend(x = c(leftx, rightx), y = c(topy, bottomy), lty = 1,
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black","red","blue"),box.lty=0 )


?legend

par(mfcol = c(2,2))


plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Voltage, type='l',xlab="datetime", 
     ylab = "Voltage")

plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Global_reactive_power, type='l',xlab="datetime", 
     ylab = "Global_reactive_power", yaxp=c(0.0,0.5, 5))






