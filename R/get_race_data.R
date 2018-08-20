api.key.install(key = 'eefec0eee1fbbd68575f1812f4cdd9b47a9fb3fb')

load_pop_data <- function() {
  require(choroplethrMaps)
  require(choroplethr)
  data(county.regions)
  data(df_pop_county)
  county_demo_data <- choroplethr::get_county_demographics(endyear=2010, span=5)
}

# get_county_demo <- function(csv.dir = "analysis/csv/") {
#   require(tidyverse)
#   require(choroplethr)
#   require(choroplethrMaps)
#   require(XML)
#   
#   counties <- read.csv(paste0(csv.dir, "city-state-county.csv"), stringsAsFactors = FALSE)
#   
#   data("county.regions")
#   counties <- left_join(counties, county.regions)
#   demog <- get_county_demographics(endyear=2013, span=5)
#   county.demo <- left_join(counties, demog)
#   
#   # Recapitalize county
#   county.demo$County <- unlist(lapply(county.demo$County, Cap_all))
#   # Hack District Of columbia...TODO(ROG): Fix Cap_all()
#   county.demo$County[county.demo$County == "District Of columbia"] = "District of Columbia"
#   county.demo <- county.demo %>%
#     mutate(state.cty = paste0(County, ", ", State))
#   
#   return(county.demo)
# }

get_race_data <- function(df) {
  county.demo %>%
    select(US.Region, Site.code, State, County, state.cty, percent_black, percent_hispanic, percent_asian, percent_white) %>%
    gather(key = race, value = pop.percent, percent_black:percent_white) ->
    county.pop.percent
  
  county.pop.percent$race <- recode(county.pop.percent$race, 
                                    percent_black = "Black", 
                                    percent_hispanic = "Hispanic",
                                    percent_asian = "Asian",
                                    percent_white = "White")
  county.pop.percent
}