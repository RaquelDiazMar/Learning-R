# File:     02_04_Navigating.R
# Project:  LearningR

# INSTALL AND LOAD PACKAGES ################################

# Load base packages manually
library(datasets)  # For example datasets

# LOAD AND PREPARE DATA ####################################

?iris
df <- iris
head(df)

# ANALYZE DATA #############################################

hist(df$Sepal.Width, 
  main = "Histogram of Sepal Width",
  xlab = "Sepal Width (in cm)")

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
detach("package:datasets", unload = TRUE)  # For base

# Clear plots
dev.off()  # But only if there IS a plot

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)
