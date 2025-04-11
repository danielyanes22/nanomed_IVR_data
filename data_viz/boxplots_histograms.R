library(readr)
library(ggplot2)
library(patchwork)  
library(dplyr)
library(rlang)

backend_data <- read_csv("data/unprocessed/backend_data.csv")

mol_desc_df <- backend_data[, c("MolWt", "TPSA", "MolLogP")]
formulation_df <- backend_data[, c("Z_average_nm", "zeta_potential", "PDI")]

# Function to create separate boxplot and histogram with % y-axis
# Define the theme for labels
thm <- theme(plot.tag = element_text(face = "bold", size = 14))

# Updated function to accept color
plot_box_hist_percent <- function(data, var, label, color, show_y = TRUE, log_x = FALSE) {
  var_sym <- rlang::sym(var)
  
  base_scale <- if (log_x) scale_x_log10() else scale_x_continuous()
  
  p_box <- ggplot(data, aes(x = !!var_sym)) +
    geom_boxplot(fill = color, color = "black", width = 0.4) +
    base_scale +
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
                   bins = 20, fill = color, color = "black") +
    base_scale +
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


# Placeholder colors (top 3 API bar colors)
colors <- c("#FDBAB3", "#B5E7B0", "#B3C7F9")

# Create individual plots with distinct colors
plot_molwt <- plot_box_hist_percent(mol_desc_df, "MolWt", "Molecular weight (g/mol)", color = colors[1], show_y = TRUE)
plot_logp <- plot_box_hist_percent(mol_desc_df, "MolLogP", "Calculated logP", color = colors[2], show_y = FALSE)
plot_tpsa <- plot_box_hist_percent(mol_desc_df, "TPSA", "TPSA (Å²)", color = colors[3], show_y = FALSE)

# Combine and annotate
final_plot <- (plot_molwt | plot_logp | plot_tpsa) +
  plot_annotation(
    tag_levels = "a",
    theme = theme(plot.tag = element_text(face = "bold", size = 14))
  )

final_plot

# Save the combined plot as a high-resolution PNG
ggsave(
  "figures/mol_descriptors.png",  # Filename
  plot = final_plot,  # Plot to save
  dpi = 600,  # Set the resolution to 300 DPI (high resolution)
  width = 10,  # Set the width of the image (in inches)
  height = 8,  # Set the height of the image (in inches)
  units = "in",  # Set units to inches
  device = "png"  # Save as PNG
)


#plot distribution 

# Create individual plots with distinct colors
plot_ps <- plot_box_hist_percent(formulation_df, "Z_average_nm", "Particle size (nm)",
                                 color = colors[1], show_y = TRUE, log_x = TRUE)

plot_zp <- plot_box_hist_percent(formulation_df, "zeta_potential", "Zeta potential (mV)",
                                 color = colors[2], show_y = FALSE)

plot_PDI <- plot_box_hist_percent(formulation_df, "PDI", "PDI",
                                  color = colors[3], show_y = FALSE)

# Combine and annotate
formulation_properties <- (plot_ps | plot_zp | plot_PDI) +
  plot_annotation(
    tag_levels = "a",
    theme = theme(plot.tag = element_text(face = "bold", size = 14))
  )

formulation_properties

# Save the combined plot as a high-resolution PNG
ggsave(
  "figures/formulation_properties.png",  # Filename
  plot = formulation_properties,  # Plot to save
  dpi = 600,  # Set the resolution to 300 DPI (high resolution)
  width = 10,  # Set the width of the image (in inches)
  height = 8,  # Set the height of the image (in inches)
  units = "in",  # Set units to inches
  device = "png"  # Save as PNG
)

#get summary stats for word document 
summary_stats <- formulation_df |>
  dplyr::select(Z_average_nm, zeta_potential, PDI) |>
  purrr::map_df(~ tibble(
    min = min(.x, na.rm = TRUE),
    median = median(.x, na.rm = TRUE),
    max = max(.x, na.rm = TRUE)
  ), .id = "Descriptor")

print(summary_stats)











