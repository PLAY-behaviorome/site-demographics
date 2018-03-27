# site-demographics

Demographic characteristics of prospective PLAY project sites. This repo contains files that report on the demographic characteristics of potential data collection sites for the Play & Learning Across a Year (PLAY) project.

- [R/](R/): R scripts, helper functions
- [analysis/]/(analysis/)
    + [csv/](analysis/csv/): CSV files
- Race/ethnicity and income by county. [PDF](site_demographics.pdf). [Rmd](site_demographics.Rmd)
- Spanish-speaking by county. [PDF](spanish_speaking.pdf). [Rmd](spanish_speaking.Rmd)
- Educational attainment by county. [PDF](educational_attainment.pdf). [Rmd](educational_attainment.Rmd).
- Map of data collection sites. [PDF](site_demo_map.pdf). [Rmd](site_demo_map.Rmd)

To regenerate demographics reports and plots `source("R/render_all.R")`.