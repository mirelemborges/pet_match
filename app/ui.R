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
require(lsa)
require(DT)

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
ui <- shinymaterial::material_page(
  

  background_color = "#ffffff",
  primary_theme_color = "#000000",
  secondary_theme_color = "#da6c41",
  
  # PAGE NAME
  titlePanel(title = "", windowTitle = "Pet Match" ),
  
  title = "
    <span><b>
      <span style = 'color: #ffffff'> Pet Match </span>
    </b></span>",
  
  
  # SIDE BAR
  material_side_nav(
    fixed = TRUE,
    h5(icon = icon("paw"), class = "simbol"),
    
    material_side_nav_tabs(
      side_nav_tabs = c(
        "About" = "about",
        "Find your pet" = "find",
        "Analysis" = "eda"
      ),
      icons = c("home", "comment", "comment")
      
    )
  ),
  
  
  # BODY
  tags$head(
    # PAGE LOGO
    HTML('<link rel="icon", href="img/logo_page.png", type="image/png" />'),
    
    # THEME 
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  
  
  # TABS
  about,
  find,
  eda
  
  
  # FOOTER


)
