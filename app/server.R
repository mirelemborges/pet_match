#--- SERVER ---#
server <- function(input, output, session) 
{
  #- Help buttons
  observe_helpers(withMathJax = TRUE)
  
  # Home Server
  source('tabs/1_about/about_server.R', local = TRUE)
  
  # Interview Model Server
  source('tabs/2_find/find_server.R', local = TRUE)
  
  # Exploratory Data Analysis
  source('tabs/3_eda/eda_server.R', local = TRUE)
  
}



