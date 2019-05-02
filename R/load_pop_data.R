load_pop_data <- function() {
  acs::api.key.install(key = 'eefec0eee1fbbd68575f1812f4cdd9b47a9fb3fb')
  require(choroplethrMaps)
  require(choroplethr)
  data(county.regions) # in choropletrMaps
  data(df_pop_county)
}