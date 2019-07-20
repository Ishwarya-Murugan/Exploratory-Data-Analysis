#Plot 6 - Comparison of PM2.5 MV related Emissions in BC and LA

#  ***********************  QUESTION ***************************

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in 
# Los Angeles County, California (\color{red}{\verb|fips == "06037"|}fips=="06037"). Which city has seen 
# greater changes over time in motor vehicle emissions?

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

Emissions_MV_BC <-  NEI %>% select(Emissions, year, fips,  SCC) %>% filter(fips==24510 & SCC %in% SCC_Motor_Vehi_CD) %>% 
  group_by(year) %>% summarise(total_emissions = sum(Emissions))

Emissions_MV_BC


BC_rate_of_change <- 100*diff(Emissions_MV_BC$total_emissions)/Emissions_MV_BC[-nrow(Emissions_MV_BC),]$total_emissions

BC_rate_of_change


# Calculate the total emissions for the year from motor vehicles related sources for Los Angeles City


Emissions_MV_LA <-  NEI %>% select(Emissions, year, fips,  SCC) %>% filter(fips=='06037'& SCC %in% SCC_Motor_Vehi_CD) %>% 
  group_by(year) %>% summarise(total_emissions = sum(Emissions))

Emissions_MV_LA

LA_rate_of_change <- 100*diff(Emissions_MV_LA$total_emissions)/Emissions_MV_LA[-nrow(Emissions_MV_LA),]$total_emissions


LA_rate_of_change

# Create a summary table showing the rate of change in emission over the invtervals of year

year_interval <- cut(Emissions_MV_BC$year, breaks=3)

levels(year_interval)

Rate_Change_Summary <- data.frame("Year_Interval" = levels(year_interval), "ROC_BC"=BC_rate_of_change, "ROC_LA"= LA_rate_of_change)

Rate_Change_Summary

# ***********************SAVE THE PLOT TO PNG FILE *****************************

out_file <- "plot6.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Make a plot to compare rate of change in emission in BC and LA from motor vehicles related sources 

barplot('colnames<-'(t(Rate_Change_Summary[-1]), Rate_Change_Summary[,1]), beside=TRUE, 
        legend.text = TRUE, col = c("blue", "cyan"), 
        args.legend = list(x = "bottom", bty = "n", legend=c("ROC in Baltimore", "ROC in Los Angeles")),
        main="Rate of Change in MV related emissions in BC vs LA", xlab="Year Intervals", ylab="Rate of Cahnge in Motor Vehicle Related Emission")


# Close the file
dev.off()

