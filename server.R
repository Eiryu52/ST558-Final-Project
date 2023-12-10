library(caret)
library(tidyverse)
library(shiny)


Heart_Data <- read.csv("heart_2022_no_nans.csv", sep = ',')
Heart_Data_Reduced <- head(Heart_Data, 20000)
function(input, output, session) {


  
  
  output$output_plot <- renderPlot({
    if (input$plot == 'Scatterplot') {
 
      ggplot(Heart_Data_Reduced , aes_string(x = input$x_variable, y = input$y_variable)) +
        geom_point(aes_string(col = input$categorical_variable))
      
    } else if (input$plot == 'Histogram') {
   
      ggplot(Heart_Data_Reduced , aes_string(x = input$hist_variable)) +
        geom_histogram()
      
    } else if (input$plot == 'Box Plot') {
      
      ggplot(Heart_Data_Reduced , aes_string(x = input$categoric_variable, y = input$numeric_variable)) +
        geom_boxplot()
      
    } else if (input$plot == 'Bar Plot') {
      
      
      ggplot(Heart_Data_Reduced, aes_string(x = input$category)) + geom_bar()
      
    }
    
  
  })
  
    output$summaryTable <- renderTable({
      Heart_Data_Reduced %>% select(input$variable_2, input$variable_1) %>% group_by(!!sym(input$variable_2)) %>% summarize(mean = mean(!!sym(input$variable_1)), 
                                                                                          median = median(!!sym(input$variable_1)), min = min(!!sym(input$variable_1)), 
                                                                                          max = max(!!sym(input$variable_1)), count = n())
      

    })
    
    
    
                   
  
}

      
