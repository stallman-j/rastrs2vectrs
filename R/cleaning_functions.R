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
