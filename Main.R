# Main script to run the analysis -----------------------------------------

# Preferably, before you run this script restart your R session: 
# Ctrl+Shift+F10 if you are using RStudio

# Packages
library(ggplot2) # To make graphs

# 1 Simulating the data

source("analysis/data_simulation.R")

# 2 Linear regression analysis

source("analysis/linear_regression.R")

# 4 Session info

capture.output(sessionInfo(), file = "Session_Info.txt")