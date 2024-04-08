#' Collapse data to annual according to an id
#' @description from a data frame that is higher-than-annual frequency, collapses to annual with rolling averages at 3, 5 and 11 years
#' @param panel_df the panel data frame which is currently monthly and we want to be annual
#' @param date_varname the variable name (as a character) that dates are stored as; needs to include year and month and be readable with as.Date()
#' @param value_varname_old the current name of the values you're using for the values column
#' @param value_varname_new new variable name for the values you're interested in summarizing from monthly to annually
#' @param id_varname the observation ID. default is "vector_cast_id" because that's what raster_extract_to_long_df outputs as the id, the observation ID
#' @param out_path the file.path() to where you would like to save the annual df. Gets created if it doesn't already exist. Defaults to working directory
#' @param out_filename The name you would like the long annual panel to be saved as. defaults to "annualized_df.rds"
#' @returns an annualized df with 3 annual rolling averages
#' @examples
#' collapse_panel_to_annual(in_df = out_df, value_varname_old = "precip_mean",  value_varname_new = "precip",  id_varname = "vector_cast_id", out_path = file.path(data_external_clean,"merged","DHS_ERA5","annual"),  out_filename = "africa_dhs_gps_era5_annual.rds")

collapse_panel_to_annual <- function(in_df,
                                     date_varname  = "date",
                                     value_varname_old  = "precip_mean",
                                     value_varname_new  = "precip",
                                     rolling_average_years = c(3,5,11),
                                     id_varname    = "vector_cast_id",
                                     out_path      = getwd(), #file.path(data_external_clean,"merged","DHS_ERA5","annual")
                                     out_filename  = "annualized_df.rds"
){

  if (!dir.exists(out_path)) dir.create(out_path, recursive = TRUE) # recursive lets you create any needed subdirectories
  # for converting character varnames to grouping vars
  # https://stackoverflow.com/questions/52437463/function-calling-variable-names-for-group-by-in-dplyr-how-do-i-vectorise-this


  varnames_vec <- c(
                    paste0(value_varname_new,"_rolling_avg_",rolling_average_years[1],"_years"),
                    paste0(value_varname_new,"_rolling_avg_",rolling_average_years[2],"_years"),
                    paste0(value_varname_new,"_rolling_avg_",rolling_average_years[3],"_years"),
                    paste0(value_varname_new,"_annual_mean"))

  annual_temp_df <- in_df %>%
    dplyr::mutate(year = lubridate::year(as.Date(!! sym(date_varname)))) %>%
    dplyr::rename(var_of_interest := !!sym(value_varname_old))  %>%
    group_by(!!! syms(c(id_varname,"year"))) %>%
    summarize(annual_mean = mean(var_of_interest)) %>%
    ungroup() %>%
    filter(!is.na(annual_mean)) %>%
    group_by(!!! syms(id_varname)) %>% # group by ID, then get rolling averages of the k prior years, pulling the names from the varnames vec
    mutate(!!sym(varnames_vec[1]) := zoo::rollmean(annual_mean, k=rolling_average_years[1],   fill = NA, align = "right"),
           !!sym(varnames_vec[2]) := zoo::rollmean(annual_mean, k=rolling_average_years[2],   fill = NA, align = "right"),
           !!sym(varnames_vec[3]) := zoo::rollmean(annual_mean, k=rolling_average_years[3],  fill = NA, align = "right")) %>%
    rename(!!sym(varnames_vec[4]) := annual_mean)


  saveRDS(annual_temp_df,
          file = file.path(out_path,
                           out_filename))

}
