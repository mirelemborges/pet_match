#-- INTERVIEW SERVER --#

cat_analysis <- reactive({
  db <- tbl(con, 'cleaned_adoption_list_table') %>% 
    collect()
  
  db <- db %>% 
    mutate( count = 1)
  
  chart_db <- db %>% 
    group_by_(input$selbar) %>% 
    summarise(total = sum(count))
  
  
  
  plot1 <- ggplot(chart_db, aes(x="", y=total, fill=get(input$selbar))) +
    geom_bar(stat="identity", position = "dodge")+
    scale_fill_discrete(name = input$selbar)+
    xlab(input$selbar)
  
  return(plot1)
  
})

cont_analysis <- reactive({
  db <- tbl(con, 'cleaned_adoption_list_table') %>% 
    collect()

  
  plot2 <- ggplot(data = db, aes(x=get(input$selhist), fill=get(input$selbar))) +
    geom_density(alpha=.3)+
    scale_fill_discrete(name = input$selbar)+
    xlab(input$selhist)
  
  return(plot2)
  
})

box_analysis <- reactive({
  db <- tbl(con, 'cleaned_adoption_list_table') %>% 
    collect()

  plot3 <- ggplot(data = db, aes(x=get(input$selbar), y=get(input$selhist), fill=get(input$selbar))) + 
    geom_boxplot()+
    scale_fill_discrete(name = input$selbar)+
    ylab(input$selhist)+
    xlab(input$selbar)
  
  return(plot3)
  
})


#- OUTPUTS

output$barchart <- renderPlot(cat_analysis())

output$histchart <- renderPlot(cont_analysis())

output$boxchart <- renderPlot(box_analysis())







