# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999-2008?
# Install packages
library(data.table)
library(dplyr)
# Set the directory path
setwd("E:\\Coursera\\Exploratory Data Analysis\\Week-4\\data\\")
dir("../data")
#
if(file.exists("summarySCC_PM25.rds")){
## Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Dimension and Summary of data
dim(NEI)
head(NEI)
dim(SCC)
head(SCC)
summary(NEI)
#Collect Caol cumbustion sources from SCC
SCC$SCC <- SCC$SCC
coals <- grep("Coal$", SCC$EI.Sector)
SCC_Coal <- data.frame(SCC[coals,1])
names(SCC_Coal) <- "SCC"
SCC_Coal$SCC <- as.character(SCC_Coal$SCC)
#Join NEI ans SCC_Coal
NEI_Coal <- inner_join(SCC_Coal, NEI, by = "SCC")
#Convert year in NEI to factor variable
NEI_Coal$year <- as.factor(NEI_Coal$year)
NEI_Coal$Emissions <- NEI_Coal$Emissions
yeartotal <- aggregate(Emissions ~ year, NEI_Coal, sum)
yeartotal$Emissions <- yeartotal$Emissions/1000
## open the default screen device on this platform if no device is open
if(dev.cur() == 1) dev.new()
plot(yeartotal$year, yeartotal$Emissions, xlab="Year", ylab="PM2.5 in Kilotons")
title(main = "Total PM2.5 Emission from Coal Cumbustion sources in US")
# copy the plot4 to png device
dev.copy(png, file = "plot4.png")
# close the device
dev.off()
gc(verbose = TRUE)
} else {
  print(" Dta files are not found. Unzip the file into data dir and rerun this")
}

