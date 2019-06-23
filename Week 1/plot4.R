# ************************ GETTING THE DATA ********************

# Set the current working directory
setwd("C:\\Users\\Ishwa\\Desktop\\DataScience\\R\\Exploratory Data Analysis\\Week 1")
path <- getwd()
path

# Get the file from the url
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file.name <- "Electric Power Consumption.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, file.name))

# Unzip the file
unzip(f,exdir=path)

# Delete the zip file to free up the space
if (file.exists(file.name)){file.remove(file.name)}


#*********************** LOAD THE NEEDED PACKAGES ******************

library(lubridate)


# *********************** LOAD & CLEAN THE DATA *******************************

# Get the index for 1st and 2nd of February 2007 data to use in the skip and nrow
line_no <- grep("^(1/2/2007)|^(2/2/2007)", readLines("household_power_consumption.txt"))

#View(grep("^(1/2/2007)|^(2/2/2007)", readLines("household_power_consumption.txt"), value = TRUE))


# Read only the first line to get the header details
header <- read.table("household_power_consumption.txt",nrows=1, sep=';', header=TRUE)

# Load the data only for 1st and 2nd of February 2007
power_data <- read.table("household_power_consumption.txt", sep=";", na.strings= "?",
                         skip=line_no[1]-1,nrows=length(line_no), stringsAsFactors = FALSE, 
                         header=FALSE)

# Apply the header values
colnames(power_data) <- colnames(header)

# Convert "Date" column from string value to POSIXlt
power_data$Date <- strptime(power_data$Date, "%d/%m/%Y")


# ***********************SAVE THE PLOT TO PNG FILE *****************************

out_file <- "plot4.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Set the global parameter for multi-graphs

par(mfcol=c(2,2))

#par(mfcol=c(1,1))

# Plot- 1 - Line graph of datetime vs global active power
plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Global_active_power, type='l',xlab="", 
     ylab = "Global Active Power")

# Plot - 2 -  the line graphs for sub_metering and the legends
plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Sub_metering_1, type='l',xlab="", 
     ylab = "Energy sub metering")
points(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Sub_metering_2, type='l',xlab="", 
       ylab = "Energy sub metering",col='red')
points(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Sub_metering_3, type='l',xlab="", 
       ylab = "Energy sub metering",col='blue')
legend("topright", lty = 1, legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black","red","blue"), bty="n" )

# Plot- 3 - Line graph of datetime vs voltage
plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Voltage, type='l',xlab="datetime", 
     ylab = "Voltage")

# Plot- 4 - Line graph of datetime vs global reactive power
plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Global_reactive_power, type='l',xlab="datetime", 
     ylab = "Global_reactive_power", yaxp=c(0.0,0.5, 5))
# Close the file
dev.off()



