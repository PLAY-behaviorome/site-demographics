init_cap <- function(s) {
  stopifnot(is.character(s))
  paste0(toupper(str_sub(s,1,1)), str_sub(s,2,str_length(s)))
}
