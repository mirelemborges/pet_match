#-- INTERVIEW SERVER --#

cat_analysis <- reactive({
  db <- tbl(con, 'cleaned_adoption_list_table') %>% 
    collect()
  
  db <- db %>% 
    mutate( count = 1)
  
  chart_db <- db %>% 
    group_by_(input$selbar) %>% 
    summarise(total = sum(count))
  
  
  
  plot1 <- ggplotly(
    ggplot(chart_db, aes(x="", y=total, fill=get(input$selbar))) +
      geom_bar(stat="identity", position = "dodge")+
      xlab(input$selbar) +
      CSGo::theme_csgo() +
      scale_fill_manual(values = c("#da6c41", "#222d32b8"),
                        name = input$selbar)
  )
  
  return(plot1)
  
})

cont_analysis <- reactive({
  db <- tbl(con, 'cleaned_adoption_list_table') %>% 
    collect()

  
  plot2 <- ggplotly(
    ggplot(data = db, aes(x=get(input$selhist), fill=get(input$selbar))) +
      geom_density(alpha=.3)+
      xlab(input$selhist) +
      CSGo::theme_csgo() +
      scale_fill_manual(values = c("#da6c41", "#222d32b8"),
                        name = input$selbar)
  )
  
  return(plot2)
  
})

box_analysis <- reactive({
  db <- tbl(con, 'cleaned_adoption_list_table') %>% 
    collect()

  plot3 <- ggplotly(
    ggplot(data = db, aes(x=get(input$selbar), y=get(input$selhist), fill=get(input$selbar))) + 
      geom_boxplot()+
      ylab(input$selhist)+
      xlab(input$selbar)+
      CSGo::theme_csgo() +
      scale_fill_manual(values = c("#da6c41", "#222d32b8"),
                        name = input$selbar)
  )
  
  return(plot3)
  
})


#- OUTPUTS

output$barchart <- renderPlotly(cat_analysis())

output$histchart <- renderPlotly(cont_analysis())

output$boxchart <- renderPlotly(box_analysis())







