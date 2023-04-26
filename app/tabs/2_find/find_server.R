#-- INTERVIEW SERVER --#

#function model
match_model_function <- function(user_vector, pet_dataframe){
  
  ## selecting colunms
  db_label <- pet_dataframe %>% 
    select(id, especie, sexo, peligroso, tamagno, rabia, esterilizado, category_edad)
  
  ## changing coluns types and label order
  db_label_factor <- db_label %>% 
    # mutate(
    #   id=id,
    #   especie=as.numeric(factor(especie, levels = c("Canina", "Felina"))),
    #   sexo=as.numeric(factor(sexo, levels = c("Hembra", "Macho"))),
    #   peligroso=as.numeric(factor(peligroso, levels = c("N", "S"))),
    #   tamagno=as.numeric(factor(tamagno, levels = c("Pequeño (< 10 Kg)", "Mediano (11-25 kg)", "Grande (26-44 kg", "Gigante (> 45 Kg)"))),
    #   rabia=as.numeric(factor(rabia, levels = c("N", "S"))),
    #   esterilizado=as.numeric(factor(esterilizado, levels = c("N", "S"))),
    #   category_edad=as.numeric(factor(category_edad, levels = c("joven", "adulto", "sénior")))
    # ) %>% 
    select(
      especie, 
      sexo, 
      peligroso,
      tamagno,
      rabia,
      esterilizado,
      category_edad
    )
  
  ## transforming the dataframe into a matrix
  pet_matrix <- as.matrix(db_label_factor,)
  row.names(pet_matrix) <- db_label$id
  
  ## adding the user in the matrix
  row.names(user_vector) <- "user"
  user_vector2 <- t(as.matrix(as.numeric(user_vector)))
  row.names(user_vector2) <- "user"
  colnames(user_vector2) <- c("especie", "sexo", "peligroso", "tamagno", "rabia", "esterilizado", "category_edad")
  matrix <- rbind(user_vector2, pet_matrix)
  
  ## running model
  result <- cosine(t(matrix))
  
  ## transforming result
  result_df <- as.data.frame(result[,1],make.names = TRUE)
  colnames(result_df) <- "model_result"
  result_df$names <- row.names(result_df)
  
  return(result_df)
}


#creating user table
collect_user_info <- eventReactive(input$match, {
  db <- data.frame(
    "usuario_edad" = input$usuario_edad,
    "tipo" = input$tipo,
    "genero" = input$genero,
    "ppp" = input$ppp,
    "vivienda" = input$vivienda,
    "usuario_npersonas" = input$usuario_npersonas,
    "mascotas" = input$mascotas,
    "edad" = input$edad
  )
  
  return(db)
  
})


#creating the match table to show to the user
match_table <- eventReactive(input$match, {
  
  # geting pet table from bigquery
  db <- tbl(con, 'cleaned_adoption_list_table') %>% 
    collect()
  
  user_info_raw <- collect_user_info()  
  
  # uploading user info to bigquery
  bigQueryR::bqr_upload_data(  
    projectId = 'pet-match-378611',
    datasetId = 'pet_match', 
    tableId  = 'user_info', 
    upload_data  = user_info_raw ,
    create  = c("CREATE_IF_NEEDED"),
    schema = NULL, 
    sourceFormat = c("CSV", "DATASTORE_BACKUP", "NEWLINE_DELIMITED_JSON", "AVRO"), 
    wait = TRUE, 
    autodetect = TRUE,
    nullMarker = NULL, 
    maxBadRecords = NULL, 
    allowJaggedRows = FALSE,
    allowQuotedNewlines = FALSE, 
    fieldDelimiter = ",",
    writeDisposition = 'WRITE_APPEND'
  )
    
    
  user_info <- user_info_raw %>% 
    mutate(
      extra_column = mascotas
    ) %>% 
    select(
      tipo,
      genero,
      ppp,
      vivienda,
      mascotas,
      extra_column,
      edad
    )
  
  db_model <- db %>% 
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
    filter(
      especie %in% ifelse(user_info$tipo == 3, c(1,2), user_info$tipo),
      sexo %in% ifelse(user_info$genero == 3, c(1,2), user_info$genero)
    )
  
  
  
  db_model_result <- match_model_function(user_vector = user_info, pet_dataframe = db_model)
  
  db_to_filter <- db_model_result[2:nrow(db_model_result), ] %>%
    top_n(10,wt = model_result)
  
  
  db_to_show <- db %>% 
    filter(id %in% as.numeric(db_to_filter$names))
  
  return(db_to_show)
  
})

#- OUTPUTS

output$db <- DT::renderDataTable(match_table())







