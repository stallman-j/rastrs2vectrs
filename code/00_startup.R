# ______________________________#
# ERA5 Extraction to Points and Polygons in the Context of a Project 
# Last updated: 2024-03-27
# ______________________________#


# Packages ----

# increase max timeout time so we can install large databases
options(timeout = max(1000, getOption("timeout")))

if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  ggplot2, # pretty plots
  tidyverse # every data wrangling thing
)

#install.packages("devtools")

#devtools::install_dev("remotes")


# parameters ----

equal_area_crs      <- "ESRI:102022"
current_continent   <- "Africa"
time_range          <- c("1960-01-01","2018-12-31")

# directories ----
home_folder <- file.path("P:","Projects","git","era5-extraction")
setwd(home_folder)

# Code Paths

  code_startup_general          <- file.path(home_folder,"code","00_startup-general")
  code_startup_project_specific <- file.path(home_folder,"code","00_startup-era5-extraction-specific")
  
  code_folder                   <- file.path(home_folder,"code")
  code_download                 <- file.path(code_folder,"01_download")
  code_clean                    <- file.path(code_folder,"02_cleaning")
  code_analysis                 <- file.path(code_folder,"03_analysis")
  code_plots                    <- file.path(code_folder,"04_plots")
  code_simulations              <- file.path(code_folder,"05_simulations")
  code_scratch                  <- file.path(code_folder,"scratch")

# Output Paths
  output_folder                 <- file.path(home_folder,"output")
  output_tables                 <- file.path(output_folder, "01_tables")
  output_figures                <- file.path(output_folder, "02_figures")
  output_maps                   <- file.path(output_folder, "03_maps")
  output_manual                 <- file.path(output_folder, "x_manual-output")
  output_scratch                <- file.path(output_folder, "scratch")

# Data Paths
  data_folder                   <- file.path("P:","data") #file.path("C:","environment_data") to use local version 
  data_manual                   <- file.path(data_folder,"00_manual-download")
  data_raw                      <- file.path(data_folder, "01_raw")
  data_temp                     <- file.path(data_folder, "02_temp")
  data_clean                    <- file.path(data_folder, "03_clean")

# if you use an external drive
  data_external                 <- file.path("E:","data")
  data_external_raw             <- file.path(data_external,"01_raw")
  data_external_temp            <- file.path(data_external,"02_temp")
  data_external_clean           <- file.path(data_external,"03_clean")

# If you have different data paths for different machines, use this code to change the data path 
# for your alternate machine by replacing your actual machine name for "my-machines-name"
if (Sys.info()[["nodename"]]=="my-machines-name" ){
  
  # Data Paths
  data_folder                   <- file.path(home_folder,"data") #
  data_manual                   <- file.path(data_folder,"00_manual-download")
  data_raw                      <- file.path(data_folder, "01_raw")
  data_temp                     <- file.path(data_folder, "02_temp")
  data_clean                    <- file.path(data_folder, "03_clean")
  
  # for really big data
  data_external                 <- file.path(home_folder,"data")
  data_external_raw             <- file.path(data_external,"01_raw")
  data_external_temp            <- file.path(data_external,"02_temp")
  data_external_clean           <- file.path(data_external,"03_clean")
  
  
}

# _______________________________#
# Turning on scripts ----
# 1 means "on," anything else is "don't run"
# _______________________________#
# 00 startup
  startup_create_folders_general                           <-    0
  startup_download_functions_general                       <-    1
  
  # None of the following are currently used, but if this folder expands 
  # to include analysis and plots these functions will be used and include templates
  startup_clean_functions_general                          <-    0
  startup_map_functions_general                            <-    1
  startup_spatial_functions_general                        <-    0
  startup_plot_functions_general                           <-    0
  startup_analysis_functions_general                       <-    0
  startup_palette_general                                  <-    0
  startup_parallel_functions_general                       <-    1

# 00 startup era5extractr functions: none of the following are currently filled in
  startup_era5_extraction_download_functions                  <-    0
  startup_era_5_extraction_cleaning_functions                  <-    0
  startup_era5_extraction_analysis_functions                  <-    0
  startup_parameters                                       <-    0


# _______________________________#
# Running Files  ----
# _______________________________#

# 00 startup ----

  if(startup_create_folders_general==1){
      source(file.path(code_startup_general,"00_startup_create-folders.R"))
    }
  
  if(startup_download_functions_general==1){
    source(file.path(code_startup_general,"00_startup_download-functions.R"))
  }
  
  if(startup_clean_functions_general==1){
    source(file.path(code_startup_general,"00_startup_cleaning-functions.R"))
  }
  
  
  if(startup_map_functions_general==1){
    source(file.path(code_startup_general,"00_startup_map-functions.R"))
  }
  
  if(startup_spatial_functions_general==1){
    source(file.path(code_startup_general,"00_startup_spatial-functions.R"))
  }
  
  
  if(startup_plot_functions_general==1){
    source(file.path(code_startup_general,"00_startup_plot-functions.R"))
  }
  
  if(startup_analysis_functions_general==1){
    source(file.path(code_startup_general,"00_startup_analysis-functions.R"))
  }
  
  if(startup_parallel_functions_general==1){
    source(file.path(code_startup_general,"00_startup_parallel-functions.R"))
  }
  
  if(startup_palette_general==1){
    source(file.path(code_startup_general,"00_startup_palette.R"))
  }



## 00 startup, get functions for my specific project ----

  if(startup_era5_extraction_download_functions==1){
    source(file.path(code_startup_project_specific,"00_startup_era5-extraction-download-functions.R"))
  }
  
  if(startup_era_5_extraction_cleaning_functions==1){
    source(file.path(code_startup_project_specific,"00_startup_era5-extraction-cleaning-functions.R"))
  }
  
  if(startup_era5_extraction_analysis_functions==1){
    source(file.path(code_startup_project_specific,"00_startup_era5-extraction-analysis-functions.R"))
  }
  
  if(startup_parameters==1){
    source(file.path(code_startup_project_specific,"00_startup_parameters.R"))
  }


# clean up locals
rm(startup_create_folders_general,
   startup_download_functions_general,
   startup_clean_functions_general,
   startup_map_functions_general,
   startup_spatial_functions_general,
   startup_plot_functions_general,
   startup_analysis_functions_general,
   startup_palette_general,
   startup_parallel_functions_general,
   startup_era5_extraction_download_functions,
   startup_era_5_extraction_cleaning_functions,
   startup_era5_extraction_analysis_functions,
   startup_parameters
)

