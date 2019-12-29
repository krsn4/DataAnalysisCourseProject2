#fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(fileUrl, destfile = "dataset.zip")
#unzip("dataset.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#6 (Emissions from MC, Baltimore vs Los Angeles)
NEI_LA <- NEI[NEI$fips == "06037",]
NEI_LA_mc <- (NEI_LA$SCC %in% SCC[motor_vehicles,]$SCC)
#g5 <- ggplot(NEI_LA[NEI_LA_mc , ], aes(x=year, y=Emissions))
#g5 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to Motor vehicles in Los Angeles")

Bal_LA <- rbind(NEI_bal[NEI_bal_mc,], NEI_LA[NEI_LA_mc,])
png(file = "plot6.png")
g6 <- ggplot(Bal_LA, aes(x=year, y=Emissions, col = fips))
g6 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to Motor vehicles")
dev.off()
