#Plot 4 - PM2.5 Emission from coal combustion in US over the years

#  ***********************  QUESTION ***************************

#Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

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
unique(NEI$type)
head(NEI[NEI$fips == 24510,])
dim(NEI[NEI$SCC %in% SCC_Comb_Coal_CD,])


str(SCC)
head(SCC,30)
tail(SCC, 30)
dim(SCC)


# Get the Source code for all combustion 
SCC_Comb <- SCC[grepl("Combustion",SCC$SCC.Level.One, ignore.case = TRUE),]

head(SCC_Comb)

dim(SCC_Comb)

# Get the Source code for all combustions using coal
SCC_Comb_Coal <- SCC_Comb[grepl("Coal", SCC_Comb$SCC.Level.Three, ignore.case = TRUE),]

tail(SCC_Comb_Coal)

dim(SCC_Comb_Coal)

SCC_Comb_Coal_CD <- SCC_Comb_Coal$SCC

# Calculate the total emissions for the year from all coal related combustion
library(dplyr)

Emissions_CoalComb <-  NEI %>% select(Emissions, year, fips, type,SCC) %>% filter(SCC %in% SCC_Comb_Coal_CD) %>% 
  group_by(year) %>% summarise(total_emissions = sum(Emissions))

Emissions_CoalComb

# Validation- check the total emission in the original DFa dn in the summarized DF
original_sum = sum(NEI[NEI$SCC %in% SCC_Comb_Coal_CD,"Emissions"])
new_sum = sum(Emissions_CoalComb$total_emissions)

if (all.equal(original_sum,new_sum)) {print("Validation passed") } else {print("Validation Failed, please check the Groupby logic")}

# ***********************SAVE THE PLOT TO PNG FILE *****************************
out_file <- "plot4.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Make a plot to show the trend of emissions from coal combustion
with(Emissions_CoalComb, plot(year, total_emissions, type='b' ,col="red",pch =17, cex=2, lwd=2,
    main="PM2.5 Emission from Coal Combustion in US over the Years", xlab="Year", ylab="Total Emission from Coal Combustion"))
abline(h=seq(350000,550000,50000) , col="grey", lwd=0.1)

# Close the file
dev.off()

