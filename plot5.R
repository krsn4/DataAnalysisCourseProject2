#fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(fileUrl, destfile = "dataset.zip")
#unzip("dataset.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#5 (from motor vehicles in Baltimore, assuming to count if Short.Name contains "Motor")
motor_vehicles <- grepl("[Mm]otor", SCC$Short.Name)
NEI_bal_mc <- (NEI_bal$SCC %in% SCC[motor_vehicles,]$SCC)
png(file = "plot5.png")
g4 <- ggplot(NEI_bal[NEI_bal_mc , ], aes(x=year, y=Emissions))
g4 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to Motor vehicles in Baltimore")
dev.off()
