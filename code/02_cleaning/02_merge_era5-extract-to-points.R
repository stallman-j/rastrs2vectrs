# _______________________________#
# era5extractr
# 02 Merge: Extract ERA5 data to points
#
# Stallman
# Last edited: 2024-03-27
#________________________________#



# Startup

rm(list = ls())

# bring in the packages, folders, paths

home_folder <- file.path("P:","Projects","rastrs2vectrs")

source(file.path(home_folder,"code","00_startup.R"))

# bring in data ----

  rast_in_path <- file.path(data_external_clean,"ERA_5","example_era5_clean.tif")

  tic("Reading in terra raster")
  terra_raster <- terra::rast(x= rast_in_path)
  toc()

  GPS_data <- readRDS(file.path(data_external_clean,"SimpleMaps",paste0("global-cities.rds")))

  terra::crs(terra_raster) <- "epsg:4326"


# extract raster data to points

  tic("Extracted ERA5 to SimpleMaps Cities")
  out_df <- raster_extract_to_long_df(terra_raster = terra_raster,
                                      vector_sf = GPS_data,
                                      cast_vector_sf = FALSE,
                                      vector_cast_out_path  = NULL,
                                      vector_cast_out_filename = NULL, #"vector_cast.rds",
                                      save_raster_copy = FALSE,
                                      raster_out_path = NULL, #getwd(),
                                      raster_out_filename = NULL, #"terra_raster_rotated_and_wgs84.tif",
                                      extracted_out_path = file.path(data_external_clean,"example"), #getwd(),
                                      extracted_out_filename = "era5_example_extracted_to_DHS.rds",
                                      layer_substrings = "sp",
                                      long_df_colname  = "sp",
                                      layer_names_vec = NULL,
                                      layer_names_title = "date",
                                      func = "mean", #"weighted_sum" if polygons
                                      weights = NULL, #"area" if polygons
                                      remove_files = FALSE
  )

  toc()
  #Extracted ERA5 to SimpleMaps Cities: 1.57 sec elapsed

