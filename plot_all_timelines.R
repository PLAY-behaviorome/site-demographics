# plot_all_timelines and make new slide deck

source("analysis/R/plot_timelines.R")
lapply(c("NYU013", "NYU018", "NYU019", "NYU020"), 
       plot_timelines, csv.dir = 'analysis/csv/')
rmarkdown::render("PLAY-timelines.Rmd")