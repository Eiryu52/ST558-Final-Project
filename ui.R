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
    tabPanel("Modeling", tabsetPanel(tabPanel("Modeling Info"),
                                     tabPanel("Model Fitting"),
                                     tabPanel("Prediction"))))

)
