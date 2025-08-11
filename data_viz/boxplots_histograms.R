library(readr)
library(ggplot2)
library(patchwork)  
library(dplyr)
library(rlang)

backend_data <- read_csv("data/unprocessed/backend_data.csv")

mol_desc_df <- backend_data[, c("MolWt", "TPSA", "MolLogP")]
formulation_df <- backend_data[, c("particle_size_nm", "zeta_potential", "PDI")]


# Define the theme for labels
thm <- theme(plot.tag = element_text(face = "bold", size = 14))

# Function to make a violin plot with overlaid points
plot_violin_points <- function(data, var, label, fill_color, point_color, log_x = FALSE) {
  var_sym <- rlang::sym(var)
  
  base_scale <- if (log_x) scale_y_log10() else scale_y_continuous()
  
  ggplot(data, aes(x = "", y = !!var_sym)) +
    geom_violin(fill = fill_color, color = "black", width = 0.8, alpha = 0.7) +
    geom_jitter(color = point_color, width = 0.1, size = 2, alpha = 0.6) +
    labs(x = NULL, y = label) +
    base_scale +
    theme_minimal() +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.title.y = element_text(face = "bold", size = 14),
      axis.text.y = element_text(face = "bold", size = 12),
      panel.grid = element_blank()
    )
}

# generate plots for molwt, logp, and tpsa
plot_molwt <- plot_violin_points(mol_desc_df, 
                                 "MolWt", "Molecular weight (g/mol)", 
                                 fill_color = "#FDBAB3", 
                                 point_color = "#E6550D")
plot_logp  <- plot_violin_points(mol_desc_df, 
                                 "MolLogP", 
                                 "Calculated logP", 
                                 fill_color = "#B5E7B0", 
                                 point_color = "#31A354")

plot_tpsa  <- plot_violin_points(mol_desc_df, 
                                 "TPSA", 
                                 "TPSA (Å²)", 
                                 fill_color = "#B3C7F9", 
                                 point_color = "#3182BD")

# Combine and annotate and save
final_plot <- (plot_molwt | plot_logp | plot_tpsa) +
  plot_annotation(
    tag_levels = "a",
    theme = theme(plot.tag = element_text(face = "bold", size = 14))
  )

final_plot


ggsave(
  "figures/mol_descriptors.png",  # Filename
  plot = final_plot,  # Plot to save
  dpi = 600,  # Set the resolution to 300 DPI (high resolution)
  width = 10,  # Set the width of the image (in inches)
  height = 8,  # Set the height of the image (in inches)
  units = "in",  # Set units to inches
  device = "png"  # Save as PNG
)


#plot ps, zp, and pdi

plot_ps <- plot_violin_points(
  formulation_df, 
  "particle_size_nm", 
  "Particle size (nm)", 
  fill_color = colors[1], 
  point_color = "#E6550D",  # choose any contrasting point color
  log_x = TRUE
)

plot_zp <- plot_violin_points(
  formulation_df, 
  "zeta_potential", 
  "Zeta potential (mV)", 
  fill_color = colors[2], 
  point_color = "#31A354"
)

plot_PDI <- plot_violin_points(
  formulation_df, 
  "PDI", 
  "PDI", 
  fill_color = colors[3], 
  point_color = "#3182BD"
)

# Combine, annotate and save 
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
  dplyr::select(particle_size_nm, zeta_potential, PDI) |>
  purrr::map_df(~ tibble(
    min = min(.x, na.rm = TRUE),
    median = median(.x, na.rm = TRUE),
    max = max(.x, na.rm = TRUE)
  ), .id = "Descriptor")

print(summary_stats)