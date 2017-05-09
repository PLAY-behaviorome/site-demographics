PLAY Planned Enrollment
================
Rick O. Gilmore
2017-05-09 09:32:59

Background/Rationale
--------------------

This notebook describes the projected enrollment across the *n*=30 data collection sites based upon Census data about the race and ethnicity composition of the surrounding counties.

Generate data files
-------------------

Load county names, and add county FIPS from `choroplethr` package's `county.regions` dataset. With this, I can extract demographic data using the `get_county_demographics()` function.

Note, that to access Census API, one must first acquire an API key from <http://www.census.gov/developers/>. Then, one must run `api.key.install()` to avoid throwing the API error; alternatively give the api key value as `key = <api.key>`.

``` r
counties <- read.csv(paste0(csv.dir, "city-state-county.csv"), stringsAsFactors = FALSE)

# convert counties so can pull FIPS codes
counties$County <- tolower(counties$County)

# Load county data from choroplethr
# Could also use acs package to get updated info.
data("county.regions")

counties <- left_join(counties, county.regions,
                         by = c("County" = "county.name",
                                "State" = "state.abb"))

demo <- get_county_demographics(endyear=2013, span=5)

county.demo <- left_join(counties, demo)
#str(county.demo)

# Recapitalize county
county.demo$County <- unlist(lapply(county.demo$County, Cap.all))
```

Tabular summary
---------------

Select the *n*=30 from among the 35 prospects. Then produce a tablular summary.

``` r
# Select collecting sites only
county.demo %>%
  filter(Collecting == "Collecting") ->
  county.demo

county.demo %>%
  arrange(US.Region, State, City, County) %>%
  select(US.Region, City, State, County, total_population, percent_white,
         percent_black, percent_asian, percent_hispanic) %>%
  knitr::kable()
```

| US.Region | City            | State | County               |  total\_population|  percent\_white|  percent\_black|  percent\_asian|  percent\_hispanic|
|:----------|:----------------|:------|:---------------------|------------------:|---------------:|---------------:|---------------:|------------------:|
| East      | Washington      | DC    | District Of columbia |             619371|              35|              49|               3|                 10|
| East      | Boston          | MA    | Suffolk              |             735701|              48|              20|               8|                 20|
| East      | Bethesda        | MD    | Montgomery           |             989474|              48|              17|              14|                 17|
| East      | Newark          | NJ    | Essex                |             785853|              33|              39|               5|                 21|
| East      | Princeton       | NJ    | Mercer               |             368094|              54|              19|               9|                 16|
| East      | Ithaca          | NY    | Tompkins             |             102270|              79|               4|              10|                  4|
| East      | New York        | NY    | New York             |            1605272|              48|              13|              11|                 26|
| East      | Philadelphia    | PA    | Philadelphia         |            1536704|              37|              42|               6|                 13|
| East      | University Park | PA    | Centre               |             154460|              88|               3|               5|                  3|
| East      | Providence      | RI    | Providence           |             627469|              65|               8|               4|                 19|
| East      | Arlington       | VA    | Arlington            |             214861|              64|               8|               9|                 15|
| Midwest   | Bloomington     | IN    | Monroe               |             139634|              86|               3|               6|                  3|
| Midwest   | W. Lafayette    | IN    | Tippecanoe           |             175628|              80|               4|               7|                  8|
| Midwest   | East Lansing    | MI    | Ingham               |             281531|              72|              11|               5|                  7|
| Midwest   | Columbus        | OH    | Franklin             |            1181824|              67|              21|               4|                  5|
| Midwest   | Pittsburgh      | PA    | Allegheny            |            1226933|              80|              13|               3|                  2|
| South     | Miami           | FL    | Miami-Dade           |            2549075|              16|              17|               2|                 65|
| South     | Atlanta         | GA    | Fulton               |             948554|              41|              44|               6|                  8|
| South     | New Orleans     | LA    | Orleans              |             357013|              31|              59|               3|                  5|
| South     | Nashville       | TN    | Davidson             |             638395|              57|              28|               3|                 10|
| South     | Austin          | TX    | Travis               |            1063248|              50|               8|               6|                 34|
| South     | Houston         | TX    | Harris               |            4182285|              33|              19|               6|                 41|
| South     | Richmond        | VA    | Henrico              |             311314|              56|              29|               7|                  5|
| South     | Williamsburg    | VA    | James City           |              68171|              77|              13|               3|                  5|
| West      | Davis           | CA    | Yolo                 |             202288|              49|               2|              13|                 31|
| West      | Fullerton       | CA    | Orange               |            3051771|              43|               2|              18|                 34|
| West      | Long Beach      | CA    | Los Angeles          |            9893481|              28|               8|              14|                 48|
| West      | Merced          | CA    | Merced               |             258707|              31|               3|               8|                 56|
| West      | Palo Alto       | CA    | San Mateo            |             729543|              42|               3|              25|                 25|
| West      | Palo Alto       | CA    | Santa Clara          |            1812208|              35|               2|              32|                 27|
| West      | Riverside       | CA    | Riverside            |            2228528|              39|               6|               6|                 46|
| West      | Santa Cruz      | CA    | Santa Cruz           |             264808|              59|               1|               4|                 32|
| West      | Eugene          | OR    | Lane                 |             353382|              84|               1|               2|                  8|

