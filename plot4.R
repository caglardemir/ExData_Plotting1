library(dplyr)
library(lubridate)

### Download individual household electric power consumption data set

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp, method = "curl")
unzip(zipfile = temp)
unlink(temp)

### Read data and reformat columns

power_data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";") %>% 
  filter(Date == "1/2/2007" | Date == "2/2/2007") %>% 
  mutate(Date = as.Date(Date, format = "%d/%m/%Y"),
         Time = hms(Time),
         Date_Time = Date + Time,
         Global_active_power = as.numeric(Global_active_power),
         Global_reactive_power = as.numeric(Global_reactive_power),
         Voltage = as.numeric(Voltage),
         Global_intensity = as.numeric(Global_intensity),
         Sub_metering_1 = as.numeric(Sub_metering_1),
         Sub_metering_2 = as.numeric(Sub_metering_2),
         Sub_metering_3 = as.numeric(Sub_metering_3)
  )

## Generate Plot 4 and save to PNG
par(mfrow = c(2, 2))

with(power_data, 
     plot(Date_Time, Global_active_power, 
          type = "l", 
          ylab = "Global Active Power", 
          xlab = ""))

with(power_data, 
     plot(Date_Time, Voltage, 
          type = "l", 
          ylab = "Voltage", 
          xlab = "datetime"))

with(power_data, {
  plot(Date_Time, Sub_metering_1, type = "l", col = "black", ylab = "Energy sub metering", xlab = "")
  points(Date_Time, Sub_metering_2, type = "l", col = "red")
  points(Date_Time, Sub_metering_3, type = "l", col = "blue")
})

legend("topright",col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", lty = c(1,1,1))

with(power_data, 
     plot(Date_Time, Global_reactive_power, 
          type = "l", 
          ylab = "Global_reactive_power", 
          xlab = "datetime"),
          ylim = c(0, 0.5))

dev.copy(png, file = "plot4.png")
dev.off()
