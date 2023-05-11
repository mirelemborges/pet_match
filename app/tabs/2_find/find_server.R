#-- INTERVIEW SERVER --#

# aux function for create the skull scale in the dream team table #
rating_paw <- function(rating, max_rating = 5) {
  star_icon <- function(empty = FALSE) {
    tagAppendAttributes(
      shiny::icon("paw"),
      style = paste("color:", if (empty) "#edf0f2" else "#da6c41"),
      "aria-hidden" = "true"
    )
  }
  rounded_rating <- floor(rating + 0.5)  # always round up
  stars <- lapply(seq_len(max_rating), function(i) {
    if (i <= rounded_rating) star_icon() else star_icon(empty = TRUE)
  })
  label <- sprintf("%s out of %s", rating, max_rating)
  div(title = label, role = "img", stars)
}



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
    "ciudad" = input$ciudad,
    "usuario_edad" = input$usuario_edad,
    "tipo" = input$tipo,
    "genero" = input$genero,
    "ppp" = input$ppp,
    "vivienda" = input$vivienda,
    "usuario_npersonas" = input$usuario_npersonas,
    "mascotas" = input$mascotas,
    "edad" = input$edad,
    "horas" = input$horas
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
    top_n(3,wt = model_result)
  
  
  db_to_input <- db %>% 
    filter(id %in% as.numeric(db_to_filter$names)) 
  
  
  db_model_return <-  db_to_input[1:3,]
  
  return(db_model_return)
  
   
})


#  creating the reactable
table_to_show <- eventReactive(input$match, {
  
  db_to_input <- match_table()
  
  
  db_to_input2 <- db_to_input %>% 
    mutate(
      score = c(5,4,3)
    ) %>%
    select(
      link_foto,
      title,
      dias_en_adopcion,
      score,
      link_contacto
    )
  
  
  
  db_to_show <- reactable(
    data = db_to_input2,
    selection = "single",
    onClick = "select",
    defaultSelected = 1,
    
    columns = list(
      
      link_foto = colDef(
        name = "Foto",
        align = "center",
        sortable = FALSE,
        cell = function(value, index) {
          htmltools::tags$a(
            href = db_to_input2$link_foto[index],
            target = "_blank",
            htmltools::tags$img(src = value, class = 'table_img')
          )
        }),
      
      title = colDef(
        name = "Nombre"
      ),
      
      dias_en_adopcion = colDef(
        name = "Días en Adopción"
      ),
      
      score = colDef(
        name = "Score",
        cell = function(score) rating_paw(score)
      ),
      
      link_contacto = colDef(
        name = "Adoptar",
        sortable = FALSE,
        cell = function(value, index) {
          htmltools::tags$a(
            href = db_to_input2$link_contacto[index],
            target = "_blank",
            htmltools::tags$a(href = value, "Pulsa aquí para saber más!")
          )
        })
    )
  )
  return(db_to_show)
  
})



# ui to show
ui_to_show <- eventReactive(input$match, {
  
  # ui to show when the button match is pressed
  ui_to_return <- box(
    width = 12,
    br(),
    
    reactableOutput("table")  %>%
      withSpinner(type = 7, color = "#da6c41"),  
    
    br(),
    hr(), 
    br(),
    
    h5("Para ayudar a mejorar el modelo de recomendación, seleccione en la tabla arriba la mascota que más le haya gustado y presione el botón GUARDAR."),
    hr(), 
    br(),
    actionButton("guardar", "GUARDAR", class = "btn-success")
  )
  
  return(ui_to_return)
  
  
})



# save user info + pet info selected (when GUARDAR is pressed)
save_selection <- eventReactive(input$guardar, {
  
  #  get info from user (selection)
  selected <- getReactableState("table", "selected")
  table_presented_user <- match_table()
  user_info <- collect_user_info() %>% 
    rename(
      "preferencia_usuario_ciudad" = "ciudad",
      "respuesta_usuario_edad" = "usuario_edad",
      "preferencia_usuario_tipo" = "tipo",
      "preferencia_usuario_genero" = "genero",
      "respuesta_usuario_ppp" = "ppp",
      "respuesta_usuario_vivienda" = "vivienda",
      "respuesta_usuario_n_personas" = "usuario_npersonas",
      "respuesta_usuario_n_mascotas" = "mascotas",
      "respuesta_usuario_edad_mascota" = "edad",
      "respuesta_usuario_horas_disponibles" = "horas",
      
    )
  
  
  table_selected_user <- table_presented_user[selected,]
  
  db_to_save_bigquery <- cbind(user_info, table_selected_user)
  
 
  # uploading user info and selected pet to bigquery
  bigQueryR::bqr_upload_data(  
    projectId = 'pet-match-378611',
    datasetId = 'pet_match', 
    tableId  = 'user_info_selection', 
    upload_data  = db_to_save_bigquery,
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
  
  ui_to_return <- box(
    width = 12, 
    h4("Gracias por ayudar a mejorar nuestro algoritmo!")
  )
  
  return(ui_to_return)
})





#- OUTPUTS
output$ui_to_show <- renderUI(ui_to_show())
output$table <- renderReactable(table_to_show())
output$guardar_message <- renderUI(save_selection())




