# Download Functions


#' Function for downloading multiple data files from a website
#' @param data_subfolder  name of subfolder in the 01_raw data folder to place data in
#' @param data_raw location (file path) of raw data folder
#' @param base_url the url of the folder to download
#' @param sub_urls the additional endings to the base url that you'd like to download separately, a vector of characters
#' @param filenames the names of files, without paths, to attach to those suburls.
#' @param pass_protected: if TRUE, site requires a password; default FALSE
#' @param zip_file: set TRUE if the file you want to download is a .zip (and this will extract it)
#' @param username: if pass_protected == TRUE, set your username. This is NOT secure.
#' @param password: if pass_protected == FALSE, set your password as a character. 

#' NOTE:
#' THIS IS NOT A SECURE METHOD OF STORING USERNAME AND PASSWORD
#' If this bothers you, remove the parameters username and password from the function, and replace
#' the code below that username <- username with username <- readline("Type the username:")
#' and passowrd <- password with password <- readline("Type the password:")

#' TO UPDATE: INCORPORATE A PACKAGE LIKE KEYRING
#' E.G. https://stackoverflow.com/questions/58409378/safely-use-passwords-in-r-files-prevent-them-to-be-stored-as-plain-text



download_multiple_files <- function(data_subfolder,
                                    data_raw,
                                    base_url,
                                    sub_urls,
                                    filenames,
                                    pass_protected = FALSE,
                                    zip_file = FALSE,
                                    username = NULL,
                                    password = NULL) {
  
  extract_path <- file.path(data_raw,data_subfolder)
  
  
  # create folder if it doesn't already exist
  if (file.exists(extract_path)) {
    cat("The data subfolder",extract_path,"already exists. \n")
  } else{
    cat("Creating data subfolder",extract_path,".\n")
    dir.create(extract_path)
  }
  
  cat("There are ",length(seq_along(sub_urls))," files to download. Starting download, hang tight.\n")
  
  for (i in seq_along(sub_urls)) {
    
    if(zip_file == TRUE){
      unzip_path <- file.path(data_raw, data_subfolder, filenames[i])
      file_path <- paste0(unzip_path,".zip")
      
      # will need to check this later
      if(pass_protected == TRUE) {
        username <-username # readline("Type the username:") # alternatively if you want user input. gets to be a hassle because the input form asks user+pass for each separate URL
        password <- password # readline("Type the password:")
        GET(url = paste0(base_url,"/",sub_urls[i]),
            authenticate(user = username,
                         password = password),
            write_disk(file_path, overwrite = TRUE))
        
      }else if (pass_protected == FALSE) {
        
        download.file(url =paste0(base_url,"/",sub_urls[i]),
                      destfile = file_path,
                      mode     = "wb")
      }
      
      if (file.exists(unzip_path)) {
        cat("The data subfolder",unzip_path,"already exists. \n")
      } else{
        cat("Creating data subfolder",unzip_path,".\n")
        dir.create(unzip_path)
      }
      
      # unzip the file
      unzip(file_path,
            exdir = unzip_path,
            overwrite = FALSE) # keep the unzip overwrite as FALSE because some files don't unzip properly if TRUE
      
      
    } else if (zip_file == FALSE) {
      extract_path <- file.path(data_raw, data_subfolder, filenames[i])
      file_path <- extract_path
      
      if(pass_protected == TRUE) {
        username <- username
        password <- password
        
        
        GET(url = paste0(base_url,"/",sub_urls[i]),
            authenticate(user = username,
                         password = password),
            write_disk(path = file.path(data_raw,data_subfolder,filenames[i]), 
                       overwrite = TRUE))
        
      }else{
        
        download.file(url = paste0(base_url,"/",sub_urls[i]),
                      destfile = file_path,
                      mode     = "wb")
      }
    }
    
    
    
  }
  
  
}


#' Function for downloading a single file from a website, zip or password protected file
#' @param data_subfolder  name of subfolder in the 01_raw data folder to place data in
#' @param data_raw location (file path) of raw data folder
#' @param filename if not a zip file and need to use download.file, needs to provide a name for the ultimate file
#' @param url the url of the folder to download
#' @param zip_file TRUE or FALSE, if TRUE use file path of a zip folder
#' @param pass_protected TRUE or FALSE, if TRUE you'll get prompted for username and password

# works with zip and passwords! for a single link

download_single_file <- function(data_subfolder, 
                                  data_raw = data_raw,
                                  filename = NULL,
                                  url,
                                  zip_file = FALSE,
                                  pass_protected = FALSE) {
  
  # this is where the data will live
  extract_path <- file.path(data_raw, data_subfolder)
  
  # create folder if it doesn't already exist
  if (file.exists(extract_path)) {
    cat("The data subfolder",extract_path,"already exists. \n")
  } else{
    cat("Creating data subfolder",extract_path,".\n")
    dir.create(extract_path)
  }
  
  # if the file's a zip, make file_path a zip folder, then extract to its own folder
  # otherwise same as ultimate extraction path
  if(zip_file == TRUE){
    file_path <- file.path(data_raw, paste0(data_subfolder, ".zip"))
    
    if(pass_protected == TRUE) {
      if (!require("httr")) install.packages("httr")
      
      library(httr)
      #username <-username # readline("Type the username:") # alternatively if you want user input. gets to be a hassle because the input form asks user+pass for each separate URL
      #password <- password # readline("Type the password:")
      
     username <- readline("Type the username:") 
     password <- readline("Type the password:")
      GET(url = url,
          authenticate(user = username,
                       password = password),
          write_disk(file_path, overwrite = TRUE))
      
    }else{ # if not password protected, just download
      download.file(url = url,
                    destfile = file_path,
                    mode     = "wb")
    }
    # unzip the file
    unzip(file_path,
          exdir = extract_path,
          overwrite = TRUE)
    
  } else if (zip_file == FALSE) {
    file_path <- file.path(extract_path,filename)
    
    if(pass_protected == TRUE) {
      if (!require("httr")) install.packages("httr")
      
      library(httr)
      #username <-username # readline("Type the username:") # alternatively if you want user input. gets to be a hassle because the input form asks user+pass for each separate URL
      #password <- password # readline("Type the password:")
      
      
      username <- readline("Type the username:") 
      password <- readline("Type the password:")
      GET(url = url,
          authenticate(user = username,
                       password = password),
          write_disk(file_path, overwrite = TRUE))
      
    }else{
      
      download.file(url = url,
                    destfile = file_path,
                    mode     = "wb")
    }
  }
  
}



# function to decompress files that are large
# https://stackoverflow.com/questions/42740206/r-possible-truncation-of-4gb-file
# 
decompress_file <- function(directory, file, .file_cache = FALSE) {
  
  if (.file_cache == TRUE) {
    print("decompression skipped")
  } else {
    
    # Set working directory for decompression
    # simplifies unzip directory location behavior
    wd <- getwd()
    setwd(directory)
    
    # Run decompression
    decompression <-
      system2("unzip",
              args = c("-o", # include override flag
                       file),
              stdout = TRUE)
    
    # uncomment to delete archive once decompressed
    # file.remove(file) 
    
    # Reset working directory
    setwd(wd); rm(wd)
    
    # Test for success criteria
    # change the search depending on 
    # your implementation
    if (grepl("Warning message", tail(decompression, 1))) {
      print(decompression)
    }
  }
}  
