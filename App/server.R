#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
## server.R ##

function(input, output) {
  # Reactive function used to filter, group and summarize the data
  # only once so that you use this data later for plotting.
  # Note that reactive functions, like any other function need to return an object! 
  # So you need a "summarize" somewhere in the function, if you only have a filter -> group
  # then it won't work!
  # clean_table <- reactive({
  #   table %>%
  #     filter(Step == input$step) %>%
      # # Select only relevant columns
      # select(c(1,3:5,10:12,19,20,23:24,26:29)) %>%
      # # Renaming columns
      # rename("X" = "UCSFlashX", "Y" = "UCSFlashY","Date-Time" = "Timestamp_Proc", "Step" = "Level",
      #        "Meas_Tool" = "MTool") %>%
      # # Handling missing values in the parm data.
      # mutate( Value = replace(Value,is.na(Value),0)) %>%
      # group_by(., Step, Parameter, USL, LSL) %>%
      # summarize(Count = n(), Std = sd(Value), Avg = mean(Value))
  # })
  # count is the output object created that contains the plot of the # of flights.
  # This object is then passed to the input (ui.R)
  output$cpk_plot <- renderPlot({
    # We call the the reactive function we created before which outputs a
    # pre-summarized df with the users input choices.
    
    if(input$step == "All")
      {
      p = cpk_all %>%
        ggplot(aes(Step, Avg_Cpk, fill = Year)) +
        geom_col(position = "dodge") +
        geom_hline(yintercept=1.67, linetype="dashed", color = "red") +
        geom_hline(yintercept=1.0, linetype="dashed", color = "red") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    }
    else
    {
        p = cpk_monthly %>%
              filter(Step == input$step) %>%
              ggplot(aes(Step, CPK, fill = Month_Year)) + 
              geom_col(position = "dodge") +
              geom_hline(yintercept=1.67, linetype="dashed", color = "red") + 
              geom_hline(yintercept=1.0, linetype="dashed", color = "red") +
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    }
  p
  })
  
  # table is the output object created that contains the table used in plotting the inline cpk.
  # This object is then passed to the input (ui.R)
  output$cpk_table <- renderTable({
    # cpk_monthly
    if(input$step == "All")
    {
      p = cpk_all
    }
    else
    {
      p = cpk_monthly %>%
            filter(Step == input$step)
    }
    
    p
  })
}
