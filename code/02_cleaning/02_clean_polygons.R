# _______________________________#
# era5extractr
# Clean 02: Clean GADM polygon shapefiles
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
    sf,
    tmap,
    countrycode, # lets us append a continent and change between country naming conventions
    tictoc
  )
  
  path <- file.path(data_external_raw,"GADM","gadm_410-levels","gadm_410-levels.gpkg")
  
  st_layers(path)
  
  # turn off spherical geometry
  # for more precise fixes follow https://github.com/r-spatial/sf/issues/1902
  sf_use_s2(FALSE)
  
  out_path <- file.path(data_external_clean,"GADM","global")
  if (!dir.exists(out_path)) dir.create(out_path, recursive = TRUE) # recursive lets you create any needed subdirectories
  
  levels <- 1:6
  
  
  for (level in levels){
  # download the countries
  level_gadm <- st_read(dsn = path,
                        layer = paste0("ADM_",level)) %>%
                st_make_valid()
  
  level_gadm$continent <- countrycode(sourcevar = level_gadm$GID_0,
                              origin = "iso3c",
                              destination = "continent")
  
  saveRDS(level_gadm,
          file = file.path(out_path,paste0("GADM_global_ADM_",level,".rds")))
          
  rm(level_gadm)
  }
  
# not about to plot these, they take a really long time.
# If you're working with a particular geography you'd want to do some cropping or selecting here

