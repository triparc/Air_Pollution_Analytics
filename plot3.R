# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question.
# Install packages
library(data.table)
library(dplyr)
library('ggplot2')
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
NEI$type <- as.factor(NEI$type)
NEI_Baltimore <- subset(NEI, fips == "24510" )
yeartotal <- aggregate(Emissions ~ type + year, NEI_Baltimore, sum)
## open the default screen device on this platform if no device is open
if(dev.cur() == 1) dev.new()

ggplot(yeartotal, aes(x=year, y = Emissions/1000, col = type)) +
  geom_point() + 
  stat_smooth(aes(group=1),method = "lm", se = FALSE) +
  facet_grid(~ type) +
  ggtitle("Total PM2.5 Emission from all sources by type in Baltimore City") +
  labs(x="Year",y="Emissions in Kilo tons") 

# copy the plot3 to png device
dev.copy(png, file = "plot3.png")
# close the device
dev.off()
gc(verbose = TRUE)
} else {
  print(" Dta files are not found. Unzip the file into data dir and rerun this")
}