library(caret)
library(tidyverse)
library(shiny)



function(input, output, session) {

  Heart_Data <- read.csv("heart_2022_no_nans.csv", sep = ',')
  Heart_Data_Reduced <- head(Heart_Data, 20000)
  
  
  output$output_plot <- renderPlot({
    if (input$plot == 'Scatterplot') {
 
      ggplot(Heart_Data_Reduced , aes_string(x = input$scatter_x_var, y = input$scatter_y_var)) +
        geom_point(aes_string(col = input$scatter_cat_var))
      
    } else if (input$plot == 'Histogram') {
   
      ggplot(Heart_Data_Reduced , aes_string(x = input$hist_variable)) +
        geom_histogram()
      
    } else if (input$plot == 'Box Plot') {
      
      ggplot(Heart_Data_Reduced , aes_string(x = input$box_cat_var, y = input$box_num_var)) +
        geom_boxplot()
      
    } else if (input$plot == 'Bar Plot') {
      
      
      ggplot(Heart_Data_Reduced, aes_string(x = input$bar_cat_var, fill = input$bar_cat_var_2)) + geom_bar(position = "dodge")
      
    }
    
  
  })
  
    output$summaryTable <- renderTable({
      Heart_Data_Reduced %>% select(input$variable_2, input$variable_1) %>% group_by(!!sym(input$variable_2)) %>% summarize(mean = mean(!!sym(input$variable_1)), 
                                                                                          median = median(!!sym(input$variable_1)), min = min(!!sym(input$variable_1)), 
                                                                                          max = max(!!sym(input$variable_1)), count = n())
      

    })
   
  logistic_model <- reactiveVal(NULL)  
  random_forest_model <- reactiveVal(NULL)
    
  
    observeEvent(input$fit_models, {
      
      train_split <- input$split / 100
      index <- createDataPartition(Heart_Data_Reduced$HadHeartAttack, p = train_split, list = FALSE)
      train_heart <- Heart_Data_Reduced[index,]
      test_heart <- Heart_Data_Reduced[-index,]
      
      ctrl <- trainControl(method = "cv", number = as.numeric(input$validation))
      grid <- expand.grid(mtry = as.numeric(input$tuning))
      
      
      Logistic_Model <- train(as.formula(paste("HadHeartAttack ~ ", paste(input$predictors, collapse = "+"))), 
                              data = train_heart, method = "glm", family = "binomial", 
                              trControl = ctrl)
      
      Random_Forest <- train(as.formula(paste("HadHeartAttack ~ ", paste(input$predictors, collapse = "+"))), data = train_heart,
                             tuneGrid = grid, trControl = ctrl)
      
      logistic_model(Logistic_Model)
      random_forest_model(Random_Forest)
      
      logistic_test_cm <- confusionMatrix(as.factor(predict(logistic_model(), newdata = test_heart)), as.factor(test_heart$HadHeartAttack))
      
      randomforest_test_cm <- confusionMatrix(as.factor(predict(random_forest_model(), newdata = test_heart)), as.factor(test_heart$HadHeartAttack))
      
      output$logistic_confusion_matrix <- renderPrint({logistic_test_cm})
      output$randomforest_confusion_matrix <- renderPrint({randomforest_test_cm})
      
      
    })
    
    new_prediction_logistic <- reactive({
      
      predict_dataframe <- data.frame(
        BMI = input$bmi_value,
        WeightInKilograms = input$weight_value,
        HeightInMeters = input$height_value,
        HadStroke = input$stroke_value,
        HadAngina = input$angina_value,
        AlcoholDrinkers = input$alcohol_value,
        Sex = input$sex_value,
        PhysicalHealthDays = input$physicalhealthdays_value,
        MentalHealthDays = input$mentalhealthdays_value,
        SleepHours = input$sleephour_value
      )
      
      heartdisease_prediction_logistic <- predict(logistic_model(), newdata = predict_dataframe)
      heartdisease_prediction_logistic
    })
    
    new_prediction_rf <- reactive({
      
      predict_dataframe <- data.frame(
        BMI = input$bmi_value,
        WeightInKilograms = input$weight_value,
        HeightInMeters = input$height_value,
        HadStroke = input$stroke_value,
        HadAngina = input$angina_value,
        AlcoholDrinkers = input$alcohol_value,
        Sex = input$sex_value,
        PhysicalHealthDays = input$physicalhealthdays_value,
        MentalHealthDays = input$mentalhealthdays_value,
        SleepHours = input$sleephour_value
      )
      
      heartdisease_prediction_rf <- predict(random_forest_model(), newdata = predict_dataframe)
      heartdisease_prediction_rf
    })
    
    observeEvent(input$predict_results, {
      
      output$prediction_logistic_model <- renderPrint({new_prediction_logistic()})
      output$prediction_random_forest_model <- renderPrint({new_prediction_rf()})
      
      
    })
    
  
}



      
