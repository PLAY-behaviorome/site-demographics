download_save_county_demo <- function(endyear = 2010, fpath = "analysis/csv/") {
  # County data takes time to download from Census
  df <- choroplethr::get_county_demographics(endyear=endyear, span=5)
  fn <- paste0(fpath, "county_demo_data", "_", endyear, ".csv")
  write.csv(df, file = fn, row.names = FALSE)
  message(paste0("County demographic data saved in: ", fn))
}