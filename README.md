# ST558-Final-Project

The Shiny App here was created for ST 558 NCSU Fall 2023 class as a Final Project. This app will use many different features in the course such as data visualization, data cleaning, 
and data modeling. This app uses a dataset which contain information about Heart Disease. There are three main tabs which are the About, Data Exploration, and Modeling tabs. The 
About Tab talks more about the Shiny App and dataset. The Data Exploration allows for you to select a type of plot and visualize different variables or relationships based on the plot 
selected. The Modeling tab allows you to model Heart Disease with several predetermined predictor variables. The number and choice of predictor variables are allowed to be chosen in this tab along with choice of selecting some tuning measures for the model. Additionally, you can make prediction using these built models based on values you give to the predictor variables.

List of packages:
* caret
* tidyverse
* randomForest
* shiny
* shinythemes

Code to install packages:
install.packages(c("caret", "tidyverse", "randomForest", "shiny", "shinythemes"))

Code to run app:
shiny::runGitHub(repo = "ST558-Final-Project", username = "Eiryu52", ref = "main")
