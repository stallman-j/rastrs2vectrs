# _______________________________#
# era5extractr
# Clean 02: Clean points shapefiles
# 
# Stallman
# Last edited: 2024-03-27
#________________________________#


# Startup

  rm(list = ls())


# bring in the packages, folders, paths ----

  home_folder <- file.path("P:","Projects","coding","git-bash","era5extractr")
  source(file.path(home_folder,"code","00_startup.R"))

# packages ----

  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(
    sf, # handling vector geometries (points, lines, polygons)
    tmap, # easy maps
    countrycode, # lets us append a continent and change between country naming conventions
    tictoc, # for timing stuff
    parallel, # parallelizing operations
    readr # for reading csvs into R. It's also in tidyverse so loaded but still
  )
  
  # tmap's world sf data frame
  data(World)
  
# data ----

  # tidyverse prefers read_csv from readr to base read.csv
  # https://uomresearchit.github.io/r-tidyverse-intro/03-loading-data-into-R/
  
  path <- file.path(data_external_raw,"SimpleMaps","worldcities.csv")
  points <- readr::read_csv(path) 

# turn into sf so R can use it

  # https://tmieno2.github.io/R-as-GIS-for-Economists/turning-a-data-frame-of-points-into-an-sf.html
  
  names(points)
  # [1] "city"       "city_ascii" "lat"        "lng"        "country"   
  # [6] "iso2"       "iso3"       "admin_name" "capital"    "population"
  # [11] "id" 
  # 
  points_sf <- st_as_sf(points,
                        coords = c("lng","lat"))
  
  # you'd have to be more careful about your coordinate reference system; here I'm assuming that we're on WGS84 
  # because most of the time that's the case
  
  points_sf <- st_set_crs(points_sf, "epsg:4326")

  out_path <- file.path(data_external_clean,"SimpleMaps")
  if (!dir.exists(out_path)) dir.create(out_path, recursive = TRUE) # recursive lets you create any needed subdirectories
  
  saveRDS(points_sf,
          file = file.path(data_external_clean,"SimpleMaps",paste0("global-cities.rds")))
  
# Suppose you wanted to get just the points in China ----

  china <- World %>% filter(name == "China") 
  
  plot(st_geometry(china))
  
  # this takes a very long time
  tic("Calculate intersection of global cities and China")
  points_sf_china <- st_intersection(china,points_sf)
  toc()
  
  # Calculate intersection of global cities and China: 162.14 sec elapsed
  # 
  # let's do the same in parallel and see 
  # get_parallel_splits() is in code/00_startup-general/00_startup_parallel-functions.R
  # 
  # 
  
  # decide how many cores to use
  n_cores <- 7 #detectCores(logical = TRUE) - 2 # takes cores of your machine minus 2
  
  # make a cluster
  
  tic("Obtained the number of global cities located in China")
  cl <- makeCluster(n_cores)
  
  # send the sf package to each core
  clusterEvalQ(cl,library(sf)) # send a package to each core
  clusterExport(cl, c("china")) # send the "china" data to each core
  
  # split the cities into n_cores number of bunches
  split_list <- get_parallel_splits(thing_to_split = points_sf,
                                    n_cores = n_cores )
  
  # take it in parallel
  # 
  split_results <-  parLapply(cl, split_list, function(x) st_intersection(x,china))
  
  
  cities_in_china <- do.call("rbind", split_results)
  
  
  toc()
  
  stopCluster(cl)
  
  
  # on 7 cores:
  # Obtained the number of global cities located in China: 2.84 sec elapsed
  

  
  saveRDS(points_sf_china,
          file = file.path(data_external_clean,"SimpleMaps",paste0("china-cities.rds")))
  
  
# plot to see what we're looking at ----


  # theme_map() is one of my functions in 
  map <- ggplot() +
    geom_sf(data = World,
            color = "gray70",
            fill = "gray99",
            alpha = 0.5,
            linewidth = .3) +
    geom_sf(data = points_sf,
            color = "blue",
            shape = 3) +
    labs(title = paste0("Cities of the World"),
         caption = c("Source: SimpleMaps (2024) and R package tmap")) +
    theme_map() 
  
  map
  
  save_map(output_folder = output_maps,
           plotname = map,
           filename = paste0("cities_of_the_world.png"),
           width = 8,
           height = 9,
           dpi  = 300)
  
  # just africa
  map <- ggplot() +
    geom_sf(data = china,
            color = "gray70",
            fill = "gray99",
            alpha = 0.5,
            linewidth = .3) +
    geom_sf(data = cities_in_china,
            color = "orange",
            shape = 5) +
    labs(title = paste0("Cities of China"),
         caption = c("Source: SimpleMaps (2024) and R package tmap")) +
    theme_map() 
  
  map
  
  save_map(output_folder = output_maps,
           plotname = map,
           filename = paste0("cities_of_china.png"),
           width = 8,
           height = 9,
           dpi  = 300)
