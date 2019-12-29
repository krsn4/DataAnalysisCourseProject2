fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "dataset.zip")
unzip("dataset.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#1 (Nation wide emission sums over the years)
totems<- tapply(NEI$Emissions, NEI$year, sum)
totalemission <- data.frame(x=unique(NEI$year), y=totems)
 
png(file = "plot1.png")
plot(totalemission, pch=19, xlab = "year", ylab = "total pm2.5 emissions (tons)", type = "b")
dev.off()
