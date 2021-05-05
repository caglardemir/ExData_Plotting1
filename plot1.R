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

## Generate Plot 1 and save to PNG
hist(power_data$Global_active_power,
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col="red")

dev.copy(png, file = "plot1.png")
dev.off()