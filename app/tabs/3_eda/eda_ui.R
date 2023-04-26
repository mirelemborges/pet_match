#- INTERVIEW MODEL TAB
eda <- material_side_nav_tab_content(
  side_nav_tab_id = "eda",
  
  fluidPage(
    box(
      width = 12,
      HTML('<h2><b>Análisis exploratorio de datos</b></h2>'),
      h3("...."),
      br(),
      hr()
    ),
    
    fluidRow(
      
      column(
        width = 6,
        
        selectInput(
          inputId = "selbar", 
          label = "Seleccione una variable", 
          choices = c(
            "especie",
            "sexo",
            "esterilizado",
            "raza",
            "category_edad"
          ), 
          selected = "especie"),
        
        plotOutput("barchart")
      ),
      
      column(
        width = 6,
        
        selectInput(
          inputId = "selhist", 
          label = "Seleccione una variable", 
          choices = c(
            "edad",
            "dias_en_adopcion",
            "meses_en_adopcion"
          ), 
          selected = "especie"),
        
        plotOutput("histchart")
      )
    ),
    
    br(),
    hr(),
    br(),
    
    box(
      width = 12,
      plotOutput("boxchart")
    )
    
  )
)