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
)
