##this code is used to MOD13C1 EVI quality control


library(raster)

folder_path <- "G:\\data\\MOD13C1_HDF"
output_path<-"G:\\data\\MOD13C1"
file_list <- list.files(folder_path, pattern = ".hdf", full.names = FALSE)

for (file_path in file_list) 
  {
  
  raster_stack <- stack(file_path)
  evi_raster <- raster_stack$X.CMG.0.05.Deg.Monthly.EVI.
  qa_raster <- raster_stack$X.CMG.0.05.Deg.Monthly.pixel.reliability.
  
  qa_raster[qa_raster != 0] <- NA
  
  masked_evi <- mask(evi_raster, qa_raster )
  masked_evi<-masked_evi*0.0001
  
  output_path <- "D:\\data\\MOD13&MYD13\\C2_质量控制\\MOD13C2"
  output_file <- paste0(basename(file_path), ".tif")
  writeOptions <- c("COMPRESS=LZW")
  writeRaster(masked_evi, file.path(output_path, output_file), options = writeOptions)
}


