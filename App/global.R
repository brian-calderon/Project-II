library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(data.table)
# table_path = "C:/Users/brian/OneDrive/Documents/Academics/Courses/NYC Bootcamp Machine Learning/Projects/Project-II/GF_Inline_Health_Tracker/Inline_Cpk/data/"
# table <- read.csv(file = paste(table_path,"09-05-22_T6 Inline Data_Anonymized.csv", sep =""))

# To deploy (or re-deploy) app on shiny.io you need to:
# 1) Change the working directory (Tools->Global options->General) to the App directory. Then you can re-deploy.
# 2) Remove any variables with local PC paths. All paths must be referenced wrt to the app directory only.
table <- read.csv(file = "data/09-05-22_T6 Inline Data_Anonymized.csv")

table = table %>%
          # Select only relevant columns
          select(c(1,3:7,5,11:18)) %>% 
          # Renaming columns
          rename("X" = "UCSFlashX", "Y" = "UCSFlashY","Date-Time" = "Timestamp_Proc",
         "Meas_Tool" = "Mtool") %>%
          # Handling missing values in the parm data.
          mutate( Value = replace(Value,is.na(Value),0)) %>%
          # Converting Date-Time to a DateTime format
          mutate(`Date-Time` = as.POSIXct(`Date-Time`,format="%m/%d/%Y %H:%M",tz=Sys.timezone()))

cpk_monthly = table %>%
                # Extract month and year from Date-Time column
                mutate(Month = strftime(`Date-Time`, format = "%b"), 
                       Year = strftime(`Date-Time`, format = "%y"),
                       Month_Year = strftime(`Date-Time`, format = "%b %y")) %>%
                group_by(., Step, Parameter, Month, Year, Month_Year, USL, LSL) %>%
                summarize(Count = n(), Std = sd(Value), Avg = mean(Value)) %>%
                # Calculate CPK
                mutate(CPU = (USL - Avg)/(3*Std),CPL = (Avg - LSL)/(3*Std), CPK = min(CPU,CPL))

cpk_all = cpk_monthly %>%
            group_by(Step) %>%
            summarize(Avg_Cpk = mean(CPK)) %>%
            right_join(cpk_monthly, by = "Step") %>%
            distinct(Step, .keep_all = TRUE) %>%
            select(Step, Avg_Cpk, Parameter, Year, USL, LSL)




