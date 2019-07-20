#Plot 3 - PM2.5 Total Emissions in Baltimore City from different sources

#  ***********************  QUESTION ***************************

#Of the four types of sources indicated by the \color{red}{\verb|type|}type (point, nonpoint, onroad, nonroad) 
#variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which 
#have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

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

# Calculate the total emissions for the year from different the sources for Baltimore City

library(dplyr)

Emissions_Baltimore <-  NEI %>% select(Emissions, year, fips, type) %>% filter(fips==24510) %>% 
  group_by(year, type) %>% summarise(total_emissions = sum(Emissions))

Emissions_Baltimore

# Validation- check the total emission for Baltimore in the original DFa dn in the summarized DF

original_sum = sum(NEI[NEI$fips == 24510,"Emissions"])

new_sum = sum(Emissions_Baltimore$total_emissions)

if (original_sum==new_sum) {print("Validation passed") } else {print("Validation Failed, please check the Groupby logic")}

# ***********************SAVE THE PLOT TO PNG FILE *****************************
library(ggplot2)

out_file <- "plot3.png"

# Delete the output file if already exists
if (file.exists(out_file)){file.remove(out_file)}

# Save as .png file
png(out_file, width=480, height = 480)

# Make a plot to compare emission from different sources over the years in Baltimore


#qplot(year,total_emissions, col=type, data=Emissions_Baltimore)

#qplot(year, total_emissions, data= Emissions_Baltimore, facets = .~type)

ggplot()+geom_line(aes(x=year, y=total_emissions, colour=type),
         size=1.5,data=Emissions_Baltimore, stat='identity')+
         theme_classic()+scale_color_brewer(palette="Dark2")+
         theme(legend.position="top", legend.direction="horizontal",legend.title = element_text(face="bold"))+
         labs(colour= 'Emission Sources', x="Year", y= "Emission from the Source",
         title="Emissions from Different Sources in Baltimore over the Years ")+
         theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16, hjust = 0.5))


# Close the file
dev.off()
