#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
## ui.R ##

# See the documentation at http://rstudio.github.io/shinydashboard/ for more
# information

library(shinydashboard)

dashboardPage(
  dashboardHeader(title='GF Inline CPK'),
  
  dashboardSidebar(
    # The user panel uses an image in the www folder. Always place images in that folder.
    sidebarUserPanel("Brian C",
                     image ="./GF_Logo.jpg"),
    sidebarMenu(
      menuItem("Plots", tabName = "plots", icon = icon("map")),
      menuItem("Data", tabName = "data", icon = icon("database"))
    ),
    selectizeInput(inputId='step',label='Mfg_Step',
                   choices=c("All", unique(table$Step)))#,
    # selectizeInput(inputID = 'month', label ='Month',
    #                choices=unique(table$Date-Time))
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = 'plots',
              tabsetPanel(
                tabPanel("Counts Plot",
                         fluidRow(
                           column(5, plotOutput("cpk"))
                         )
                  )
              )
      ),
      tabItem(tabName = 'data', 
              tableOutput('cpk_table')
      )
    )
  )
)
