# _______________________________#
# rastrs2vectrs
# 02 Merge: Extract ERA5 data to polygons
#
# Stallman
# Last edited: 2024-03-27
#________________________________#



# Startup

rm(list = ls())

# bring in the packages, folders, paths

home_folder <- file.path("P:","Projects","rastrs2vectrs")

source(file.path(home_folder,"code","00_startup.R"))

# packages
#
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  ggplot2, # pretty plots
  tictoc,
  sf,
  terra,
  exactextractr,
  tidyverse # every data wrangling thing
)

# bring in data ----

rast_in_path <- file.path(data_external_clean,"ERA_5","example_era5_clean.tif")

tictoc::tic("Reading in terra raster")
terra_raster <- terra::rast(x= rast_in_path)
tictoc::toc()


GPS_data <- readRDS(file.path(data_external_clean,"GADM","global",paste0("GADM_global_ADM_1.rds"))) %>%
            dplyr::filter(continent == "Africa")

terra::crs(terra_raster) <- "epsg:4326"


# extract raster data to points

tic("Extracted ERA5 to African Countries, splitting geometries into separate polygons")
out_cast <- raster_extract_to_long_df(terra_raster = terra_raster,
                                    vector_sf = GPS_data,
                                    cast_vector_sf = TRUE,
                                    vector_cast_out_path  = file.path(data_external_clean,"example"),
                                    vector_cast_out_filename = "vector_cast.rds",
                                    save_raster_copy = FALSE,
                                    raster_out_path = NULL, #getwd(),
                                    raster_out_filename = NULL, #"terra_raster_rotated_and_wgs84.tif",
                                    extracted_out_path = file.path(data_external_clean,"example"), #getwd(),
                                    extracted_out_filename = "era5_example_extracted_to_africa_polygons_with_cast.rds",
                                    layer_substrings = "sp",
                                    layer_names_vec = NULL,
                                    layer_names_title = "date",
                                    func = "weighted_sum", #"weighted_sum" if polygons
                                    weights = "area", #"area" if polygons
                                    remove_files = FALSE
)

toc()


tic("Extracted ERA5 to African Countries, without splitting geometries into separate polygons")
out_no_cast <- raster_extract_to_long_df(terra_raster = terra_raster,
                                    vector_sf = GPS_data,
                                    cast_vector_sf = FALSE,
                                    vector_cast_out_path  = NULL,
                                    vector_cast_out_filename = NULL, #"vector_cast.rds",
                                    save_raster_copy = FALSE,
                                    raster_out_path = NULL, #getwd(),
                                    raster_out_filename = NULL, #"terra_raster_rotated_and_wgs84.tif",
                                    extracted_out_path = file.path(data_external_clean,"example"), #getwd(),
                                    extracted_out_filename = "era5_example_extracted_to_africa_polygons_without_cast.rds",
                                    layer_substrings = "sp",
                                    layer_names_vec = NULL,
                                    layer_names_title = "date",
                                    func = "weighted_sum", #"weighted_sum" if polygons
                                    weights = "area", #"area" if polygons
                                    remove_files = FALSE
)

toc()
