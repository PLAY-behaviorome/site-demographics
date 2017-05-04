Cap.all <- function(s, before.hyphen = TRUE) {
  # Capitalizes i) initial words, ii) words separated by a space or hypen
  # 
  # Parameters:
  # s: character array
  # before.hyphen: Logical value determining whether to capitalize
  #   words separated by a hyphen, default is TRUE
  #
  # Returns:
  #   Capitalized character array
  
  require(stringr)
  
  stopifnot(is.character(s))
  
  # Initial cap
  s <- paste0(toupper(str_sub(s,1,1)), 
              str_sub(s,2,str_length(s)))
  
  # Cap before space
  space.start <- str_locate(s, " [a-z]?")
  if (!(is.null(space.start)) && !(is.na(space.start))) {
    s <- paste0(str_sub(s, 1, space.start[1]),
                toupper(str_sub(s, space.start[2], space.start[2])),
                str_sub(s, space.start[2]+1, str_length(s)))
  }
  
  # Cap before hyphen, like miami-dade
  if (before.hyphen) {
    hyphen.start <- str_locate(s, "\\-[a-z]?")
    if (!(is.null(hyphen.start)) && !(is.na(hyphen.start))) {
      s <- paste0(str_sub(s,1, hyphen.start[1]),
                  toupper(str_sub(s, hyphen.start[2], hyphen.start[2])),
                  str_sub(s,hyphen.start[2]+1, str_length(s)))
    }
  }
  s
}