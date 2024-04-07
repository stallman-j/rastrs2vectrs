# _______________________________#
# era5-extraction
# download 01: download datasets and extract from their zip files
#
# Stallman
# Last edited: 2024-03-27
#________________________________#

# Startup

  rm(list = ls()) # removes everything from environment

# bring in the packages, folders, paths ----

  home_folder <- file.path("P:","Projects","rastrs2vectrs")
  source(file.path(home_folder,"code","00_startup.R"))

# packages ----

if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  httr, # # for inputting username + password into a static sit
  rvest,# for getting urls
  reticulate, # running python in R
  jsonlite,
  utils,
  R.utils, # to unzip a .gz file
  archive, # to unzip a .tar file
  stringr # string functions
)

# ERA 5 ----

# see README.md for instructions on how to get this set up

library(reticulate)
#create new environment
# install latest python version
reticulate::install_python()

  virtualenv_create("r-reticulate") # create a virtual environment
  virtualenv_install("r-reticulate", packages = "cdsapi") # install the CDS API package into this virtual environment

  # create a folder to download the data into
  path <- file.path(data_external_raw,"ERA_5")
  if (!file.exists(path)) dir.create(path, recursive = TRUE)

  os <- import("os")
  os$getcwd() # get current directory
  os$chdir(path) # change current directory (so that a file downloaded will go there)

# import_era5_precip
# import_era5_surface_temperature

  py_path <- file.path(code_download,"import_era5_precip.py")

  py_run_file(py_path)

  py_path <- file.path(code_download,"import_era5_precip.py")

  py_run_file(py_path)

# also can use the function

  # NOTE: this will NOT work unless you've done the configurations to get the CDS API onto your computer
  # See the README file for how to do this

  download_era5(raw_data_path = data_external_raw,
                code_download_path = code_download,
                cdsapi_filename = "example_cdsapi.py",
                new_era5_filename = "example_era5.nc")

# # GADM Country Shapefiles ----

# lots and lots of data, takes quite some time to run. You could also select
# just the country you want of course at the below link and adjust the "filenames" vector below:

# https://gadm.org/download_world.html

# The download links
  # https://geodata.ucdavis.edu/gadm/gadm4.1/gadm_410-gpkg.zip
  # https://geodata.ucdavis.edu/gadm/gadm4.1/gadm_410-gdb.zip
  # https://geodata.ucdavis.edu/gadm/gadm4.1/gadm_410-levels.zip

# the geopackage is the standard format

  filenames <- c("gadm_410-gpkg","gadm_410-gdb","gadm_410-levels")

  sub_urls <- paste0(filenames,".zip")

  # this function is taking the base URL: "https://geodata.ucdavis.edu/gadm/gadm4.1"
  # and the sub-urls (listed above), downloading the three separate files which are all .zip
  # files, and extracting them into the 01_raw data folder in the external data path defined
  # in 00_startup.R in a folder called "GADM" (which is created by the function)

  download_multiple_files(data_subfolder = "GADM",
                          data_raw = data_external_raw,
                          base_url = "https://geodata.ucdavis.edu/gadm/gadm4.1",
                          sub_urls = sub_urls,
                          filename = filenames,
                          zip_file = TRUE,
                          pass_protected = FALSE)

# Cities from SimpleMaps ----

  # not vetted for accuracy, just wanted a useful public database with points data
  # https://simplemaps.com/data/world-cities

  # download URL
  # https://simplemaps.com/static/data/world-cities/basic/simplemaps_worldcities_basicv1.77.zip

  # you could use the "download_multiple_files" function with a single element in the vector
  # but this is another function if you just want a single file

  download_single_file(data_subfolder = "SimpleMaps",
                       data_raw = data_external_raw,
                       filename = "simplemaps_worldcities_basicv1.77",
                       url      = "https://simplemaps.com/static/data/world-cities/basic/simplemaps_worldcities_basicv1.77.zip",
                       zip_file = TRUE,
                       pass_protected = FALSE
                       )

# just one continent file

  # https://stackoverflow.com/questions/20146809/how-can-i-plot-a-continents-map-with-r

  download_single_file(data_subfolder = "CUNY_continents",
                       data_raw = data_external_raw,
                       filename = "continent",
                       url      = "http://baruch.cuny.edu/geoportal/data/esri/world/continent.zip",
                       zip_file = FALSE,
                       pass_protected = FALSE
  )
