#- INTERVIEW MODEL TAB
eda <- tabItem(
  tabName = "eda",
  
  fluidPage(
    box(
      width = 12,
      HTML('<h2><b>Análisis exploratorio de datos</b></h2>'),
      h3("En esta sección podrás conocer un poco más sobre las características de las mascotas en adopción de nuestra base de datos. Por ejemplo, si tenemos más machos que hembras en adopción, o cuánto tiempo están en un albergue para ser adoptados."),
      h4("Nuestra base de datos se actualiza diariamente."),
      br(),
      hr()
    ),
    
    fluidRow(
      
      column(
        width = 6,
        
        selectInput(
          inputId = "selbar", 
          label = "Seleccione una variable categórica", 
          choices = c(
            "especie",
            "sexo",
            "esterilizado"
          ), 
          selected = "especie")  %>%
          helper(
            icon = "question",
            colour = "#da6c41",
            type = "inline",
            fade = TRUE,
            title = "Seleccione una variable categórica",
            content = c(
              "Seleccione una variable categórica para actualizar la información del gráfico de barras, densidad y cajas.",
              "",
              "En este gráfico de barras, puede analizar la cantidad de registros para cada categoría de la variable categórica.",
              ""
            ),
            buttonLabel = 'OK!'),
        
        plotlyOutput("barchart") %>%
          withSpinner(type = 7, color = "#da6c41")
      ),
      
      column(
        width = 6,
        
        selectInput(
          inputId = "selhist", 
          label = "Seleccione una variable continua", 
          choices = c(
            "edad",
            "dias_en_adopcion",
            "meses_en_adopcion"
          ), 
          selected = "especie")%>%
          helper(
            icon = "question",
            colour = "#da6c41",
            type = "inline",
            fade = TRUE,
            title = "Seleccione una variable continua",
            content = c(
              "Seleccione una variable continua para actualizar la información del gráfico de densidad y cajas.",
              "",
              "En este gráfico de densidad, puedes analizar la densidad de la variable continua para cada categoría de la variable categórica.",
              ""
            ),
            buttonLabel = 'OK!'),
        
        plotlyOutput("histchart") %>%
          withSpinner(type = 7, color = "#da6c41")
      )
    ),
    
    br(),
    hr(),
    
    box(
      width = 12,
      plotlyOutput("boxchart") %>%
        withSpinner(type = 7, color = "#da6c41")
    )%>%
      helper(
        icon = "question",
        colour = "#da6c41",
        type = "inline",
        fade = TRUE,
        title = "Seleccione una variable continua",
        content = c(
          "Este gráfico se utiliza de acuerdo con las selecciones realizadas arriba de la variable categórica y continua.",
          "",
          "En este gráfico de cajas, puedes analizar la distribución de la variable continua para cada categoría a partir de la variable categórica.",
          ""
        ),
        buttonLabel = 'OK!')
    
  )
)