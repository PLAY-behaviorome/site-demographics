site_vol <- 899
databraryapi::login_db("rogilmore@psu.edu")
site_ss <- databraryapi::download_session_csv(vol_id = site_vol)

site_stats <- site_ss %>%
  dplyr::group_by(., exclusion.reason) %>%
  dplyr::mutate(., n_tested = n()) %>%
  dplyr::ungroup(.)

sessions_included <- site_stats %>%
  dplyr::filter(exclusion.reason == "")

s <- sessions_included %>%
  dplyr::filter(., stringr::str_detect(participant.language, "Spanish")) %>%
  dplyr::mutate(., n_spanish = n()) %>%
  dplyr::un

compute_n_spanish <- function(df) {
  span_subs <- dplyr::filter(df, stringr::str_detect(participant.language, "Spanish"))
  dim(span_subs)[1]
}

compute_n_nonwhite <- function(df) {
  non_white <- dplyr::filter(df, participant.race != "White")
  dim(non_white)[1]
}

compute_n_spanish(sessions_included)
compute_n_nonwhite(sessions_included)

# s <- s %>%
#   dplyr::filter(., participant.race != "White") %>%
#   dplyr::mutate(., n_non_white = n())
# 
# s
