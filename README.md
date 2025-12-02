# Portfolio repository for EVR628 - Fall 2025 UM

James Tuttlebee  
jamtuttlebee@gmail.com | jlt225@miami.edu

  This repository will be used to turn in assignments for EVR628 during the 2025
  Fall semester of my MPS degree at the University of Miami.

## Packages and directories to install before using scripts in this Repo:
  - EVR628tools::create_dirs()  
  - remotes::install_github("jcvdav/EVR628tools")
  - remotes::install_github("grimbough/FITfileR")
  - remotes::install_github("ropensci/rnaturalearthhires")
  - library(FITfileR)
  - library(EVR628tools)  
  - library(tidyverse)  
  - library(janitor)  
  - library(readxl)  
  - library(lubridate)  
  - library(stars)
  - library(elevatr)
  - library(ggplot2)
  - library(dplyr)
  - library(cowplot)
  - library(patchwork)
  - library(ggridges)
  - library(ggspatial)
  - library(rnaturalearth)
  - library(sf)
  - library(terra)
  - library(tidyterra)
  - library(mapview)
  
## Overview of data_processing.R
  This script serves the purpose to read in data from an excel document that was
  taken from my wife's STRAVA account and then tidy it to be more readable and 
  malleable. It then, also, creates a second, smaller table showing some simple
  analyzing of the data to set the rest of the project up for full analyzing and
  visualization.
  
### Repository structure
  The repository contains three folders:  
    - data:  
      raw - contains the .xslx file as downloaded from STRAVA account.  
      processed - contains the cleaned up version of my data  
    - scripts:  
      01_processing - contains a single script that reads the raw data and cleans it up  
      02_analyses -  
      03_contents - contains a script that reads and visualizes the cleaned data and another script that visulizes one of the routes from the cleaned data
    - results:  
      contains a folder where images are saved
      
# About the data
  data/raw/Mangie_Strava_Data/Raw_Run_Data.xlsx contains 154 rows and 99 columns
  
### clean_run_data contains 125 rows and 15 columns
  
- date - Numeric | date of the recorded workout (YYYY-MM-DD format)  
- activity_type - Character | type of recorded workout (Run, Walk, Weights, or Yoga)  
- distance - Numeric | total in miles for recorded workout  
- max_heart_rate - Numeric | max heart rate in beats per minute for recorded workout  
- active_time - Numeric | total moving time during recorded workout in seconds  
- average_speed - Numeric | average speed of recorded workout  
- elevation_gain - Numeric | elevation gain of recorded workout  
- max_cadence - Numeric | maximum cadence during recorded workout  
- average_cadence - Numeric | average cadence during recorded workout  
- average_heart_rate - Numeric | average heart rate in beats per minute for recorded workout  
- temperature - Numeric | average temperature in Cº during recorded workout  
- humidity - Numeric | average humidity during recorded workout  
- moon_phase - Numeric | moon phase during recorded workout with 1 being full moon and 0 being new moon  
- total_steps - Numeric | total steps taking during recorded workout  
- year - Numeric | year of recorded workout (2024 or 2025)  

  
### table_1 (which is the smaller table with the beginnings of analyzing) contains 2 rows and 5 columns
    
- year - Numeric | year of recorded workout (2024 or 2025)  
- average_year_distance - Numeric | mean distance per workout by year  
- distance_year_total - Numeric | total distance by year  
- steps_year_total - Numeric | total steps taking by year  
- average_time_year - Numeric | mean active time per workout by year  

#### Link to the quarto pdf document created to report on and describe the data and findings of this study

<https://jamtuttlebee.github.io/portfolio628/final_report.html>
