#' Description: Create Long-run variables
#' @description With a df with a time dimension, create a bunch of long-run variables
#' @param panel_df panel data frame
#' @param id_varname the variable name of the
#' @param time_varname variable name of the largest
#' @param variable_to_manipulate character vector of the variable that you want long-run values for
#' @param variable_namestub character vector, the namestub that you want appended to the long-run varnames
#' @param out_path output file.path() to where to save the final data frame. Default is NULL, in which case the df isn't saved
#' @param output_filename filename to save the final data frame, if you provide an out_path. Default NULL doesn't do anything
#' @returns a data frame that for the variable_to_manipulate
#' @examples
#' # example code
#'
#' @export
create_long_run_vars <- function(panel_df,
                                 id_varname   = "DHSID",
                                 time_varname = "year",
                                 variable_to_manipulate = "precip_annual_mean",
                                 variable_namestub      = "precip",
                                 out_path = NULL,
                                 out_filename = NULL

){
  # create some variables to manipulate; this is easier in base R than dplyr?
  panel_df[["time_var"]]          <- panel_df[[time_varname]]
  panel_df[["var_to_manipulate"]] <- panel_df[[variable_to_manipulate]]
  panel_df[["id_var"]]            <- panel_df[[id_varname]]

  panel_df_tmp <- panel_df %>%
    dplyr::filter(!is.na(time_var)) %>%
    dplyr::group_by(time_var)%>%
    dplyr::arrange(id_varname) %>% # sorted by ID, chronologically within
    dplyr::ungroup() %>%
    dplyr::group_by(id_var) %>%
    dplyr::mutate(lr_avg = mean(var_to_manipulate),
                  lr_sd  = sd(var_to_manipulate),
                  lr_zscore = (var_to_manipulate - mean(var_to_manipulate))/(sd(var_to_manipulate))) %>%
    dplyr::ungroup()


  # change the variable names
  for (varname in c("lr_avg","lr_sd","lr_zscore")) {
    names(panel_df_tmp)[names(panel_df_tmp)== varname] <- paste0(variable_namestub, "_",varname)

  }

  # take out the temp vars we made to make the code easy
  panel_df_out <- panel_df_tmp %>%
    dplyr::select(-c(time_var,var_to_manipulate,id_var))

  if (!is.null(out_path) & !is.null(out_filename)){
  if (!dir.exists(out_path)) dir.create(out_path, recursive = TRUE) # recursive lets you create any needed subdirectories

  saveRDS(panel_df_out,
          file = file.path(out_path,
                           out_filename))

  }
  rm(panel_df_tmp)

  return(panel_df_out)
}

#' Break up a thing into chunks of a certain size n
#' @param x a vector or list, things you want to split up
#' @param n number of chunks
#' @examples chunk_urls <- chunk_it(my_URLS,
#'                        n = ceiling(length(my_URLS)/22000))
#' missing_urls <- rep(NA, length(my_URLS))
#'
#' missing_url_chunks <- chunk_it(missing_urls,
#'                                n = ceiling(length(my_URLS)/22000))
#' @export
chunk_it <- function(x,n) split(x, cut(seq_along(x),
                                       breaks = n,
                                       labels = FALSE))

#' Save RDS and CSV and Excel files
#' @description
#' Given data, saves an output in RDS and CSV
#' @param data the data frame
#' @param output_path file path to the directory you want to store
#' @param date in character the dates relevant to the filename, will be put at the front of the filename
#' @param output_filename character, in RDS the filename output, assumes it ends in ".rds" and starts with "_" e.g. "_gkg_events.rds" so if date = "2016"
#' then the file would be called "2016_gkg_events.rds"
#' @param csv_vars vector of character strings with the varnames of the variables that will be saved in the CSV file. Defaults "all"
#' @param remove defaults to TRUE in which case the data are removed after being saved, if FALSE returns the data to memory
#' @param format Save to "csv" or "xlsx" or "rds". Default "all" is all 3 of the above.
#' @export
save_rds_csv <- function(data,
                         output_path,
                         date = "",
                         output_filename,
                         remove = TRUE,
                         csv_vars = c("all"),
                         format   = "all"){


  if (!dir.exists(output_path)) dir.create(output_path, recursive = TRUE) # recursive lets you create any needed subdirectories

  out_path <- file.path(output_path,
                        paste0(date,
                               output_filename))

  saveRDS(data,file = out_path)

  csv_path <- gsub(pattern = ".rds", replacement = ".csv", x = out_path)

  if (csv_vars[1] == "all") {
    csv_data <- data
  } else {
    csv_data <- data[,csv_vars]
  }


  if (format == "all"){
    if (!require("readr")) install.packages("readr")
    library(readr)
    readr::write_csv(csv_data,
                     file =csv_path)

    if (!require("writexl")) install.packages("writexl")
    library(writexl)
    xlsx_path <- gsub(pattern = ".rds", replacement = ".xlsx", x = out_path)

    writexl::write_xlsx(csv_data,
                        path = xlsx_path)

  } else if (format == "csv") {
    if (!require("readr")) install.packages("readr")
    library(readr)
    readr::write_csv(csv_data,
                     file =csv_path)
  } else if (format == "xlsx"){
    if (!require("writexl")) install.packages("writexl")
    library(writexl)
    xlsx_path <- gsub(pattern = ".rds", replacement = ".xlsx", x = out_path)

    writexl::write_xlsx(csv_data,
                        path = xlsx_path)
  } else if (format == "rds"){
    print("Not saving to CSV or XLSX, just saved RDS file.")
  }


  if (remove == TRUE){
    rm(data,csv_data)
  } else{
    rm(csv_data)
    return(data)
  }


}
