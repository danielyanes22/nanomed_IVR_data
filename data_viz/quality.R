library(dplyr)
library(ggplot2)
library(patchwork)
library(readr)

quality_reporting <- read_csv("data/quality_reporting.csv", skip = 1)

# Define pastel fill palette
pastel_palette <- c("#AFCBFF", "#FFB6B9", "#BFD8B8", "#FFD6A5")

# Function to generate quality barplots
plot_quality_bar <- function(data_col, title, fill_color) {
  df <- data.frame(Value = data_col) %>%
    filter(!is.na(Value)) %>%
    mutate(Value = trimws(as.character(Value))) %>%
    count(Value) %>%
    mutate(Percent = n / sum(n) * 100)
  
  ggplot(df, aes(x = reorder(Value, -Percent), y = Percent, fill = Value)) +
    geom_col(color = "black", width = 0.7) +
    geom_text(aes(label = round(Percent, 1)), vjust = -0.3, fontface = "bold", size = 3) +
    scale_fill_manual(values = pastel_palette) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
    labs(x = NULL, y = "Percentage (%)", title = title) +
    theme_minimal() +
    theme(
      legend.position = "none",
      axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"),
      axis.text.y = element_text(face = "bold"),
      axis.title.y = element_text(face = "bold"),
      plot.title = element_text(face = "bold")
    )
}

# Generate individual barplots using column names or positions
# Update column names as needed below if different
p1 <- plot_quality_bar(quality_reporting[[4]], "Reporting Quality", pastel_palette[1])
p2 <- plot_quality_bar(quality_reporting[[5]], "Performance Bias (1)", pastel_palette[2])
p3 <- plot_quality_bar(quality_reporting[[6]], "Performance Bias (2)", pastel_palette[3])
p4 <- plot_quality_bar(quality_reporting[[7]], "Detection Bias", pastel_palette[4])

# Combine in 2x2 layout
(p1 | p2) / (p3 | p4) +
  plot_annotation(
    title = "Quality Appraisal Summary",
    theme = theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5))
  )
