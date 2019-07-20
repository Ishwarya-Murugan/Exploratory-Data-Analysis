#Plot 5 - PM2.5 Total Emissions in Baltimore City from Motor Vehicle Sources

#  ***********************  QUESTION ***************************

# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

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
unique(NEI$Pollutant)
unique(NEI$SCC)
unique(NEI$Emissions)
unique(NEI$type)
head(NEI[NEI$fips == 24510,])


str(SCC)
head(SCC,30)
unique(SCC$SCC.Level.One)
unique(SCC$SCC.Level.Two)
unique(SCC$SCC.Level.Three)
unique(SCC$SCC.Level.Four)
tail(SCC, 30)
dim(SCC)


# Get the Source code for all motor vehicle related emissions
SCC_Motor_Vehi <- SCC[grepl("Vehicle",SCC$Short.Name, ignore.case = TRUE),]

head(SCC_Motor_Vehi)

tail(SCC_Motor_Vehi)

dim(SCC_Motor_Vehi)

SCC_Motor_Vehi_CD <- SCC_Motor_Vehi$SCC

SCC_Motor_Vehi_CD

# Calculate the total emissions for the year from motor vehicles related sources for Baltimore City

library(dplyr)

Emissions_MV_Balti <-  NEI %>% select(Emissions, year, fips,  SCC) %>% filter(fips==24510 & SCC %in% SCC_Motor_Vehi_CD) %>% 
  group_by(year) %>% summarise(total_emissions = sum(Emissions))

Emissions_MV_Balti

# ***********************SAVE THE PLOT TO PNG FILE *****************************

out_file <- "plot5.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Make a plot to compare emission from different sources over the years in Baltimore

with(Emissions_MV_Balti, plot(year, total_emissions, type='b' ,col="violet",pch =19, cex=2, lwd=2,
                              main="Motor Vehicle Related Emissions in Baltimore", xlab="Year", ylab="Motor Vehicle Related Emission"))
grid (lty = 6, col = "cornsilk2")


# Close the file
dev.off()
