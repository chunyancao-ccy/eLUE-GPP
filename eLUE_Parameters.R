##this code is used to calculate the eLUE model parameters

setwd("G:\\data\\site")
data <- read.csv("site_data.csv")

##  Linear Regression
fit <- lm(eLUETOA~EVI, data = data)
sumarry<-summary(fit)


β_0<- sumarry$coefficients[1,1]
β_1<- sumarry$coefficients[2,1]

β_0_uncertainty <- sumarry$coefficients[1, 2] 
β_1_uncertainty <- sumarry$coefficients[2, 2]

