# Functions for generating site report

get_census_data <- function(state="PA", county="Centre", 
                            census_table="B19013_001", variable_name="median_inc",
                            get_geometry = FALSE) {
  require(tidycensus)
  require(tidyverse)
  
  if (!(is.character(state))) {
    stop("'state' must be character")
  }
  if (!(is.character(county))) {
    stop("'county' must be character")
  }
  if (!(is.character(census_table))) {
    stop("'census_table' must be character")
  }
  if (!(is.character(variable_name))) {
    stop("'variable_name' must be character")
  }
  if (stringr::str_length(state) != 2) {
    stop("'state' must be of length 2")
  }
  
  census_data <- get_acs(geography = "county",
                         assign(variable_name, census_table),
                         state = state,
                         county = county,
                         geometry = get_geometry,
                         cache_table = TRUE)
  # super hacky
  census_data$variable_name <- variable_name
  census_data
}

get_spanish_speakers <- function(state="PA", county="Centre") {
  # total sample *001, Spanish speakers *003
  census_table <- c("B16006_001", "B16006_003")
  census_table = c("B16003_001", "B16003_004", "B16003_009")
  variable_name <- "spanish_speakers"
  get_census_data(state = state, county = county, 
                  census_table = census_table,
                  variable_name = variable_name)
}

get_total_pop <- function(state="PA", county="Centre") {
  census_table <- "C02003_001" # one race
  variable_name <- "total_pop_1_race"
  get_census_data(state = state, county = county, 
                  census_table = census_table,
                  variable_name = variable_name)
}

get_total_pop_1_race <- function(state="PA", county="Centre") {
  census_table <- "C02003_002" # one race, white
  variable_name <- "total_pop_1_race"
  get_census_data(state = state, county = county, 
                  census_table = census_table,
                  variable_name = variable_name)
}
  
get_total_pop_multi_race <- function(state="PA", county="Centre") {
  census_table <- "C02003_009" # one race, white
  variable_name <- "total_pop_mult_race"
  get_census_data(state = state, county = county, 
                  census_table = census_table,
                  variable_name = variable_name)
}

get_white_pop <- function(state="PA", county="Centre") {
  census_table <- "C02003_003" # one race, white
  variable_name <- "white_pop"
  get_census_data(state = state, county = county, 
                  census_table = census_table,
                  variable_name = variable_name)
}

get_ed_attain <- function(state="PA", county="Centre") {
  census_table <- c("B15003_001", # total
                    "B15003_002", # none
                    "B15003_003", # <K
                    "B15003_004", # K
                    "B15003_005", # 1st
                    "B15003_006", # 2nd
                    "B15003_007", # 3rd
                    "B15003_008", # 4th
                    "B15003_009", # 5th
                    "B15003_010", # 6th
                    "B15003_011", # 7th
                    "B15003_012", # 8th
                    "B15003_013", # 9th
                    "B15003_014", # 10th
                    "B15003_015", # 11th
                    "B15003_016", # 12th
                    "B15003_017", # HS
                    "B15003_018", # GED
                    "B15003_019", # Coll<1
                    "B15003_020", # Coll>1
                    "B15003_021", # AA
                    "B15003_022", # BA
                    "B15003_023", # MA
                    "B15003_024", # Prof
                    "B15003_025")  # PhD
  variable_name <- "ed_attain"
  get_census_data(state = state, county = county, 
                  census_table = census_table,
                  variable_name = variable_name)
}

