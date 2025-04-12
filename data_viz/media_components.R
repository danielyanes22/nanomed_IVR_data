library(tidyverse)

# Load data
media_components <- read.csv("data/unprocessed/media_components.csv")

# Calculate % of database and reorder
component_freq <- media_components %>%
  count(component_name, name = "Frequency") %>%
  mutate(
    Percent = (Frequency / sum(Frequency)) * 100,
    Media_component = fct_reorder(component_name, Percent, .desc = TRUE)  # Reorder factor
  )


component_freq <- component_freq %>%
  rename(Media_component = component_name)

plot_media_components <- ggplot(component_freq, aes(x = Media_component, y = Percent, fill = Media_component)) +
  geom_col(color = "black", width = 0.7) +
  geom_text(aes(
    label = paste0(round(Percent, 1)), 
    color = "black"
  ),
  vjust = -0.3,
  nudge_y = 0.5,
  size = 3,
  fontface = "bold",
  show.legend = FALSE) +
  scale_color_identity() +
  scale_y_continuous(
    labels = scales::label_number(scale = 1),
    expand = expansion(mult = c(0, 0.05))
  ) +
  labs(
    x = "Media component",
    y = "% of database"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 0.9, face = "bold"),
    axis.text.y = element_text(face = "bold"),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = "bold")
  )

plot_media_components


ggsave(
  "figures/media_components.png",  # Filename
  plot = plot_media_components,  # Plot to save
  dpi = 600,  # Set the resolution to 300 DPI (high resolution)
  width = 10,  # Set the width of the image (in inches)
  height = 8,  # Set the height of the image (in inches)
  units = "in",  # Set units to inches
  device = "png"  # Save as PNG
)





