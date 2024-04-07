# _______________________________#
# Project templates
# Setup: Create Folders
#
# Stallman
# Started 2022-08-20
# Last edited: 2024-03-27
#________________________________#

## THIS FILE CAN ONLY BE RUN FROM 00_master_run-of-show.R, otherwise the following locals won't be defined

# Create folders ----

# you need home_folder to already be defined, which you do in 00_master_run-of-show.R

# folders         <- c(
#   # code folders
#   code_folder,code_startup_project_specific,code_download,code_clean,code_analysis,code_plots,code_simulations,code_scratch,
#   # output folders
#   output_folder,output_tables,output_figures,output_maps,output_manual,output_scratch,
#   # data folders
#   data_folder,data_manual,data_raw,data_temp,data_clean,
#   # external hard drive folders
#   data_external,data_external_raw,data_external_temp,data_external_clean
# )
#
#
# for (folder in folders) {
#   if (!dir.exists(folder)) dir.create(folder, recursive = TRUE) # recursive lets you create any needed subdirectories
# }
