# ui ----
require(shiny)
require(shinymaterial)
require(shinyhelper)
require(shinycustomloader)
require(shinycssloaders)
require(ggplot2)
require(dplyr)
require(tidyr)
require(DBI)
require(bigrquery)
require(magrittr)
require(cli)
require(dbplyr)
require(vctrs)
require(rlang)
require(shinydashboard)
require(shinydashboardPlus)
require(lsa)
require(DT)
require(reactable)
require(plotly)
require(shinyWidgets)


#- Loading UIs
source("tabs/1_about/about_ui.R")
source("tabs/2_find/find_ui.R")
source("tabs/3_eda/eda_ui.R")


#- Connection bigquery

#- Credentials to connecting to BigQuery and Starting
json <<- "www/crendentials/pet-match-378611-6b43fb1dc6ee-service-account.json"
bigrquery::bq_auth(path = json)
bigQueryR::bqr_auth(json_file = json)

# <<- for global variable
con <<- dbConnect(
  bigrquery::bigquery(),
  project = "pet-match-378611",
  dataset = "pet_match"
)


# MAIN UI START
ui <- shinydashboardPlus::dashboardPage(
  title = "Pet Match",
  skin = "yellow",
  
  
  #  dash title
  dashboardHeader(title = span(tagList(icon("paw"), "Pet Match"))),
  
  # left menu
  dashboardSidebar(
    sidebarMenu(
      menuItem("Acerca de Pet Match", tabName = "about", icon = icon("home")),
      menuItem("Encuentra tu mascota", tabName = "find", icon = icon("paw")),
      menuItem("Análisis", tabName = "eda", icon = icon("chart-line"))
    )
  ),
  
  
  # dash body
  dashboardBody(
    
    tags$head(
      # css style
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "styles.css"
      ),
      
      # page icon
      tags$link(
        rel = "shortcut icon",
        href = "img/logo_page.png"
      ),
      
      # page font
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "http://fonts.googleapis.com/css?family=Open+Sans%7CSource+Sans+Pro"
      )
    ),
    
    #- Remove error messages
    tags$style(
      type="text/css",
      ".shiny-output-error { visibility: hidden; }",
      ".shiny-output-error:before { visibility: hidden; }"
    ),
    
    setShadow("box"),
    
    #- TABS
    tabItems(
      about,
      find,
      eda
    )
  )
)
  


