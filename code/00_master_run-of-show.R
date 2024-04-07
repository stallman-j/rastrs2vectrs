# _______________________________#
# Master Run of Show
# Runs all files
#________________________________#

# Startup

  rm(list = ls())

# bring in the packages, folders, paths

  home_folder <- file.path("P:","Projects","coding","git-bash","era5extractr")

# sets file paths, gives parameters, establishes common functions

  source(file.path(home_folder,"code","00_startup.R"))

# _______________________________#
# Turning on scripts ----
# 1 means "on," anything else is "don't run"
# _______________________________#

# 01 download

  download_datasets                                  <-    0

# 02 cleaning

  clean_era5                                         <-    0
  clean_polygons                                     <-    0
  clean_points                                       <-    0
  merge_era5_extract_to_points                       <-    0
  merge_era5_extract_to_polygons                     <-    0

# 03 analysis
  ## To add later

# 04 plots

  ## to add later

# 05 simulations
  ## to add later

# _______________________________#
# Running Files  ----
# _______________________________#

## 01 download ----

  if (download_datasets==1){
    source(file.path(code_download,"01_download-datasets.R"))
  }

## 02 cleaning ----

  if (clean_era5==1){
    source(file.path(code_clean,"02_clean_era5.R"))
  }

  if (clean_polygons==1){
    source(file.path(code_clean,"02_clean_polygons.R"))
  }

  if (clean_points==1){
    source(file.path(code_clean,"02_clean_points.R"))
  }

  if (merge_era5_extract_to_points==1){
    source(file.path(code_clean,"02_merge_era5-extract-to-points.R"))
  }

  if (merge_era5_extract_to_polygons==1){
    source(file.path(code_clean,"02_merge_era5-extract-to-polygons.R"))
  }


