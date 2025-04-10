library(readr)
library(ggplot2)
library(dplyr)
library(scales)
library(ggrepel)

APIs <- read_csv("data/processed/API_percent.csv")
release_methods <- read_csv("data/processed/method_percent.csv")

# Convert to character
APIs$API_name <- as.character(APIs$API_name)

# Rename column
colnames(APIs)[colnames(APIs) == "API_name"] <- "API"

# Specify hole size
hsize <- 2



API_plot

