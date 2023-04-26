#install.packages("httr")

library(httr)
library(dplyr)
library(tidyr)

#antiguo end point
#request <- GET("https://www.zaragoza.es/sede/servicio/mascotas?rows=10000")

request <- GET("https://www.zaragoza.es/sede/servicio/proteccion-animal?rows=10000")


contente_result <- content(request)

json <- jsonlite::toJSON(contente_result$result)

db <- jsonlite::fromJSON(json,simplifyDataFrame = TRUE, flatten = TRUE) %>% 
  unnest(cols = c(id, title, especie, raza, sexo, peligroso, fechaNacimiento, 
                  capa, tamagno, foto, lugar, disponibilidad, identificadoIngreso, 
                  microchip, pasaporteISO, pasaporteNum, rabia, esterilizado, 
                  enCMPA, creationDate, lastUpdated, cartilla, fechaRabia, 
                  lugarEsterilizacion, fechaEsterilizacion, caracter, description, 
                  chenil)) %>% 
  mutate(
    foto2 = paste0("https://www.zaragoza.es",foto)
  )


names(db)



#usar para guardar base
saveRDS(db, "data/proteccion-animal_20230216.rds")

