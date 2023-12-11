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
  
  titlePanel("Heart Disease Shiny App Final Project"),
  
  tabsetPanel(
    tabPanel("About", fluid = TRUE,
    mainPanel(
      h4("Information about Heart Disease Dataset"),
      p("The purpose of this app is to do Data Exploration for the Heart Disease dataset looking at different categorical variables
        and different numerical variables. The other purpose of this app is to do Data Modeling to predict Heart Disease based on
        predictors within the dataset. This app is created for the Final Project for ST 558 at NCSU."),
      
      p("The source of the data comes from Kaggle, it has two different datasets corresponding to 2020 and 2022. I have chosen to 
        use the 2022 dataset. The 2022 dataset comes in the form of a csv file where all dataset is cleaned to have no missing values.
        There are a total of 246022 observations and 40 different variables, for the purposes of this app, only 20000 observations are used for Data
        Exploration and Modeling due to time constraints when Data Exploration and Data Modeling occurs. The link to the dataset can
        be found here"),
      
      
      p("About Tab - Gives general information about this Shiny App"),
      p("Data Exploration Tab - Allows you to select a specific plot and based on the plot, choose different variables to summarize. Additionally,
        allows you to look at numeric summaries of numerical variables based on levels of a chosen categorical variable."),
      p("Modeling Tab - Has three different subtabs which are Modeling Info, Model Fitting, and Prediction Tabs. Modeling Info Tab contains 
        information about the two different modeling approaches for this dataset. Model Fitting allows you to choose different model parameters
        and variables to fit for model. Prediction allows you to choose values of specific variables to make a prediction using both models.")
    )
    ),
    
    tabPanel("Data Exploration", fluid = TRUE, 
    sidebarLayout(
    sidebarPanel(
      
      
      h4("Choosing different plots to look at"),
      radioButtons("plot", "Select Plot Type", c("Scatterplot", "Histogram", "Box Plot", "Bar Plot")),
      
      conditionalPanel(
        condition = "input.plot == 'Scatterplot'",
        selectInput("x_variable", "Select X Variable", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays", "SleepHours")),
        selectInput("y_variable", "Select Y Variable", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays")),
        selectInput("categorical_variable", "Select Categorical Variable", choices = c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                                                       "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory"))
      ),
      
      conditionalPanel(
        condition = "input.plot == 'Histogram'",
        selectInput("hist_variable", "Select Variable for Histogram", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays", "SleepHours"))
      ),
      
      conditionalPanel(
        condition = "input.plot == 'Box Plot'",
        selectInput("numeric_variable", "Select Numeric Variable", choices = c("BMI", "WeightInKilograms", "HeightInMeters", "PhysicalHealthDays", "MentalHealthDays", "SleepHours")),
        selectInput("categoric_variable", "Select Categorical Variable", choices = c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                                                     "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory"))
      ), 
      
      conditionalPanel(
        condition = "input.plot == 'Bar Plot'",
        selectInput("category", "Select Categorical Variable", choices = c("HadHeartAttack", "HadAngina", "HadStroke", "HadDiabetes", "SmokerStatus",
                                                                           "RaceEthnicityCategory", "AlcoholDrinkers", "Sex", "AgeCategory"))
      ),
      
      
      h4("For numerical summaries of different variables"),
      
      
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
    tabPanel("Modeling", tabsetPanel(tabPanel("Modeling Info",
                                              
                                              
                                              
                                              
                                              
                                              
                                              ),
                                     tabPanel("Model Fitting",
                                              sidebarLayout(
                                                sidebarPanel(
                                                  
                                                sliderInput("split", "Select train percentage", value = 70, min = 50, max = 90),
                                                selectizeInput("predictors", "Select predictors you want to use", c("BMI", "WeightInKilograms", "HeightInMeters", "HadStroke", "HadAngina", 
                                                                                                                        "AlcoholDrinkers" ,"Sex", "PhysicalHealthDays", "MentalHealthDays", "SleepHours"), multiple = TRUE),
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
                                     tabPanel("Prediction",
                                              sidebarLayout(
                                                
                                                sidebarPanel(
                                                  sliderInput("bmi_value", "BMI", value = 10, min = 1, max = 100),
                                                  sliderInput("weight_value", "Weight In Kilograms", value = 10, min = 1, max = 500),
                                                  sliderInput("height_value", "Height in Meters", value = 0.1, min = 0.1, max = 5),
                                                  radioButtons("stroke_value", "Had a Stroke", c("Yes", "No"), selected = "No"),
                                                  radioButtons("angina_value", "Has Angina", c("Yes", "No"), selected = "No"),
                                                  radioButtons("alcohol_value", "Drink Alcohol?", c("Yes", "No"), selected = "No"),
                                                  selectInput("sex_value", "Sex of Individual", c("Male", "Female"), selected = "Female"),
                                                  sliderInput("physicalhealthdays_value", "Physical Health Days", value = 10, min = 1, max = 100),
                                                  sliderInput("mentalhealthdays_value", "Mental Health Days", value = 10, min = 1, max = 100),
                                                  sliderInput("sleephour_value", "Number of Hours of Sleep", value = 1, min = 1, max = 20),
                                                  actionButton("predict_results", "Predict Heart Disease")
                                                ),
                                                
                                                mainPanel(
                                                  verbatimTextOutput("prediction_logistic_model"),
                                                  verbatimTextOutput("prediction_random_forest_model")
                                                )
                                                
                                              )
                                              
                                              
                                              
                                              
                                              
                                              
        ))))

)
