## Function to compute extraterrestrial solar radiation

fun.extratsolar <- function(dtime, lat) {
  ## Day of year
  doy = as.integer(format(dtime, '%j'))
  ## Eccentricity of earth
  ep = 0.0167
  ## Earth's tilt (obliquity)
  epsilon = 23.45
  ## Longitude perihelion
  omega = 283
  ## Earth's orbital period
  T = 365.2422
  ## Time from the vernal equinox
  tv = omega + doy
  ## Time from perihelion
  tp = which.min(abs(c(as.integer(difftime(dtime, as.Date(paste(substr(dtime, 1, 4), '-01-03', sep = '')))),
                       as.integer(difftime(dtime, as.Date(paste(as.integer(substr(dtime, 1, 4)) + 1, '-01-03', sep = '')))))))
  tp = c(as.integer(difftime(dtime, as.Date(paste(substr(dtime, 1, 4), '-01-03', sep = '')))),
         as.integer(difftime(dtime, as.Date(paste(as.integer(substr(dtime, 1, 4)) + 1, '-01-03', sep = '')))))[tp]
  ## Solar declination
  lambda = asin((sin(epsilon * pi / 180) * sin((2 * pi * tv / T)))) * 180 / pi
  ## Ratio of Earth-Sun distance to the mean distance
  rr0 = 1 - ep * cos((360 * ((doy) / 365.24)) * pi / 180)
  ## Hour angle at sunset
  n<-max(-1,min(-tan(lat * pi / 180) * tan(lambda * pi / 180),1))
  H <- acos(n) * 180 / pi
  ## TOA solar flux
  f = 1366 / pi * rr0 ^ -2 * ((H * pi / 180) * sin(lat * pi / 180) * sin(lambda * pi / 180) + sin(H * pi / 180) * cos(lat * pi / 180) * cos(lambda * pi / 180))
  
  return(f)
}
