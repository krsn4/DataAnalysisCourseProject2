
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "dataset.zip")
unzip("dataset.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#1 (Nation wide emission sums over the years)
totems<- tapply(NEI$Emissions, NEI$year, sum)
totalemission <- data.frame(x=unique(NEI$year), y=totems)
plot(totalemission, pch=19, xlab = "year", ylab = "total pm2.5 emissions (tons)", type = "b") 

#2 (Baltimore only)
NEI_bal <- NEI[NEI$fips == "24510",]
totems_bal <- tapply(NEI_bal$Emissions, NEI_bal$year, sum)
totalemission_bal <- data.frame(x=unique(NEI_bal$year), y=totems_bal)
plot(totalemission_bal, pch=19, xlab = "year", ylab = "Baltimore: total pm2.5 emissions (tons)", type = "b") 

#3 (type-level emission sums)
library(ggplot2)
g <- ggplot(NEI_bal, aes(x=year, y=Emissions))
#g + geom_col() + facet_wrap(.~type)
g + stat_summary(geom="line", fun.y="sum") + facet_wrap(.~type, scales = "free") + ylab("PM2.5 total emissions (tons)")

g2 <- ggplot(NEI_bal, aes(x=year, y=Emissions, col = type))
g2 + stat_summary(geom="line", fun.y = "sum") + ylab("PM2.5 total emissions (tons)")

#4 (from coal combustions, nation-wide)
coal <- grepl("[Cc]oal", SCC$SCC.Level.Three)
combust <- grepl("[Cc]ombustion", SCC$SCC.Level.One)
coal_combust <- NEI$SCC %in% SCC[coal & combust,]$SCC
NEI_coal_combust <- NEI[coal_combust,]
g3 <- ggplot(NEI_coal_combust, aes(x=year, y=Emissions))
g3 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to coal combustions")

#5 (from motor vehicles in Baltimore, assuming to count if Short.Name contains "Motor")
motor_vehicles <- grepl("[Mm]otor", SCC$Short.Name)
NEI_bal_mc <- (NEI_bal$SCC %in% SCC[motor_vehicles,]$SCC)
g4 <- ggplot(NEI_bal[NEI_bal_mc , ], aes(x=year, y=Emissions))
g4 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to Motor vehicles in Baltimore")

#6 (Emissions from MC, Baltimore vs Los Angeles)
NEI_LA <- NEI[NEI$fips == "06037",]
NEI_LA_mc <- (NEI_LA$SCC %in% SCC[motor_vehicles,]$SCC)
g5 <- ggplot(NEI_LA[NEI_LA_mc , ], aes(x=year, y=Emissions))
g5 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to Motor vehicles in Los Angeles")

Bal_LA <- rbind(NEI_bal[NEI_bal_mc,], NEI_LA[NEI_LA_mc,])
g6 <- ggplot(Bal_LA, aes(x=year, y=Emissions, col = fips))
g6 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to Motor vehicles")