Calculating planned enrollment by site
--------------------------------------

We calculate expected proportions of participants based on county-level race percentages, assuming an *n*=30. Take the floor of `N_white` and the ceiling of others since we hope to increase sample diversity.

``` r
county.demo %>%
  arrange(US.Region, State, City, County) %>%
  select(US.Region, City, State, County, total_population,
         percent_white, percent_black, percent_asian,
         percent_hispanic) -> 
  county.race.ethnicity

county.race.ethnicity %>%
  mutate(N_white = floor(percent_white*30/100),
         N_black = ceiling(percent_black*30/100),
         N_asian = ceiling(percent_asian*30/100),
         N_hispanic = ceiling(percent_hispanic*30/100)) %>%
  select(County, State, N_white, N_black, N_asian, N_hispanic) %>%
  mutate(N_site = N_white + N_black + N_asian + N_hispanic) ->
  county.planned.enrollment

county.planned.enrollment %>%
  knitr::kable()
```

| County               | State |  N\_white|  N\_black|  N\_asian|  N\_hispanic|  N\_site|
|:---------------------|:------|---------:|---------:|---------:|------------:|--------:|
| District Of columbia | DC    |        10|        15|         1|            3|       29|
| Suffolk              | MA    |        14|         6|         3|            6|       29|
| Montgomery           | MD    |        14|         6|         5|            6|       31|
| Essex                | NJ    |         9|        12|         2|            7|       30|
| Mercer               | NJ    |        16|         6|         3|            5|       30|
| Tompkins             | NY    |        23|         2|         3|            2|       30|
| New York             | NY    |        14|         4|         4|            8|       30|
| Philadelphia         | PA    |        11|        13|         2|            4|       30|
| Centre               | PA    |        26|         1|         2|            1|       30|
| Providence           | RI    |        19|         3|         2|            6|       30|
| Arlington            | VA    |        19|         3|         3|            5|       30|
| Monroe               | IN    |        25|         1|         2|            1|       29|
| Tippecanoe           | IN    |        24|         2|         3|            3|       32|
| Ingham               | MI    |        21|         4|         2|            3|       30|
| Franklin             | OH    |        20|         7|         2|            2|       31|
| Allegheny            | PA    |        24|         4|         1|            1|       30|
| Miami-Dade           | FL    |         4|         6|         1|           20|       31|
| Fulton               | GA    |        12|        14|         2|            3|       31|
| Orleans              | LA    |         9|        18|         1|            2|       30|
| Davidson             | TN    |        17|         9|         1|            3|       30|
| Travis               | TX    |        15|         3|         2|           11|       31|
| Harris               | TX    |         9|         6|         2|           13|       30|
| Henrico              | VA    |        16|         9|         3|            2|       30|
| James City           | VA    |        23|         4|         1|            2|       30|
| Yolo                 | CA    |        14|         1|         4|           10|       29|
| Orange               | CA    |        12|         1|         6|           11|       30|
| Los Angeles          | CA    |         8|         3|         5|           15|       31|
| Merced               | CA    |         9|         1|         3|           17|       30|
| San Mateo            | CA    |        12|         1|         8|            8|       29|
| Santa Clara          | CA    |        10|         1|        10|            9|       30|
| Riverside            | CA    |        11|         2|         2|           14|       29|
| Santa Cruz           | CA    |        17|         1|         2|           10|       30|
| Lane                 | OR    |        25|         1|         1|            3|       30|

