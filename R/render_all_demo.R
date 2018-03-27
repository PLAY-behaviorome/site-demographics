# renders all *.Rmd demo files in default format
out.fmts <- c("pdf_document")

rmarkdown::render("educational_attainment.Rmd", output_format = out.fmts)
rmarkdown::render("spanish_speaking.Rmd", output_format = out.fmts)
rmarkdown::render("site_demographics.Rmd", output_format = out.fmts)
rmarkdown::render("site_demo_map.Rmd", output_format = out.fmts)