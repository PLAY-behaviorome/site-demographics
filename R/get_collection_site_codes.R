get_collection_site_data <-
  function(id = "1V9RuZJNRN4lehLzRSWO0MqVclsXPw7Z-Lxq-VQOvM-A") {
    tracking_csv <-
      googledrive::drive_download(googledrive::as_id(id),
                             path = "tracking.csv",
                             overwrite = TRUE)
    tracking_df <- readr::read_csv("tracking.csv")
    tracking_df
  }

get_collecting_labs <- function(df) {
  collecting_df <- dplyr::filter(df, Collection_role == "Collecting")
  collecting_df <- dplyr::select(collecting_df,
                                 Institution,
                                 `PI Last name`,
                                 `PI First name`,
                                 `New Site code`,
                                 City,
                                 State_prov)
  collecting_df
}

get_old_county_data <- function() {
  readr::read_csv("analysis/csv/city-state-county.csv")
}

get_collection_site_county_df <- function() {
  PLAY_all <- get_collection_site_data()
  PLAY_collecting <- get_collecting_labs(PLAY_all)
  old_collecting <- readr::read_csv("analysis/csv/city-state-county.csv")
  dplyr::left_join(PLAY_collecting, old_collecting, by=c("City"="City", "State_prov"="State"))
}

