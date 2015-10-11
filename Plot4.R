# Plot4.R
# Richard Casto
# 2015-10-11

#setwd("D:/Coursera/Data Science Specalization/Exploratory Data Analysis/Programming Assignment 1")

# Create Data directory if it doesn't exist
if(!file.exists("./Data")) {
  dir.create("./Data")
}

# download file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="./Data/exdata-data-household_power_consumption.zip", method="auto", mode = "wb")

# load the full dataset (extracting out of the .ZIP at the same time)
dataraw <- read.table(unz("./Data/exdata-data-household_power_consumption.zip", "household_power_consumption.txt"), header = TRUE, sep = ";", quote = "\"", na.strings = c("?",""))

#str(dataraw)
#names(dataraw)
#head(dataraw)

# convert Date to "Date" type
dataraw$Date <- as.Date(as.character(dataraw$Date), format = "%d/%m/%Y")

# create a combined Date/Time column
dataraw$DateTime <- paste(dataraw$Date, dataraw$Time, sep = " ")

# convert Time to a DateTime "POSIXlt" type
dataraw$Time <- strptime(dataraw$DateTime, format = "%Y-%m-%d %H:%M:%S")

# create a subset for just 2007-02-01 and 2007-02-02
datasub <- subset(dataraw, Date >= as.Date("2007-02-01", format = "%Y-%m-%d") & Date <= as.Date("2007-02-02", format = "%Y-%m-%d"))

# plot to a PNG file
png(filename = "./plot4.png", width = 480, height = 480)

# Four plots in a 2x2 grid
par(mfrow = c(2,2))

# upper left
with(datasub, plot(Time, Global_active_power, xlab = "", ylab = "Global Active Power", type = "n"))
with(datasub, lines(Time, Global_active_power))

# upper right
with(datasub, plot(Time, Voltage, xlab = "datetime", ylab = "Voltage", type = "n"))
with(datasub, lines(Time, Voltage))

# bottom left
with(datasub, plot(Time, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "n"))
with(datasub, lines(Time, Sub_metering_1, col = "black"))
with(datasub, lines(Time, Sub_metering_2, col = "red"))
with(datasub, lines(Time, Sub_metering_3, col = "blue"))
legend(x = "topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), col=c("black", "blue", "red"), bty = "n")

# bottom right
with(datasub, plot(Time, Global_reactive_power, xlab = "datetime", type = "n"))
with(datasub, lines(Time, Global_reactive_power))

# turn off the device to finish the plot
dev.off()