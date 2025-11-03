################################################################################
# Strava data visualization
################################################################################
#
# James Tuttlebee
# jamtuttlebee@gmail.com
# 11/02/2025
#
# Script to visualize the tidy Strava data.
#
################################################################################
# Read in necessary packages
library(readxl)
library(tidyverse)
library(janitor)
library(cowplot)
library(patchwork)
library(ggridges)
library(dplyr)
library(ggplot2)

################################################################################
# Read in data
clean_run_data <- read_excel(path = "data/processed/clean_run_data.xlsx", sheet = 1)

# Build first plot
p1 <- ggplot(clean_run_data, aes(x = date, y = distance)) + # Specify my data and my aesthetics
  geom_line(color = "black", size = 0.5) + # add the aes of the lines
  geom_point(shape = 21, fill = "salmon", size = 2) + # add the points of each run
  geom_smooth(method = "loess", se = FALSE, color = "salmon1", size = 0.5) + # add a trend line
  labs( # labels of axis and titles
    x = "Date of Run",
    y = "Distance (kilometers)",
    title = "Visualizing Change in Distance per Run Over Time",
  ) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "2 months") + # x-axis formatting
  theme_dark(base_size = 14) +
  theme( # axis title formatting
    plot.title = element_text(face = "bold", size = 16),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.background = element_rect(fill = "gray92", color = NA))
p1

################################################################################
# Build second plot
clean_run_data <- clean_run_data |> # Convert m/s → min/km
  mutate(pace_min_per_km = (1000 / average_speed) / 60)
p2 <- ggplot(data = clean_run_data, # Specify my data and my aesthetics
       mapping = aes(x = total_steps, # add the aes of the lines
                     y = pace_min_per_km)) +
  geom_point(shape = 21, # add the points of each run
             fill = "salmon",
             size = 2) +
  scale_y_reverse(   # Reverse y-axis and format as "min:sec"
    labels = function(x) sprintf("%d:%02d", floor(x), round((x %% 1) * 60)),
    breaks = seq(5, 15, 1.50) # format y-axis intervals and bounds
  ) +
  labs(x = "Total Steps", # labels of axis and titles
       y = "Average Speed (min/km)",
       title = "Comparing Speed to Total Steps per Run",
       subtitle = "Does number of steps increase or decrease with speed?",
       caption = "Source: My wife's STRAVA") +
  theme_dark(base_size = 14) +
  theme( # axis title formatting
    plot.title = element_text(face = "bold", size = 16),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.background = element_rect(fill = "gray92", color = NA))
p2

################################################################################
# Cowplot plotgrid to create panels for the plots
my_plot <- plot_grid(p1, p2,
                     ncol = 1,
                     labels = c("A)", "B)"))
my_plot

################################################################################
# Save and export my plot
ggsave(plot = my_plot,
       filename = "results/img/distance_speed_steps.png", # Export my file as png
       width = 8,
       height = 8)
