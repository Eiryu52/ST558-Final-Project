library(caret)
library(tidyverse)
library(shiny)



function(input, output, session) {

  Heart_Data <- read.csv("heart_2022_no_nans.csv", sep = ',')
  Heart_Data_Reduced <- head(Heart_Data, 20000)
  
  
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
    
    observeEvent(input$fit_models, {
      
      train_split <- input$split / 100
      index <- createDataPartition(Heart_Data_Reduced$HadHeartAttack, p = 0.7, list = FALSE)
      train_heart <- Heart_Data_Reduced[index,]
      test_heart <- Heart_Data_Reduced[-index,]
      
      ctrl <- trainControl(method = "cv", number = as.numeric(input$validation))
      grid <- expand.grid(mtry = as.numeric(input$tuning))
      
      
      Logistic_Model <- train(as.formula(paste("HadHeartAttack ~ ", paste(input$predictors, collapse = "+"))), 
                              data = train_heart, method = "glm", family = "binomial", 
                              trControl = ctrl)
      
      Random_Forest <- train(as.formula(paste("HadHeartAttack ~ ", paste(input$predictors, collapse = "+"))), data = train_heart,
                             tuneGrid = grid, trControl = ctrl)
      
      logistic_test_cm <- confusionMatrix(as.factor(predict(Logistic_Model, newdata = test_heart)), as.factor(test_heart$HadHeartAttack))
      
      randomforest_test_cm <- confusionMatrix(as.factor(predict(Random_Forest, newdata = test_heart)), as.factor(test_heart$HadHeartAttack))
      
      output$logistic_confusion_matrix <- renderPrint({logistic_test_cm})
      output$randomforest_confusion_matrix <- renderPrint({randomforest_test_cm})
    })
    
                   
  
}

      
