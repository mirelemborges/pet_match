#- INTERVIEW MODEL TAB
find <- tabItem( 
  tabName = "find",
  
  fluidPage(
    box(
      width = 12,
      # class = 'home_welcome',
      HTML('<h2><b>Encuentra tu mascota</b></h2>'),
      h3("¡Despues de contestar esta pequena encuesta encontrarás un listado de las mascotas que tienen más match contigo!"),
      br()
    ),
    
    box(
      width = 12,
      
      selectInput( 
        inputId = "ciudad", 
        label = "¿Donde quieres encontrar tu mascota?", 
        choices = c("Zaragoza" = "zaragoza", "Cualquier ciudad" = "all"), 
        multiple =  FALSE) %>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Donde quieres encontrar tu mascota?",
          content = c(
            "Selecciona la ciudad donde quieres encontrar a tu mascota.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      numericInput( 
        inputId = "usuario_edad", 
        label = "¿Cuantos años tienes?", 
        value = 18,
        min = 18,
        max = 100,
        step = 1)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Cuantos años tienes?",
          content = c(
            "Escribe tu edad.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      selectInput(
        inputId = "tipo", 
        label = "¿Que tipo de mascota prefieres?", 
        choices = c("Perro" = 1, "Gato" = 2, "No tengo preferencia" = 3), 
        multiple =  FALSE)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Que tipo de mascota prefieres?",
          content = c(
            "Elige el tipo de mascota que prefieres o si no tienes preferencia elige No tengo preferencia.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      selectInput(
        inputId = "genero", 
        label = "¿Que genero de mascota prefieres?", 
        choices = c("Hembra" = 1, "Macho" = 2, "No tengo preferencia" = 3), 
        multiple =  FALSE)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Que genero de mascota prefieres?",
          content = c(
            "Elige el genero de la mascota que prefieres o si no tienes preferencia elige No tengo preferencia.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      selectInput(
        inputId = "ppp", 
        label = "¿La mascota vivirá con ancianos o niños?", 
        choices = c("No" = 2, "Sí" = 1), 
        multiple =  FALSE)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿La mascota vivirá con ancianos o niños?",
          content = c(
            "Seleccione Sí si la mascota vivirá en el mismo entorno que un niño o una persona mayor y No si la mascota no vivirá en el mismo entorno que un niño o una persona mayor.",
            ""
          ),
          buttonLabel = 'OK!'), 
      
      selectInput(
        inputId = "vivienda", 
        label = "¿Donde vives?", 
        choices = c("Piso pequeño" = 1, "Piso grande" = 2, "Casa sin área externa" = 3, "Casa con área externa" = 4), 
        multiple =  FALSE)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Donde vives?",
          content = c(
            "Selecciona el tipo de vivienda que mejor se adapte a tu situación actual.",
            ""
          ),
          buttonLabel = 'OK!'), 
      
      numericInput(
        inputId = "usuario_npersonas", 
        label = "¿Además de ti, cuantos personas viven en su hogar?", 
        value = 0,
        min = 0,
        max = 20,
        step = 1)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Además de ti, cuantos personas viven en su hogar?",
          content = c(
            "Escriba el número de personas que viven con usted en su hogar.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      numericInput(
        inputId = "mascotas", 
        label = "¿Cuantos mascotas tienes?", 
        value = 0,
        min = 0,
        max = 20,
        step = 1)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Cuantos mascotas tienes?",
          content = c(
            "Escribe el número de mascota que ya tienes, si no tienes, escribe 0.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      selectInput(
        inputId = "edad", 
        label = "¿Tienes una preferencia de edad para tu mascota?", 
        choices = c("Joven" = 1, "Adulto" = 2, "Sénior" = 3), 
        multiple =  FALSE)%>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Tienes una preferencia de edad para tu mascota?",
          content = c(
            "Seleccione la categoría de edad que prefiera para su nueva mascota.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      selectInput( 
        inputId = "horas", 
        label = "¿Cuántas horas tendrías disponibles para dedicar al cuidado de mascotas?", 
        choices = c("Menos de una hora" = 1, "De una hora a dos horas" = 2, "De dos hora a tres horas" = 3, "De tres hora a cuatro horas" = 3, "Más de cuatro horas" = 4), 
        multiple =  FALSE) %>%
        helper(
          icon = "question",
          colour = "#da6c41",
          type = "inline",
          fade = TRUE,
          title = "¿Cuántas horas tendrías disponibles para dedicar al cuidado de mascotas?",
          content = c(
            "Selecciona la opción que mejor se adapte a tu situación actual.",
            ""
          ),
          buttonLabel = 'OK!'),
      
      
      
      actionButton("match", "Buscar match!", class = "btn-success")
    ),
    br(),
    
    
    uiOutput("ui_to_show"),
    
    uiOutput("guardar_message") %>%
      withSpinner(type = 7, color = "#da6c41")
    

  )
  
)
