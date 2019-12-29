#fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#download.file(fileUrl, destfile = "dataset.zip")
#unzip("dataset.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#4 (from coal combustions, nation-wide)
coal <- grepl("[Cc]oal", SCC$SCC.Level.Three)
combust <- grepl("[Cc]ombustion", SCC$SCC.Level.One)
coal_combust <- NEI$SCC %in% SCC[coal & combust,]$SCC
NEI_coal_combust <- NEI[coal_combust,]
png(file = "plot4.png")
g3 <- ggplot(NEI_coal_combust, aes(x=year, y=Emissions))
g3 + stat_summary(geom="line", fun.y = "sum") + ylab("total emissions of PM2.5 (tons) due to coal combustions")
dev.off()
