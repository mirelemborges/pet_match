require(dplyr)
require(tidyr)
require(DBI)
require(bigrquery)

# big query connection
con <<- dbConnect(
  bigrquery::bigquery(),
  project = "pet-match-378611",
  dataset = "pet_match"
)

## list tables
dbListTables(con)

## Get data from Big Query to local
db <- tbl(con, 'cleaned_adoption_list_table') %>% 
  collect()

## enconding


db_label <- db %>% 
  select(id, especie, sexo, peligroso, tamagno, rabia, esterilizado, category_edad)

db_label_factor <- db_label %>% 
  mutate(
    id=id,
    especie=as.numeric(factor(especie, levels = c("Canina", "Felina"))),
    sexo=as.numeric(factor(sexo, levels = c("Hembra", "Macho"))),
    peligroso=as.numeric(factor(peligroso, levels = c("N", "S"))),
    tamagno=as.numeric(factor(tamagno, levels = c("Pequeño (< 10 Kg)", "Mediano (11-25 kg)", "Grande (26-44 kg", "Gigante (> 45 Kg)"))),
    rabia=as.numeric(factor(rabia, levels = c("N", "S"))),
    esterilizado=as.numeric(factor(esterilizado, levels = c("N", "S"))),
    category_edad=as.numeric(factor(category_edad, levels = c("joven", "adulto", "sénior")))
  ) %>% 
  select(
    especie, 
    sexo, 
    peligroso,
    tamagno,
    rabia,
    esterilizado,
    category_edad
  )

db_model <- as.matrix(db_label_factor,)
row.names(db_model) <- db_label$id



# modeling
library(lsa)

user <- as.factor(c(2, 1, 2, 4, 1, 1, 2))


#matrix <- rbind(user, opcion1, opcion2, opcion3, opcion4, opcion5, opcion6, opcion7)

matrix <- rbind(user, db_model)

result <- cosine(t(matrix))

result_df <- as.data.frame(result[,1],make.names = TRUE)
colnames(result_df) <- "model_result"
result_df$names <- row.names(result_df)

db_to_show <- result_df[2:nrow(result_df),] %>%
  # arrange(desc(model_result)) %>% 
  top_n(10,wt = model_result)






## eda

require(dplyr)
require(tidyverse)
require(lubridate)
require(stringr)
require(ggplot2)


## eda charts

## especie

db <- db %>% 
  mutate( count = 1)

banana <- "especie"

chart_especie <- db %>% 
  group_by_(banana) %>% 
  summarise(total = sum(count))

  

ggplot(chart_especie, aes(x="", y=total, fill=get(banana))) +
  geom_bar(stat="identity", position = "dodge")+
  scale_fill_discrete(name = banana)


## media meses en adopcion


chart_meses_adopcion <- db %>% 
  group_by(especie) %>% 
  summarise(total = mean(meses_en_adopcion))



ggplot(chart_meses_adopcion, aes(x="", y=total, fill=especie)) +
  geom_bar(stat="identity", position = "dodge")


## edad media


chart_edad <- db %>% 
  group_by(especie) %>% 
  summarise(total = mean(edad))



ggplot(chart_edad, aes(x="", y=total, fill=especie)) +
  geom_bar(stat="identity", position = "dodge")


## categoria edad canina


chart_categoria_canina <- db %>% 
  filter(especie == "Canina") %>% 
  group_by(category_edad) %>% 
  summarise(total = sum(count))



ggplot(chart_categoria_canina, aes(x="", y=total, fill=category_edad)) +
  geom_bar(stat="identity", position = "dodge")


## categoria edad felina


chart_categoria_felina <- db %>% 
  filter(especie == "Felina") %>% 
  group_by(category_edad) %>% 
  summarise(total = sum(count))



ggplot(chart_categoria_felina, aes(x="", y=total, fill=category_edad)) +
  geom_bar(stat="identity", position = "dodge")



## esterelizado


chart_esterel <- db %>% 
  group_by(esterilizado) %>% 
  summarise(total = sum(count))



ggplot(chart_esterel, aes(x="", y=total, fill=esterilizado)) +
  geom_bar(stat="identity", position = "dodge")
