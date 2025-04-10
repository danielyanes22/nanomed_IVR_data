library(readr)
library(ggplot2)
library(dplyr)
library(scales)
library(ggrepel)
library(forcats)
library(patchwork)

# Load and prep data
APIs <- read_csv("data/processed/API_percent.csv") %>%
  mutate(API = as.character(API_name)) %>%
  select(API, Percent)

# Reorder API factor levels by descending percent
APIs <- APIs %>%
  mutate(API = fct_reorder(API, Percent, .desc = TRUE))

# Plot as histogram (bar plot)
plot_APIs <- ggplot(APIs, aes(x = API, y = Percent, fill = API)) +
  geom_col(color = "black", width = 0.7) +
  geom_text(aes(
    label = paste0(round(Percent, 1)),  # Round to 1 decimal place
    color = "black"
  ),
  vjust = -0.3,           # Adjust vertical positioning to move labels further up
  nudge_y = 0.5,         # Additional upward nudge
  size = 3,
  fontface = "bold",
  show.legend = FALSE) +
  scale_color_identity() +
  scale_y_continuous(
    labels = scales::label_number(scale = 1),
    expand = expansion(mult = c(0, 0.05))  # Add more space above bars
  ) +
  labs(
    x = "Compound",
    y = "% of database",
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 0.9, face = "bold"),  
    axis.text.y = element_text(face = "bold"),  
    axis.title.x = element_text(face = "bold"),  
    axis.title.y = element_text(face = "bold")   
  ) + 
  ggtitle("a")


#plot for release_method frequency data 
release_methods <- read_csv("data/processed/method_percent.csv") %>%
  mutate(release_method = as.character(release_method)) %>%
  select(release_method, Percent)


# Reorder API factor levels by descending percent
release_methods <- release_methods %>%
  mutate(release_method = fct_reorder(release_method, Percent, .desc = TRUE))

# Plot for release_methods
plot_methods <- ggplot(release_methods, aes(x = release_method, y = Percent, fill = release_method)) +
  geom_col(color = "black", width = 0.7) +
  geom_text(aes(
    label = paste0(round(Percent, 1)),  # Round to 1 decimal place
    color = "black"
  ),
  vjust = -0.3,           # Adjust vertical positioning to move labels further up
  nudge_y = 0.5,          # Additional upward nudge
  size = 3,
  fontface = "bold",
  show.legend = FALSE) +
  scale_color_identity() +
  scale_y_continuous(
    labels = scales::label_number(scale = 1),
    expand = expansion(mult = c(0, 0.05))  # Add more space above bars
  ) +
  labs(
    x = "Release Method",
    y = "") +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 60, hjust = 1, vjust = 0.9, face = "bold"),  
    axis.text.y = element_text(face = "bold"),  
    axis.title.x = element_text(face = "bold"),  
  ) + 
  ggtitle("b")


# Combine the two plots side by side (subplot)
combined_plot <- plot_APIs + plot_methods

# To make only the x-axis labels bold
combined_plot + theme(
  axis.text.x = element_text(face = "bold")  # Make only x-axis labels bold
)

# Save the combined plot as a high-resolution PNG
ggsave(
  "figures/API_releasemethod.png",  # Filename
  plot = combined_plot,  # Plot to save
  dpi = 600,  # Set the resolution to 300 DPI (high resolution)
  width = 10,  # Set the width of the image (in inches)
  height = 8,  # Set the height of the image (in inches)
  units = "in",  # Set units to inches
  device = "png"  # Save as PNG
)




