#fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(fileUrl, destfile = "dataset.zip")
#unzip("dataset.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#2 (Baltimore only)
NEI_bal <- NEI[NEI$fips == "24510",]
totems_bal <- tapply(NEI_bal$Emissions, NEI_bal$year, sum)
totalemission_bal <- data.frame(x=unique(NEI_bal$year), y=totems_bal)

png(file = "plot2.png")
plot(totalemission_bal, pch=19, xlab = "year", ylab = "Baltimore: total pm2.5 emissions (tons)", type = "b") 
dev.off()
