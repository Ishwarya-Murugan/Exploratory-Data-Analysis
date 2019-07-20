#Plot 1 - PM2.5 emission in US over the years

#  ***********************  QUESTION ***************************

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years
# 1999, 2002, 2005, and 2008.

# ************************ GETTING THE DATA ********************

# Set the current working directory
setwd("C:\\Users\\Ishwa\\Desktop\\DataScience\\R\\Exploratory Data Analysis\\Week 4")
path <- getwd()
path


# Get the file from the url
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
file.name <- "FNEI_data.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, file.name))

# Unzip the file
unzip(file.name,exdir=path)

# Delete the zip file to free up the space
if (file.exists(file.name)){file.remove(file.name)}

# Read the data input files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# ********************** EXPLORE & CLEAN THE DATA *****************************

# Explore the strucure of input data 
#str(NEI)
#unique(NEI$year)
#unique(NEI$SCC)
#unique(NEI$Pollutant)
#unique(NEI$SCC)
#unique(NEI$Emissions)
#unique(NEI$type)

str(SCC)
head(SCC)

# Calculate the total emissions for the year from all the sources
library(dplyr)

Emissions_by_year <-  NEI %>% select(Emissions, year) %>% group_by(year) %>% summarise(total_emissions = sum(Emissions))

Emissions_by_year

# ***********************SAVE THE PLOT TO PNG FILE *****************************

out_file <- "plot1.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008

with (Emissions_by_year, plot(year, total_emissions,  xaxt = "n",
                              type = "b", pch=19, col = 'Blue', cex=2,
                              main="PM2.5 Emission over the Years",
                              xlab="Year", ylab = "Total EMission from all Sources"))

axis(1, c(1999, 2002, 2005, 2008, 2011))

text(Emissions_by_year$year+0.1, Emissions_by_year$total_emissions-200000, 
     round(Emissions_by_year$total_emissions,0), cex=0.8)


# Close the file
dev.off()
