# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.
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
#Convert year in NEI to factor variable
NEI$year <- as.factor(NEI$year)
yeartotal <- aggregate(Emissions ~ year, NEI, sum)
## open the default screen device on this platform if no device is open
if(dev.cur() == 1) dev.new()
plot(yeartotal$year, yeartotal$Emissions/10000000, xlab="Year", ylab="PM2.5 in million tons")
title(main = "Total PM2.5 Emission from all sources in US")
# copy the plot1 to png device
dev.copy(png, file = "plot1.png")
# close the device
dev.off()
gc(verbose = TRUE)
} else {
  print(" Dta files are not found. Unzip the file into data dir and rerun this")
}