##this code is used to calculate the global eLUE-GPP and GPP_uncertainty

library(raster)

folder_path_MCD <- "G:\\data\\MCD13C1"
file_list_MCD <- list.files(folder_path_MCD, pattern = ".tif")
folder_path_PAR <- "G:\\data\\PARTOA"
file_list_PAR <- list.files(folder_path_PAR, pattern = ".tif")

##eLUE model parameters

β_0 <- 0.05
β_1<- 1.39
β_1_uncertainty <- 0.01
β_0_uncertainty <- 0.003
EVI_uncertainty <- 0.02
d <- 0.12
d_uncertainty <- 0.002


projection <- "+proj=longlat +datum=WGS84"

for (file_path_MCD in file_list_MCD) {
  date_MCD <- substr(file_path_MCD, 1, 7)
  raster_stack_MCD <- stack(file_path_MCD)
  raster_stack_EVI <- raster_stack_MCD - d
  raster_stack_EVI[raster_stack_EVI < 0] <- NA
  for (file_path_PAR in file_list_PAR) {
    date_PAR <- substr(file_path_PAR, 1, 7)
    {
      if (date_MCD == date_PAR) {
        raster_stack_PAR <- stack(file_path_PAR)
        GPP<-raster_stack_PAR*(raster_stack_EVI * β_1 + β_0)
        GPP_uncertain <- sqrt(EVI_uncertainty^2 * β_1 ^2* raster_stack_PAR^2 + raster_stack_EVI^2 * raster_stack_PAR^2 * β_1_uncertainty^2 - β_1_uncertainty^2 * d^2 * raster_stack_PAR^2 - 
                                d_uncertainty^2 * β_1^2 * raster_stack_PAR^2 + β_0_uncertainty^2 * raster_stack_PAR^2)
        
        GPP_pro <- projectRaster(GPP, crs = projection)
        GPP_uncertain_pro <- projectRaster(GPP_uncertain, crs = projection)
        
        output_path_GPP <- "G:\\data\\16_day\\GPP"
        output_file_GPP <- paste0("MaLab_MCD13C1_eLUE_GPP_",date_MCD, "_001", ".tif")
        writeOptions <- c("COMPRESS=LZW")
        writeRaster(GPP_pro, file.path(output_path_GPP, output_file_GPP), options = writeOptions)
        
        output_path_GPP_uncertain <- "G:\\data\\16_day\\GPP_uncertainty"
        output_file_GPP_uncertain <- paste0("MaLab_MCD13C1_eLUE_GPP_uncertainty_",date_MCD, "_001", ".tif")
        writeRaster(GPP_uncertain_pro, file.path(output_path_GPP_uncertain, output_file_GPP_uncertain), options = writeOptions)
      }
      else {}
    }
  }
}