make_ed_attain_wide <- function(df) {
  d0 <- dplyr::select(df, NAME, variable, estimate)
  d1 <- tidyr::spread(d0, key = variable, value = estimate)
  d2 <- dplyr::rename(d1, total = B15003_001, # total
                          none = B15003_002,  # none
                          preK = B15003_003,
                      K = B15003_004,
                      g01 = B15003_005, # 1st
                      g02 = B15003_006, # 2nd
                      g03 = B15003_007, # 3rd
                      g04 = B15003_008, # 4th
                      g05 = B15003_009, # 5th
                      g06 = B15003_010, # 6th
                      g07 = B15003_011, # 7th
                      g08 = B15003_012, # 8th
                      g09 = B15003_013, # 9th
                      g10 = B15003_014, # 10th
                      g11 = B15003_015, # 11th
                      g12 = B15003_016, # 12th
                      hs  = B15003_017, # HS
                      ged = B15003_018, # GED
                      coll_lt_1 = B15003_019, # Coll<1
                      coll_gt_1 = B15003_020, # Coll>1
                      aa = B15003_021, # AA
                      ba = B15003_022, # BA
                      ma = B15003_023, # MA
                      prof = B15003_024, # Prof
                      phd = B15003_025)  # PhD
  d2
}

simplify_ed_attain <- function(df) {
  # Calculate aggregate variables
  df_new <- df
  df_new <- dplyr::mutate(df_new,
                          lt_hs = none + preK + g01 + g02 +
                            g03 + g04 + g05 + g06 + g07 +
                            g08 + g09 + g10 + g11 + g12,
                          hs_grad = hs + ged,
                          some_coll = coll_lt_1 + coll_gt_1 + aa,
                          ba_plus = ma + prof + phd)
  df_new <- dplyr::select(df_new,
                          NAME, total, lt_hs, hs_grad, some_coll, ba,
                          ba_plus)
  df_new
}

simplify_ed_attain_p <- function(df) {
  # Calculate proportions of aggregate educational attainment variables
  df_new <- simplify_ed_attain(df)
  df_new <- dplyr::mutate(df_new,
                        p_lt_hs = lt_hs/total,
                        p_hs_grad = hs_grad/total,
                        p_some_coll = some_coll/total,
                        p_ba = ba/total,
                        p_ba_plus = ba_plus/total)
  df_new <- dplyr::select(df_new,
                          NAME,
                          p_lt_hs,
                          p_hs_grad,
                          p_some_coll,
                          p_ba,
                          p_ba_plus)
  df_new
}

tidy_ed_attain <- function(df) {
  tidyr::gather(df, ed_attain, n, -NAME)
}

plot_bar_ed_attain <- function(df) {
  require(ggplot2)
  # Drop total
  df <- dplyr::filter(df, ed_attain != 'total')
  # reorder ed_attain
  df$ed_attain <- factor(df$ed_attain, levels = c("ba_plus", "ba", 
                                                  "some_coll", "hs_grad", "lt_hs"))
  p <- ggplot(df) +
    aes(x = NAME, y = n, fill = ed_attain) +
    geom_bar(stat='identity') +
    ylab("Population") +
    xlab("County")
  p
}

plot_bar_ed_attain_p <- function(df) {
  require(ggplot2)
  # Drop total
  df <- dplyr::filter(df, ed_attain != 'total')
  # reorder ed_attain
  df$ed_attain <- factor(df$ed_attain, levels = c("p_ba_plus", "p_ba", 
                                                  "p_some_coll", "p_hs_grad", "p_lt_hs"))
  p <- ggplot(df) +
    aes(x = NAME, y = n, fill = ed_attain) +
    geom_bar(stat='identity') +
    ylab("Population") +
    xlab("County")
  p
}

get_plot_ed_attain <- function(state="PA", county="Centre") {
  ed <- get_ed_attain(state=state, county=county)
  ed_w <- make_ed_attain_wide(ed)
  ed_s <- simplify_ed_attain(ed_w)
  ed_t <- tidy_ed_attain(ed_s)
  plot_bar_ed_attain(ed_t)
}

get_plot_ed_attain_p <- function(state="PA", county="Centre") {
  ed <- get_ed_attain(state=state, county=county)
  ed_w <- make_ed_attain_wide(ed)
  ed_s <- simplify_ed_attain(ed_w)
  ed_t <- tidy_ed_attain(ed_s)
  plot_bar_ed_attain_p(ed_t)
}
