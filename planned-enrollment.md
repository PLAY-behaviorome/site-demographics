PLAY Planned Enrollment
================
Rick O. Gilmore
2017-05-10 15:54:37

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
#counties$County <- tolower(counties$County)

# Load county data from choroplethr
# Could also use acs package to get updated info.
data("county.regions")

counties <- left_join(counties, county.regions)

demo <- get_county_demographics(endyear=2013, span=5)

county.demo <- left_join(counties, demo)

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
  arrange(US.Region, Site.code, State, County) %>%
  select(US.Region, Site.code, State, County, total_population, percent_white,
         percent_black, percent_asian, percent_hispanic) %>%
  knitr::kable()
```

| US.Region | Site.code | State | County               |  total\_population|  percent\_white|  percent\_black|  percent\_asian|  percent\_hispanic|
|:----------|:----------|:------|:---------------------|------------------:|---------------:|---------------:|---------------:|------------------:|
| East      | BU        | MA    | Suffolk              |             735701|              48|              20|               8|                 20|
| East      | CHOP      | NJ    | Camden               |             513512|              60|              18|               5|                 15|
| East      | CHOP      | NJ    | Gloucester           |             289098|              80|              10|               3|                  5|
| East      | CHOP      | PA    | Bucks                |             625977|              86|               4|               4|                  4|
| East      | CHOP      | PA    | Chester              |             503075|              82|               6|               4|                  7|
| East      | CHOP      | PA    | Delaware             |             559771|              70|              20|               5|                  3|
| East      | CHOP      | PA    | Montgomery           |             804621|              78|               9|               7|                  4|
| East      | CHOP      | PA    | Philadelphia         |            1536704|              37|              42|               6|                 13|
| East      | COR       | NY    | Tompkins             |             102270|              79|               4|              10|                  4|
| East      | CUNYSI    | NY    | Richmond             |             470223|              64|              10|               8|                 17|
| East      | GTN       | DC    | District Of columbia |             619371|              35|              49|               3|                 10|
| East      | GTN       | MD    | Montgomery           |             989474|              48|              17|              14|                 17|
| East      | GTN       | VA    | Arlington            |             214861|              64|               8|               9|                 15|
| East      | NYU       | NY    | New York             |            1605272|              48|              13|              11|                 26|
| East      | PRIN      | NJ    | Mercer               |             368094|              54|              19|               9|                 16|
| East      | PSU       | PA    | Centre               |             154460|              88|               3|               5|                  3|
| East      | RUTG      | NJ    | Essex                |             785853|              33|              39|               5|                 21|
| East      | VCU       | VA    | Chesterfield         |             320430|              65|              22|               3|                  7|
| East      | VCU       | VA    | Richmond             |             207878|              39|              49|               2|                  6|
| Midwest   | IU        | IN    | Monroe               |             139634|              86|               3|               6|                  3|
| Midwest   | MSU       | MI    | Ingham               |             281531|              72|              11|               5|                  7|
| Midwest   | OSU       | OH    | Franklin             |            1181824|              67|              21|               4|                  5|
| Midwest   | PITT      | PA    | Allegheny            |            1226933|              80|              13|               3|                  2|
| Midwest   | PUR       | IN    | Tippecanoe           |             175628|              80|               4|               7|                  8|
| South     | EMRY      | GA    | Fulton               |             948554|              41|              44|               6|                  8|
| South     | HOU       | TX    | Harris               |            4182285|              33|              19|               6|                 41|
| South     | TUL       | LA    | Orleans              |             357013|              31|              59|               3|                  5|
| South     | UMIA      | FL    | Miami-Dade           |            2549075|              16|              17|               2|                 65|
| South     | UT        | TX    | Travis               |            1063248|              50|               8|               6|                 34|
| South     | VBLT      | TN    | Davidson             |             638395|              57|              28|               3|                 10|
| South     | VCU       | VA    | Henrico              |             311314|              56|              29|               7|                  5|
| South     | WM        | VA    | James City           |              68171|              77|              13|               3|                  5|
| West      | CSF       | CA    | Orange               |            3051771|              43|               2|              18|                 34|
| West      | CSL       | CA    | Los Angeles          |            9893481|              28|               8|              14|                 48|
| West      | STAN      | CA    | San Mateo            |             729543|              42|               3|              25|                 25|
| West      | STAN      | CA    | Santa Clara          |            1812208|              35|               2|              32|                 27|
| West      | UCD       | CA    | Yolo                 |             202288|              49|               2|              13|                 31|
| West      | UCM       | CA    | Merced               |             258707|              31|               3|               8|                 56|
| West      | UCR       | CA    | Riverside            |            2228528|              39|               6|               6|                 46|
| West      | UCSC      | CA    | Santa Cruz           |             264808|              59|               1|               4|                 32|
| West      | UO        | OR    | Lane                 |             353382|              84|               1|               2|                  8|

Calculating planned enrollment by site
--------------------------------------

We calculate expected proportions of participants based on county-level race percentages, assuming an *n*=30. Take the floor of `N_white` and the ceiling of others since we hope to increase sample diversity.

``` r
county.demo %>%
  arrange(US.Region, Site.code, State, County) %>%
  select(US.Region, Site.code, State, County, total_population,
         percent_white, percent_black, percent_asian,
         percent_hispanic) -> 
  county.race.ethnicity

