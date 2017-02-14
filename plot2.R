# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.
# Install packages
library(data.table)
library(dplyr)
# Set the directory path
setwd("E:\\Coursera\\Exploratory Data Analysis\\Week-4\\data\\")
dir("../data")
if(file.exists("summarySCC_PM25.rds")){
## Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Dimension and Summary of data
dim(NEI)
dim(SCC)
summary(NEI)
#Convert year in NEI to factor variable and select data from Baltimore city
NEI$year <- as.factor(NEI$year)
NEI_Baltimore <- subset(NEI, fips == "24510" )
yeartotal <- aggregate(Emissions ~ year, NEI_Baltimore, sum)
## open the default screen device on this platform if no device is open
if(dev.cur() == 1) dev.new()
plot(yeartotal$year, yeartotal$Emissions, xlab="Year", ylab="PM2.5 in tons")
title(main = "Total PM2.5 Emission from all sources in Baltimore City")
# copy the plot2 to png device
dev.copy(png, file = "plot2.png")
# close the device
dev.off()
par(mfrow= c(1,1))
gc(verbose = TRUE)
} else {
  print(" Dta files are not found. Unzip the file into data dir and rerun this")
}

