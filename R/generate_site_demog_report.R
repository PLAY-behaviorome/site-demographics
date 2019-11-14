
site_data <- readr::read_csv("analysis/csv/city-state-county.csv")

single_county_sites <- site_data %>%
  dplyr::filter(multi == "no")

make_site_demog_report <- function(site_i, site_df) {
  this_site <- site_df[site_i,]
  rmarkdown::render("PLAY-recruiting-site-report.Rmd", 
                    params = list(state = this_site$State, 
                                  counties = this_site$County), 
                    output_file = paste0("PLAY-site-report-", 
                                         this_site$Site.code, ".html"),
                    output_dir = "site-rpts")
}

#make_site_demog_report(1, single_county_sites)
n_sites <- dim(single_county_sites)[1]
lapply(1:n_sites, make_site_demog_report, single_county_sites)



