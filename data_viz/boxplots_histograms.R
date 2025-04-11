library(readr)
library(ggplot2)
library(patchwork)  
library(dplyr)

backend_data <- read_csv("data/unprocessed/backend_data.csv")

mol_desc_df <- backend_data[, c("MolWt", "TPSA", "MolLogP")]
formulation_df <- backend_data[, c("Z_average_nm", "zeta_potential", "PDI")]

# Function to create boxplot above histogram with % y-axis
library(ggplot2)
library(patchwork)
library(dplyr)
library(rlang)

# Function to create boxplot above histogram with % y-axis
plot_box_hist_percent <- function(data, var, label, show_y = TRUE) {
  var_sym <- rlang::sym(var)
  
  p_box <- ggplot(data, aes(x = !!var_sym)) +
    geom_boxplot(fill = "skyblue", color = "black", width = 0.4) +
    theme_minimal() +
    theme(
      axis.title.x = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      plot.margin = margin(2, 5, 2, 5)
    )
  
  p_hist <- ggplot(data, aes(x = !!var_sym)) +
    geom_histogram(aes(y = after_stat(count / sum(count) * 100)), 
                   bins = 20, fill = "skyblue", color = "black") +
    labs(x = label, y = if (show_y) "% of database" else NULL) +
    theme_minimal() +
    theme(
      axis.title.x = element_text(face = "bold"),
      axis.title.y = if (show_y) element_text(face = "bold") else element_blank(),
      axis.text.x = element_text(face = "bold"),
      axis.text.y = if (show_y) element_text(face = "bold") else element_blank(),
      axis.ticks.y = element_blank(),
      plot.margin = margin(0, 5, 5, 5)
    )
  
  p_box / p_hist + plot_layout(heights = c(0.2, 0.8))
}

# Define the theme
thm <- theme(plot.tag = element_text(face = "bold", size = 14))

# Generate plots with y-axis label only on the first
plot_molwt <- plot_box_hist_percent(mol_desc_df, "MolWt", "Molecular weight (g/mol)", show_y = TRUE)
plot_logp <- plot_box_hist_percent(mol_desc_df, "MolLogP", "Calculated logP", show_y = FALSE)
plot_tpsa <- plot_box_hist_percent(mol_desc_df, "TPSA", "TPSA (Å²)", show_y = FALSE)

# Combine the plots in one row and add tag labels A, B, C at the top (no labels for the bottom row)
# Wrap the top row plots and add annotations
# Use wrap_plots to combine the plots in one row
top_row <- wrap_plots(
  plot_molwt, plot_logp, plot_tpsa,
  nrow = 1, ncol = 3
) + plot_annotation(
  tag_levels = "a",  # Use lowercase tags (a, b, c)
  tag_prefix = "", tag_suffix = "",  # Clean labels
  theme = thm
)

# Final plot (since there's no bottom plot, we use top_row)
final_plot <- top_row

# Display the final plot
final_plot



