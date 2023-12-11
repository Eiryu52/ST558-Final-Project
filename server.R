#
# Karthik Edupuganti
# 12/11/2023
# Server File for Shiny App
#




library(caret)
library(tidyverse)
library(randomForest)
library(shiny)



function(input, output, session) {

  set.seed(620)
  Heart_Data_Reduced <- read.csv("Heart_Data_Reduced.csv", sep = ',')

  # Rendering plots using if/else logic based on input from UI.
  output$output_plot <- renderPlot({
    if (input$plot == 'Scatterplot') {
 
      ggplot(Heart_Data_Reduced , aes_string(x = input$scatter_x_var, y = input$scatter_y_var)) +
        geom_point(aes_string(col = input$scatter_cat_var)) + ggtitle("Scatterplot between two Numerical Variables")
      
    } else if (input$plot == 'Histogram') {
   
      ggplot(Heart_Data_Reduced , aes_string(x = input$hist_variable)) +
        geom_histogram() + ggtitle("Histogram to show distribution of Numerical Variables")
      
    } else if (input$plot == 'Box Plot') {
      
      ggplot(Heart_Data_Reduced , aes_string(x = input$box_cat_var, y = input$box_num_var)) +
        geom_boxplot() + ggtitle("Boxplots for different Numerical Variables")
      
    } else if (input$plot == 'Bar Plot') {
      
      
      ggplot(Heart_Data_Reduced, aes_string(x = input$bar_cat_var, fill = input$bar_cat_var_2)) + geom_bar(position = "dodge") +
        ggtitle("Bar Plot for Categorical Variables")
      
    }
    
  
  })
  
    # Rendering summaries for chosen numerical variable for levels of chosen categorical variable.
    output$summaryTable <- renderTable({
      Heart_Data_Reduced %>% select(input$variable_2, input$variable_1) %>% 
        group_by(!!sym(input$variable_2)) %>% 
        summarize(mean = mean(!!sym(input$variable_1)), median = median(!!sym(input$variable_1)), min = min(!!sym(input$variable_1)), 
                   max = max(!!sym(input$variable_1)), count = n())
      

    })
   
    # Creating reactive value to store logistic model and random forest model
    # Allows us to call the models that is built in the observeEvent function below later on.
    Logistic_Model <- reactiveVal(NULL)  
    Random_Forest_Model <- reactiveVal(NULL)
    
    
    # Fitting model with the specific inputs from UI.
    observeEvent(input$fit_models, {
      
      # Train/Test Splits
      train_split <- input$split / 100
      index <- createDataPartition(Heart_Data_Reduced$HadHeartAttack, p = train_split, list = FALSE)
      train_heart <- Heart_Data_Reduced[index,]
      test_heart <- Heart_Data_Reduced[-index,]
      
      # Tuning parameters
      ctrl <- trainControl(method = "cv", number = as.numeric(input$validation))
      grid <- expand.grid(mtry = as.numeric(input$tuning))
      
      # Creating logistic model
      model_logistic <- train(as.formula(paste("HadHeartAttack ~ ", paste(input$predictors, collapse = "+"))), 
                              data = train_heart, method = "glm", family = "binomial", 
                              trControl = ctrl)
      
      # Creating random forest model
      model_rf <- train(as.formula(paste("HadHeartAttack ~ ", paste(input$predictors, collapse = "+"))), data = train_heart,
                             tuneGrid = grid, trControl = ctrl)
      
      # Calling earlier reactiveVal functions to store models
      Logistic_Model(model_logistic)
      Random_Forest_Model(model_rf)
      
      #Creating confusion matrix for Logistic Model
      logistic_test_cm <- confusionMatrix(as.factor(predict(Logistic_Model(), newdata = test_heart)), as.factor(test_heart$HadHeartAttack))
      
      #Creating confusion matrix for Random Forest Model
      randomforest_test_cm <- confusionMatrix(as.factor(predict(Random_Forest_Model(), newdata = test_heart)), as.factor(test_heart$HadHeartAttack))
      
      #Outputting summary for Logistic Model
      output$summaryLogistic <- renderPrint({summary(Logistic_Model())})
      
      #Outputting information related to variable importance in Random Forest
      output$variableimportanceRF <- renderPrint({varImp(Random_Forest_Model())})
      output$variableimportanceplotRF <- renderPlot({varImpPlot(Random_Forest_Model()$finalModel, main = "Variance Importance Plot for Heart Disease")})
      
      #Outputting confusion matrices to compare Logistic and Random Forest together.
      output$logistic_confusion_matrix <- renderPrint({logistic_test_cm})
      output$randomforest_confusion_matrix <- renderPrint({randomforest_test_cm})
      
      
    })
    
    # Creating a reactive function to predict on Logistic Model
    # Takes input from Prediction Tab UI and stores in a dataframe
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
      
      # Creating a prediction using Logistic Model created from Model Fitting tab.
      heartdisease_prediction_logistic <- predict(Logistic_Model(), newdata = predict_dataframe)
      heartdisease_prediction_logistic
    })
    
    # Creating a reactive function to predict on Random Forest Model
    # Takes input from Prediction Tab UI and stores in a dataframe
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
      
      # Creating a prediction using Random Forest Model created from Model Fitting tab.
      heartdisease_prediction_rf <- predict(Random_Forest_Model(), newdata = predict_dataframe)
      heartdisease_prediction_rf
    })
    
    # observeEvent function to show result of prediction based on changing parameters in prediction tab.
    observeEvent(input$predict_results, {
      
      output$prediction_logistic_model <- renderPrint({new_prediction_logistic()})
      output$prediction_random_forest_model <- renderPrint({new_prediction_rf()})
      
      
    })
    
  
}



      
