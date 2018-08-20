county_choropleth(df_pop_county, title = "California County Population Estimates", legend        = "Population", state_zoom    = "california", reference_map = TRUE)

# show the population of the 5 counties (boroughs) that make up New York City
nyc_county_names <- c("kings", "bronx", "new york", "queens", "richmond")
nyc_county_fips <- county.regions %>%
  filter(state.name == "new york" & county.name %in% nyc_county_names) %>%
  select(region)

county_choropleth(df_pop_county, 
                  title        = "Population of Counties in New York City",
                  legend       = "Population",
                  num_colors   = 1,
                  county_zoom = nyc_county_fips$region)