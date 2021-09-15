# This script generates site-specific reports for PLAY project data
# collection sites
source("R/get_collection_site_codes.R")
library(tidyverse)

#site_data <- readr::read_csv("analysis/csv/city-state-county.csv")
site_data <- get_collection_site_county_df()

# Focus on sites recruiting from a single county to start
single_county_sites <- site_data %>%
  dplyr::filter(multi == "no")

select_single_site_data <- function() {
  site_data <- get_collection_site_county_df()
  single_county_sites <- site_data %>%
    dplyr::filter(multi == "no")
}

make_site_demog_report <- function(site_i, site_df) {
  this_site <- site_df[site_i,]
  message(paste0("Rendering report for site: ", this_site))
  rmarkdown::render("PLAY-recruiting-site-report.Rmd", 
                    params = list(state = this_site$State_prov, 
                                  counties = this_site$County), 
                    output_file = paste0("site_", 
                                         this_site$`New Site code`, ".html"),
                    output_dir = "site-rpts")
}

#make_site_demog_report(1, single_county_sites)

make_sites_demog_report <- function() {
  single_county_sites < select_single_site_data()
  n_sites <- dim(single_county_sites)[1]
  lapply(1:n_sites, make_site_demog_report, single_county_sites)  
}
