#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

fluidPage(
  
  titlePanel("Heart Disease App for Data Exploration and Modeling"),
  
  # Start of creating necessary tabs for each project
  tabsetPanel(
    
    # Creating first tab which is "About" tab
    tabPanel("About", fluid = TRUE,
    mainPanel(
      h4("General Information about this Shiny Application."),
      h5("Created by: Karthik Edupuganti - ST 558 NCSU, 2023 Fall Semester"),
      
      p("This app was created as a Final Project for ST 558 at NCSU. This app does two main things which are Data Exploration
        and Modeling of Heart Disease."),
      
      h4("Information about Dataset"),
      p("The source of the data comes from Kaggle, and is called Indicators of Heart Disease on Kaggle. There are two different datasets 
        corresponding to the years of 2020 and 2022. I have decided to use the 2022 dataset due to it being more recent and having more information.
        Additionally, the 2022 dataset comes in two forms where it includes observations with missing values and no missing values, the cleaned dataset was chosen
        for this project. There are a total of 246022 observations and 40 different variables, for the purposes of this app, only 20000 observations are 
        used for Data Exploration and Modeling due to the amount of time it takes for both of these tasks to complete. The main outcome variable is called
        'HadHeartAttack', which is what indicates having Heart Disease or not having Heart Disease. The link to the dataset can be found below"),
      a("https://www.kaggle.com/datasets/kamilpytlak/personal-key-indicators-of-heart-disease/data"),
      
      
      h4("Information about different tabs in this app"),
      p("About Tab - Gives general information about this Shiny App"),
      p("Data Exploration Tab - Allows you to select a specific plot and based on plot selected, choose different variables to visualize or relationships to
        visualize. Additionally, allows you to look at numeric summaries of numerical variables based on levels of a chosen categorical variable."),
      p("Modeling Tab - Has three different subtabs which are Modeling Info, Model Fitting, and Prediction Tabs. Modeling Info Tab contains 
        information about the two different modeling approaches for this dataset. Model Fitting Tab allows you to choose different model parameters
        and variables to fit for model out of some designated variables. Prediction Tab allows you to choose values of specific variables chosen in Model Fitting tab to predict
        Heart Disease or not."),
      
      img(src = "heart.jpg")
    )
    ),
    
    # Second tab which allows for data exploration
    tabPanel("Data Exploration", fluid = TRUE, 
    sidebarLayout(
    sidebarPanel(
      
      
      h4("Choose a type of plot to look at"),
      
      # Allowing to choose type of plot
      radioButtons("plot", "Select Plot Type", c("Scatterplot", "Histogram", "Box Plot", "Bar Plot")),
      
      # If scatterplot is chosen, these inputs are shown
      conditionalPanel(
        condition = "input.plot == 'Scatterplot'",
        selectInput("scatter_x_var", "Select X Variable", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays", "SleepHours")),
        selectInput("scatter_y_var", "Select Y Variable", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays")),
        selectInput("scatter_cat_var", "Select Categorical Variable", choices = c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                                                       "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory"))
      ),
      
      # If histogram is chosen, these inputs are shown
      conditionalPanel(
        condition = "input.plot == 'Histogram'",
        selectInput("hist_variable", "Select Variable for Histogram", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays", "SleepHours"))
      ),
      
      # If box plot is chosen, these inputs are shown
      conditionalPanel(
        condition = "input.plot == 'Box Plot'",
        selectInput("box_num_var", "Select Numeric Variable", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays", "SleepHours")),
        selectInput("box_cat_var", "Select Categorical Variable", choices = c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                                                     "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory"))
      ), 
      
      # If bar plot is chosen, these inputs are shown
      conditionalPanel(
        condition = "input.plot == 'Bar Plot'",
        selectInput("bar_cat_var", "Select Categorical Variable", choices = c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                                           "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory")),
        selectInput("bar_cat_var_2", "Select 2nd Categorical Variable", choices = c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                                                    "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory"))
      ),
      
      
      h4("For numerical summaries of different variables"),
      
      # Inputs to choose numeric variable and categorical variable to summarize by
      selectInput("variable_1", "Select Numeric Variable to Summarize", c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays", "SleepHours")),
      selectInput("variable_2", "Select by Category", c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                        "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory")),
     
      
      
    ),
    mainPanel(
      plotOutput("output_plot"),
      tableOutput("summaryTable")
    )
  )
),
    # Third tab for modeling
    tabPanel("Modeling", 
          
      # New tabset to create three new tabs under Modeling tab.
       tabsetPanel(
         
         # Modeling Info tab
         tabPanel("Modeling Info", 
          mainPanel(
            p("The models that will be used to predict Heart Disease are Logistic Regression and Random Forest"),
            
            p("A logistic model is a type of Generalized Linear Model which looks at modeling a response which is binary
              in nature. In this case Heart Disease is a binary response measured by 'HadHeartAttack' variable which takes on
              values 'Yes' or 'No'. Very useful in cases where linear regression fails due to binary nature of variable trying
              to be predicted. In our case, it would model probability of having Heart Disease based on specific predictors. The
              function never goes below 0 and 1. The logistic regression also does not have a closed form solution so maximum likelihood
              is used to fit parameter values. Logistic Regression is very interpretable and is different from a linear regression model,
              where changes in a particular predictive variable represents log-odds of a success. The main drawback to a logistic regression is
              that it is primarily used in binary response usecases and not that valuable in scenarios where response has multiple levels of response."),
            
            p("A random forest model is a nonlinear type of method used for regression and classification purposes. Opposed to normal classification
              or regression trees, it is a type of ensemble method which boosts prediction of response in exchange for loss in interpretability.
              A random forest looks at using variable importance measures to look at most important variables contributing to particular response. It is 
              similar to bagging trees method due to boostrap aggregation, but instead does not use all predictors and uses a random subset of predictors for each tree.
              A random forest model is more versatile as it can be used in many different scenarios compared to the logistic regression, but loses interpretability.")
                )      
                   ),
          
          # Model Fitting tab 
         tabPanel("Model Fitting",
              sidebarLayout(
                  sidebarPanel(
                      
                    # Choosing specific parameters for models                            
                    sliderInput("split", "Select train percentage", value = 70, min = 50, max = 90),
                    selectizeInput("predictors", "Select predictors you want to use", c("BMI", "WeightInKilograms", "HeightInMeters", "HadStroke", "HadAngina", 
                                                                                      "AlcoholDrinkers" ,"Sex", "PhysicalHealthDays", "MentalHealthDays", "SleepHours"), 
                                                                                       multiple = TRUE),
                    selectInput("tuning", "Select value of tuning for mtry", c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)),
                    selectInput("validation", "Select number of times to cross-validate", c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)),
                     actionButton("fit_models", "Fit Models")
                               ),
                  mainPanel(
                    verbatimTextOutput("logistic_confusion_matrix"),
                    verbatimTextOutput("randomforest_confusion_matrix")
                                                                       )    
                                                                        )  
    ),
        # Prediction tab
        tabPanel("Prediction",
                 sidebarLayout(
                          sidebarPanel(
                            
                          # Inputs for specific variables for this model
                          sliderInput("bmi_value", "BMI", value = 1, min = 1, max = 50),
                          sliderInput("weight_value", "Weight In Kilograms", value = 1, min = 1, max = 300),
                          sliderInput("height_value", "Height in Meters", value = 0.1, min = 0.1, max = 5),
                          radioButtons("stroke_value", "Had a Stroke", c("Yes", "No"), selected = "No"),
                          radioButtons("angina_value", "Has Angina", c("Yes", "No"), selected = "No"),
                          radioButtons("alcohol_value", "Drink Alcohol?", c("Yes", "No"), selected = "No"),
                          selectInput("sex_value", "Sex of Individual", c("Male", "Female"), selected = "Female"),
                          sliderInput("physicalhealthdays_value", "Physical Health Days", value = 1, min = 1, max = 100),
                          sliderInput("mentalhealthdays_value", "Mental Health Days", value = 1, min = 1, max = 100),
                          sliderInput("sleephour_value", "Number of Hours of Sleep", value = 1, min = 1, max = 50),
                          actionButton("predict_results", "Predict Heart Disease")
                                 
                                                                           ),
                          # Outputting results for predicted values of chosen variables.
                          mainPanel(
                                  verbatimTextOutput("prediction_logistic_model"),
                                  verbatimTextOutput("prediction_random_forest_model")
                                                                                    )
                                                
         )
        ))))

)
