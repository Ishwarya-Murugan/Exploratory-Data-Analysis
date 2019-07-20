#Plot 2 - PM2.5 Total Emissions in Baltimore City

#  ***********************  QUESTION ***************************

#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#(\color{red}{\verb|fips == "24510"|}fips=="24510") from 1999 to 2008? Use the base plotting system to make a plot 
#answering this question.

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
head(SCC)

# Calculate the total emissions for the year from all the sources for Baltimore City

library(dplyr)
Emissions_Baltimore <-  NEI %>% select(Emissions, year, fips) %>% filter(fips==24510) %>% 
  group_by(year) %>% summarise(total_emissions = sum(Emissions))

Emissions_Baltimore

# Validation- check the total emission for Baltimore in the original DFa dn in the summarized DF

original_sum = sum(NEI[NEI$fips == 24510,"Emissions"])

new_sum = sum(Emissions_Baltimore$total_emissions)

if (original_sum==new_sum) {print("Validation passed") } else {print("Validation Failed, please check the Groupby logic")}

# ***********************SAVE THE PLOT TO PNG FILE *****************************

out_file <- "plot2.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008

with (Emissions_Baltimore, plot(year, total_emissions,  xaxt = "n",
                              type = "b", pch=19, col = 'Blue', cex=2,
                              main="PM2.5 Emission over the Years in Baltimore, MD",
                              xlab="Year", ylab = "Total EMission from all Sources"))
axis(1, c(1999, 2002, 2005, 2008, 2011))

text(Emissions_Baltimore$year, Emissions_Baltimore$total_emissions, 
     round(Emissions_Baltimore$total_emissions,0), cex=0.8, pos=2)

# Close the file
dev.off()
