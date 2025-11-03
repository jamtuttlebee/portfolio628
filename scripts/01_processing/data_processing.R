################################################################################
# Strava Data Processing and Tidying
################################################################################
#
# James Tuttlebee
# jamtuttlebee@gmail.com
# 10/15/2025
#
# Script to process and tidy my wife's Strava data from the last two years of running.
#
################################################################################
# packages that need to be loaded
################################################################################
library(janitor)
library(tidyverse)
library(readxl)
library(lubridate)
library(writexl)
################################################################################
# read in the data from raw data folder to tidy it
################################################################################
clean_run_data <- read_excel(path = "data/raw/Mangie_Strava_Data/Raw_Run_Data.xlsx",
                           sheet = 1,
                           na = "NA") |>
  clean_names() |>
  select(activity_date, activity_type, distance_7, max_heart_rate_8, moving_time,
         average_speed, elevation_gain, max_cadence, average_cadence,
         average_heart_rate, weather_temperature, humidity, moon_phase,
         total_steps) |> # get rid of the columns that I do not need/want
  rename(date = activity_date, # rename some of the columns to better fitting names
         distance = distance_7,
         max_heart_rate = max_heart_rate_8,
         active_time = moving_time,
         temperature = weather_temperature) |>
  mutate(
    date = mdy_hms(date),  # parse "Jan 9, 2024, 11:13:31 PM" to the YYYY-MM-DD format
    date = as_date(date)   # remove the time, keep only YYYY-MM-DD
  ) |>
  mutate(year = year(date)) |> # create a new column that shows which date each observation is in
  filter(activity_type == "Run") # filter out any other types of workouts (walks, yoga, weights)

view(clean_run_data)
write_xlsx(clean_run_data, "data/processed/clean_run_data.xlsx")

################################################################################
# create another, smaller table with some analyzed data
################################################################################
table_1 <- clean_run_data |>
  group_by(year) |> # group the data by the two years
  summarize(average_year_distance = mean(distance), # find the mean of distances run in each year
              distance_year_total = sum(distance), # find the total miles ran in each year
              steps_year_total = sum(total_steps), # find the total steps ran in each year
              average_time_year = mean(active_time)) # find the mean active time in each year

view(table_1)
################################################################################
# shows how many rows and columns and lists the column names in console
################################################################################
dim(clean_run_data)
dim(table_1)

colnames(clean_run_data)
colnames(table_1)