county.race.ethnicity %>%
  mutate(N_white = floor(percent_white*30/100),
         N_black = ceiling(percent_black*30/100),
         N_asian = ceiling(percent_asian*30/100),
         N_hispanic = ceiling(percent_hispanic*30/100)) %>%
  select(Site.code, State, County, N_white, N_black, N_asian, N_hispanic) %>%
  mutate(N_site = N_white + N_black + N_asian + N_hispanic) ->
  county.planned.enrollment
  
county.planned.enrollment %>%
  knitr::kable()
```

| Site.code | State | County               |  N\_white|  N\_black|  N\_asian|  N\_hispanic|  N\_site|
|:----------|:------|:---------------------|---------:|---------:|---------:|------------:|--------:|
| BU        | MA    | Suffolk              |        14|         6|         3|            6|       29|
| CHOP      | NJ    | Camden               |        18|         6|         2|            5|       31|
| CHOP      | NJ    | Gloucester           |        24|         3|         1|            2|       30|
| CHOP      | PA    | Bucks                |        25|         2|         2|            2|       31|
| CHOP      | PA    | Chester              |        24|         2|         2|            3|       31|
| CHOP      | PA    | Delaware             |        21|         6|         2|            1|       30|
| CHOP      | PA    | Montgomery           |        23|         3|         3|            2|       31|
| CHOP      | PA    | Philadelphia         |        11|        13|         2|            4|       30|
| COR       | NY    | Tompkins             |        23|         2|         3|            2|       30|
| CUNYSI    | NY    | Richmond             |        19|         3|         3|            6|       31|
| GTN       | DC    | District Of columbia |        10|        15|         1|            3|       29|
| GTN       | MD    | Montgomery           |        14|         6|         5|            6|       31|
| GTN       | VA    | Arlington            |        19|         3|         3|            5|       30|
| NYU       | NY    | New York             |        14|         4|         4|            8|       30|
| PRIN      | NJ    | Mercer               |        16|         6|         3|            5|       30|
| PSU       | PA    | Centre               |        26|         1|         2|            1|       30|
| RUTG      | NJ    | Essex                |         9|        12|         2|            7|       30|
| VCU       | VA    | Chesterfield         |        19|         7|         1|            3|       30|
| VCU       | VA    | Richmond             |        11|        15|         1|            2|       29|
| IU        | IN    | Monroe               |        25|         1|         2|            1|       29|
| MSU       | MI    | Ingham               |        21|         4|         2|            3|       30|
| OSU       | OH    | Franklin             |        20|         7|         2|            2|       31|
| PITT      | PA    | Allegheny            |        24|         4|         1|            1|       30|
| PUR       | IN    | Tippecanoe           |        24|         2|         3|            3|       32|
| EMRY      | GA    | Fulton               |        12|        14|         2|            3|       31|
| HOU       | TX    | Harris               |         9|         6|         2|           13|       30|
| TUL       | LA    | Orleans              |         9|        18|         1|            2|       30|
| UMIA      | FL    | Miami-Dade           |         4|         6|         1|           20|       31|
| UT        | TX    | Travis               |        15|         3|         2|           11|       31|
| VBLT      | TN    | Davidson             |        17|         9|         1|            3|       30|
| VCU       | VA    | Henrico              |        16|         9|         3|            2|       30|
| WM        | VA    | James City           |        23|         4|         1|            2|       30|
| CSF       | CA    | Orange               |        12|         1|         6|           11|       30|
| CSL       | CA    | Los Angeles          |         8|         3|         5|           15|       31|
| STAN      | CA    | San Mateo            |        12|         1|         8|            8|       29|
| STAN      | CA    | Santa Clara          |        10|         1|        10|            9|       30|
| UCD       | CA    | Yolo                 |        14|         1|         4|           10|       29|
| UCM       | CA    | Merced               |         9|         1|         3|           17|       30|
| UCR       | CA    | Riverside            |        11|         2|         2|           14|       29|
| UCSC      | CA    | Santa Cruz           |        17|         1|         2|           10|       30|
| UO        | OR    | Lane                 |        25|         1|         1|            3|       30|

``` r
county.planned.enrollment %>%
  summarize(Tot_white = sum(N_white),
            Tot_black = sum(N_black),
            Tot_asian = sum(N_asian),
            Tot_hispanic = sum(N_hispanic)) %>%
  mutate(Tot_sample = Tot_white + Tot_black + Tot_asian + Tot_hispanic,
         Pct_white = Tot_white/Tot_sample,
         Pct_black = Tot_black/Tot_sample,
         Pct_asian = Tot_asian/Tot_sample,
         Pct_hispanic = Tot_hispanic/Tot_sample) %>%
  select(Pct_white, Pct_black, Pct_asian, Pct_hispanic) %>%
  knitr::kable()
```

|  Pct\_white|  Pct\_black|  Pct\_asian|  Pct\_hispanic|
|-----------:|-----------:|-----------:|--------------:|
|   0.5477346|   0.1731392|   0.0881877|      0.1909385|

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
