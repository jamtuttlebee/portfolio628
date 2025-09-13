################################################################################
# Collection Script for EVR628 Repository
################################################################################
#
# James Tuttlebee
# jamtuttlebee@gmail.com
# 09/13/2025
#
# This Script will be used to collect the different scripts used during EVR628
#   to be able to use them in future coding projects and to keep them all in one
#   place.
#
################################################################################
# Load packages
library(EVR628tools)
library(tidyverse)

# Load data
data(data_lionfish)

# Create a simple plot
p <- ggplot(data_lionfish,
            aes(x = total_length_mm, y = total_weight_gr)) +
  geom_point() +
  facet_wrap(~site)
plot(p)

# Save plot
ggsave(plot = p, filename = "results/figures/lion_fish_length.png")
