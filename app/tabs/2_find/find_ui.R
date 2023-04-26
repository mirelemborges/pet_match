#- INTERVIEW MODEL TAB
find <- material_side_nav_tab_content(
  side_nav_tab_id = "find",
  
  fluidPage(
    column(
      width = 12,
      # class = 'home_welcome',
      HTML('<h4><b>Encuentra tu mascota</b></h4>'),
      h4("Despues de contestar esta pequena encuesta encontraras un listado de las mascotas que tienen más match contigo!"),
      br(),
      
      column(
        width = 12,
        
        material_number_box( 
          input_id = "usuario_edad", 
          label = "¿Cuantos años tienes?", 
          initial_value = 18,
          min_value = 18,
          max_value = 100,
          step = 1),
        
        material_dropdown(
          input_id = "tipo", 
          label = "¿Que tipo de mascota prefieres?", 
          choices = c("Perro" = 1, "Gato" = 2, "No tengo preferencia" = 3), 
          multiple =  FALSE),
        
        material_dropdown(
          input_id = "genero", 
          label = "¿Que genero de mascota prefieres?", 
          choices = c("Hembra" = 1, "Macho" = 2, "No tengo preferencia" = 3), 
          multiple =  FALSE),
        
        material_dropdown(
          input_id = "ppp", 
          label = "¿La mascota vivirá con ancianos o niños?", 
          choices = c("No" = 2, "Sí" = 1), 
          multiple =  FALSE), 
        
        material_dropdown(
          input_id = "vivienda", 
          label = "¿Donde vives?", 
          choices = c("Piso pequeño" = 1, "Piso grande" = 2, "Casa sin área externa" = 3, "Casa con área externa" = 4), 
          multiple =  FALSE), 
        
        material_number_box(
          input_id = "usuario_npersonas", 
          label = "¿Además de ti, cuantos personas viven en su hogar?", 
          initial_value = 0,
          min_value = 0,
          max_value = 20,
          step = 1),
        
        material_number_box(
          input_id = "mascotas", 
          label = "¿Cuantos mascotas tienes?", 
          initial_value = 0,
          min_value = 0,
          max_value = 20,
          step = 1),
        
        material_dropdown(
          input_id = "edad", 
          label = "¿Tienes una preferencia de edad para tu mascota?", 
          choices = c("Joven" = 1, "Adulto" = 2, "Sénior" = 3), 
          multiple =  FALSE),
        
        
        
        actionButton("match", "Buscar match!", class = "btn-success")
      ),
      
      

      
      column(
        width = 10,
        br(),
        hr(), 
        br(),
        
        DT::dataTableOutput("db")
      )
      

    )

  )
)