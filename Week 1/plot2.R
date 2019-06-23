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

out_file <- "plot2.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Plot the data

plot(ymd_hms(paste(power_data$Date, power_data$Time)), power_data$Global_active_power, type='l',xlab="", 
     ylab = "Global Active Power (kilowatts)")

# Close the file
dev.off()



