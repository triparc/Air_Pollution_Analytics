# Compare emissions from motor vehicle sources in Baltimore City with emissions from 
# motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?
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
# Add a source city
NEI_Baltimore$city <- "Baltimore"
#
# select data from Los Angeles County
NEI_LosAngeles <- subset(NEI, fips == "06037" )
NEI_LosAngeles$city <- "Los Angeles"

# combine Baltimore and Los Angeles data
NEI_Both <- rbind(NEI_Baltimore, NEI_LosAngeles)
#
#Collect motor vehicle sources from SCC
vehicles <- grep("Vehicles$", SCC$EI.Sector)
SCC_Vehicle <- data.frame(SCC[vehicles,1])
names(SCC_Vehicle) <- "SCC"
SCC_Vehicle$SCC <- as.character(SCC_Vehicle$SCC)
#Join NEI ans SCC_Vehicle
NEI_Vehicle <- inner_join(SCC_Vehicle, NEI_Both, by = "SCC")
#Convert year in NEI to factor variable
NEI_Vehicle$year <- as.factor(NEI_Vehicle$year)
yeartotal <- aggregate(Emissions ~ year + city, NEI_Vehicle, sum)
# Plot the graphs
## open the default screen device on this platform if no device is open
library(gridExtra)
if(dev.cur() == 1) dev.new()

plot1 <- ggplot(yeartotal, aes(x=year, y = Emissions, col = city)) +
  geom_point() + 
  stat_smooth(aes(group=1),method = "lm", se = FALSE) +
  facet_grid(~ city) +
  theme(axis.text.x = element_text(angle = 60, vjust = 0.5, color = "black")) + 
  xlab("Year") + 
  ylab("Emissions in tons") + 
  ggtitle("Total PM2.5 Emission by City from motor vehicle sources")

# Compare yearly changes
# Dodged bar charts
plot2 <- ggplot(yeartotal, aes(x = year, y = Emissions, fill = city)) + 
  geom_bar(stat = "identity", position="dodge") +
  ggtitle("Total PM2.5 Emission by City from motor vehicle sources")

grid.arrange(plot1, plot2, nrow=2)
# copy the plot5 to png device
dev.copy(png, file = "plot6.png")
# close the device
dev.off()
gc(verbose = TRUE)
} else {
  print(" Dta files are not found. Unzip the file into data dir and rerun this")
}