``` r
county.planned.enrollment %>%
  summarize(Tot_white = sum(N_white),
            Tot_black = sum(N_black),
            Tot_asian = sum(N_asian),
            Tot_hispanic = sum(N_hispanic)) %>%
  mutate(Tot_sample = Tot_white + Tot_black + Tot_asian + Tot_hispanic) %>%
  knitr::kable()
```

|  Tot\_white|  Tot\_black|  Tot\_asian|  Tot\_hispanic|  Tot\_sample|
|-----------:|-----------:|-----------:|--------------:|------------:|
|         512|         170|          94|            216|          992|

This is close to the projected total *n*=900. We will need to do some hand-tweaking, of course.

Resources
---------

This document was prepared in RStudio 1.0.143. Session information follows.

``` r
sessionInfo()
```

    ## R version 3.4.0 (2017-04-21)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Sierra 10.12.4
    ## 
    ## Matrix products: default
    ## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] choroplethrMaps_1.0.1 choroplethr_3.6.1     acs_2.0              
    ## [4] XML_3.98-1.7          plyr_1.8.4            stringr_1.2.0        
    ## [7] dplyr_0.5.0           ggplot2_2.2.1        
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.10        lattice_0.20-35     png_0.1-7          
    ##  [4] assertthat_0.2.0    rprojroot_1.2       digest_0.6.12      
    ##  [7] R6_2.2.0            backports_1.0.5     acepack_1.4.1      
    ## [10] evaluate_0.10       highr_0.6           httr_1.2.1         
    ## [13] RgoogleMaps_1.4.1   lazyeval_0.2.0      uuid_0.1-2         
    ## [16] data.table_1.10.4   geosphere_1.5-5     rpart_4.1-11       
    ## [19] Matrix_1.2-9        checkmate_1.8.2     rmarkdown_1.5      
    ## [22] proto_1.0.0         splines_3.4.0       rgdal_1.2-7        
    ## [25] udunits2_0.13       foreign_0.8-67      htmlwidgets_0.8    
    ## [28] RCurl_1.95-4.8      munsell_0.4.3       compiler_3.4.0     
    ## [31] tigris_0.5          base64enc_0.1-3     rgeos_0.3-23       
    ## [34] htmltools_0.3.6     nnet_7.3-12         tibble_1.3.0       
    ## [37] gridExtra_2.2.1     htmlTable_1.9       Hmisc_4.0-3        
    ## [40] sf_0.4-1            bitops_1.0-6        rappdirs_0.3.1     
    ## [43] grid_3.4.0          gtable_0.2.0        DBI_0.6-1          
    ## [46] WDI_2.4             pacman_0.4.5        magrittr_1.5       
    ## [49] units_0.4-4         scales_0.4.1        stringi_1.1.5      
    ## [52] mapproj_1.2-4       reshape2_1.4.2      sp_1.2-4           
    ## [55] latticeExtra_0.6-28 Formula_1.2-1       rjson_0.2.15       
    ## [58] RColorBrewer_1.1-2  tools_3.4.0         ggmap_2.6.1        
    ## [61] maps_3.1.1          jpeg_0.1-8          survival_2.41-3    
    ## [64] yaml_2.1.14         colorspace_1.3-2    cluster_2.0.6      
    ## [67] maptools_0.9-2      knitr_1.15.1
