#' Downloads ERA5 data using R and python
#'
#'
#' \code{download_era5} use the ERA5 API to download desired data
#' See the README associated with the era5-extraction repository for instrucitons on how to get the CDS API request file and be able to download the ERA5 data using the Copernicus API
#' If you are getting the error from Python that says something like "cdsapi module not found', it is likely that r-reticulate is running into an issue finding your python virtual environment and you are running this code within a project. To trouble-shoot, try going to Tools -> Global Options -> Python and uncheck "Automatically activate project-local Python environments." See https://github.com/rstudio/reticulate/issues/1362 for additional troubleshooting.
#' @author jillianstallman
#' @param raw_data_path path location where you want to download the ERA5 data to. the data will be downloaded into a file called file.path(raw_data_path,"ERA_5") which will be created if it doesn't exist already
#' @param cdsapi_filepath path location of the .py file you downloaded from Copernicus
#' @param cdsapi_filename the filename with ".py" extension that you labeled the API call as
#' @param new_era5_filename the default CDS API filename is "download.nc". If you did not change this default and have multiple API calls this will lead to conflicts, so set new_era5_filename as "newname.nc" to avoid your file getting overwritten
#' @export

download_era5 <- function(raw_data_path,
                          code_download_path,
                          cdsapi_filename,
                          new_era5_filename = NULL
                          ) {

  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(
    reticulate
  )

#create new environment
# install latest python version
reticulate::install_python()

virtualenv_create("r-reticulate") # create a virtual environment
virtualenv_install("r-reticulate", packages = "cdsapi") # install the CDS API package into this virtual environment

# create a folder to download the data into
path <- file.path(raw_data_path,"ERA_5")
if (!file.exists(path)) dir.create(path, recursive = TRUE)

os <- import("os")
os$getcwd() # get current directory
os$chdir(path) # change current directory (so that a file downloaded will go there)


py_path <- file.path(code_download_path,cdsapi_filename)

py_run_file(py_path)


if (!is.null(new_era5_filename)){
file.rename(to = file.path(raw_data_path,"ERA_5",new_era5_filename),
            from = file.path(raw_data_path,"ERA_5","download.nc")
            )
}

}
