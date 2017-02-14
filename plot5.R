# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
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
#Convert year in NEI to factor variable and select data from Baltimore city
NEI$year <- as.factor(NEI$year)
NEI$type <- as.factor(NEI$type)
NEI_Baltimore <- subset(NEI, fips == "24510" )
#Collect motor vehicle sources from SCC
vehicles <- grep("Vehicles$", SCC$EI.Sector)
SCC_Vehicle <- data.frame(SCC[vehicles,1])
names(SCC_Vehicle) <- "SCC"
SCC_Vehicle$SCC <- as.character(SCC_Vehicle$SCC)
#Join NEI ans SCC_Vehicle
NEI_Vehicle <- inner_join(SCC_Vehicle, NEI_Baltimore, by = "SCC")
#Convert year in NEI to factor variable
NEI_Vehicle$year <- as.factor(NEI_Vehicle$year)
NEI_Vehicle$Emissions <- NEI_Vehicle$Emissions
yeartotal <- aggregate(Emissions ~ year, NEI_Vehicle, sum)
## open the default screen device on this platform if no device is open
if(dev.cur() == 1) dev.new()
plot(yeartotal$year, yeartotal$Emissions, xlab="Year", ylab="PM2.5 in tons")
title(main = "Total PM2.5 Emission from motor vehicles in Baltimore City")
# copy the plot5 to png device
dev.copy(png, file = "plot5.png")
# close the device
dev.off()
gc(verbose = TRUE)
} else {
  print(" Dta files are not found. Unzip the file into data dir and rerun this")
}

